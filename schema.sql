-- 易客居房东意向表：在 Supabase -> SQL Editor 中运行
create extension if not exists pgcrypto;

create table if not exists public.owner_leads (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null check (char_length(name) between 1 and 60),
  phone text not null check (char_length(phone) between 6 and 30),
  city text not null check (char_length(city) between 1 and 80),
  property_type text not null check (char_length(property_type) between 1 and 40),
  rooms text,
  lease_term text,
  details text check (details is null or char_length(details) <= 1000),
  status text not null default '待联系'
    check (status in ('待联系','洽谈中','已签约','暂不合作')),
  admin_note text check (admin_note is null or char_length(admin_note) <= 2000)
);

alter table public.owner_leads enable row level security;

-- 明确移除默认权限，再仅开放必要操作。
revoke all on table public.owner_leads from anon, authenticated;
grant insert on table public.owner_leads to anon, authenticated;
grant select, update on table public.owner_leads to authenticated;

-- 访客只能提交新意向，不能读取、修改或删除任何记录。
drop policy if exists "public can submit owner lead" on public.owner_leads;
create policy "public can submit owner lead"
on public.owner_leads for insert to anon, authenticated
with check (
  char_length(name) between 1 and 60
  and char_length(phone) between 6 and 30
  and char_length(city) between 1 and 80
  and char_length(property_type) between 1 and 40
  and (details is null or char_length(details) <= 1000)
  and status = '待联系'
  and admin_note is null
);

-- 重要：先在 Supabase Auth 中手动创建唯一管理员用户，然后把下方 UUID
-- 替换为该管理员的真实 User UID，再执行这两条策略。
-- 不要开启公开注册。此策略限制即使其他人意外创建账号，也无法读取或修改记录。
drop policy if exists "admin can view owner leads" on public.owner_leads;
create policy "admin can view owner leads"
on public.owner_leads for select to authenticated
using (auth.uid() = 'REPLACE_WITH_ADMIN_USER_UUID'::uuid);

drop policy if exists "admin can update owner leads" on public.owner_leads;
create policy "admin can update owner leads"
on public.owner_leads for update to authenticated
using (auth.uid() = 'REPLACE_WITH_ADMIN_USER_UUID'::uuid)
with check (auth.uid() = 'REPLACE_WITH_ADMIN_USER_UUID'::uuid);

-- 不提供 delete 权限；需要删除数据时由项目所有者在数据库控制台手动处理。
