create table if not exists public.taraz_backups (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.taraz_backups enable row level security;
drop policy if exists "own row" on public.taraz_backups;
create policy "own row" on public.taraz_backups
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
