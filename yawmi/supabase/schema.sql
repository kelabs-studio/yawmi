-- Yawmi: one private JSON document per authenticated Supabase user.
create table if not exists public.yawmi_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.yawmi_data enable row level security;
revoke all on public.yawmi_data from anon, public;
grant select, insert, update, delete on public.yawmi_data to authenticated;

drop policy if exists "Users can access their own Yawmi data" on public.yawmi_data;
create policy "Users can access their own Yawmi data"
on public.yawmi_data
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
