-- سخت‌تر کردن دسترسی: فقط کاربر واردشده، فقط ردیف خودش، حجم محدود
revoke all on public.taraz_backups from anon;
revoke all on public.taraz_backups from public;
grant select, insert, update, delete on public.taraz_backups to authenticated;

drop policy if exists "own row" on public.taraz_backups;
drop policy if exists "own select" on public.taraz_backups;
drop policy if exists "own insert" on public.taraz_backups;
drop policy if exists "own update" on public.taraz_backups;
drop policy if exists "own delete" on public.taraz_backups;
create policy "own select" on public.taraz_backups for select to authenticated using ((select auth.uid()) = user_id);
create policy "own insert" on public.taraz_backups for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "own update" on public.taraz_backups for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "own delete" on public.taraz_backups for delete to authenticated using ((select auth.uid()) = user_id);

alter table public.taraz_backups drop constraint if exists taraz_payload_size;
alter table public.taraz_backups add constraint taraz_payload_size check (pg_column_size(payload) < 5 * 1024 * 1024);
