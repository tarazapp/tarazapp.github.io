# راه‌اندازی ورود و ذخیره در پایگاه‌داده (فقط یک بار، توسط صاحب برنامه)

1. در Supabase یک پروژه بساز. از Project Settings ← API مقدار Project URL و کلید publishable/anon را بردار.
2. این دو مقدار را در فایل `config.js` بنویس. کلید service_role را هرگز نگذار.
3. در SQL Editor این دستور را اجرا کن:

```sql
create table if not exists public.taraz_backups (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.taraz_backups enable row level security;
create policy "own row" on public.taraz_backups
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

4. Authentication ← URL Configuration: آدرس سایت GitHub Pages را در Site URL و Redirect URLs بگذار (برای لینک تأیید ایمیل و بازیابی گذرواژه).
5. اگر نمی‌خواهی هر کسی حساب بسازد: Authentication ← Providers ← Email ← «Allow new users to sign up» را خاموش کن و کاربرها را دستی از Users بساز.

---
# انتشار روی GitHub Pages و چک‌لیست امنیت

1. همهٔ محتوای این پوشه را در ریشهٔ ریپو بگذار (`index.html` کنار `config.js`، `sw.js`، `manifest.webmanifest`، `vendor/`، `icons/`).
2. Settings ← Pages ← Source: شاخهٔ main و پوشهٔ root. بعد از فعال‌شدن، گزینهٔ Enforce HTTPS را روشن کن.
3. در Supabase ← SQL Editor هر دو فایل داخل `supabase/migrations` را به‌ترتیب اجرا کن (یا با `supabase db push`).
4. در Supabase ← Authentication:
   - URL Configuration: Site URL و Redirect URLs = آدرس GitHub Pages.
   - Providers ← Email: «Confirm email» روشن و حداقل طول گذرواژه ۸ یا بیشتر.
   - اگر برنامه شخصی است: «Allow new users to sign up» را بعد از ساخت حساب خودت خاموش کن.
   - Attack Protection: CAPTCHA و در صورت داشتن پلن، Leaked password protection را روشن کن.
5. روی حساب GitHub خودت احراز هویت دومرحله‌ای (2FA) بگذار.

## چه چیزی در ریپو می‌ماند و چه چیزی نه
- مجاز و امن: آدرس پروژه و کلید publishable در `config.js` (برای مرورگر ساخته شده و با RLS محدود می‌شود).
- هرگز در ریپو نگذار: رمز دیتابیس (`postgresql://...`)، کلید `service_role` و کلید secret. اگر جایی فاش شدند، همان لحظه در Supabase بچرخانشان.

## آنچه در خود برنامه انجام شده
- هر کاربر فقط به ردیف خودش دسترسی دارد (RLS) و کاربر ناشناس هیچ دسترسی‌ای ندارد.
- سیاست امنیت محتوا (CSP) با هش اسکریپت‌ها: فقط کد همین سایت اجرا می‌شود و ارتباط فقط با پروژهٔ Supabase خودت مجاز است.
- کتابخانه‌ها و فونت‌ها خودمیزبان هستند (پوشهٔ `vendor`) و به هیچ CDN خارجی وابسته نیست.
- اطلاعات مالی در مرورگر ذخیره نمی‌شود؛ فقط توکن ورود که خود Supabase مدیریت می‌کند.
- صفحه داخل iframe سایت‌های دیگر کار نمی‌کند.

## اگر کد صفحه را ویرایش کردی
اسکریپت‌های درون‌خطی `index.html` با هش در CSP ثبت شده‌اند؛ هر تغییری در آن‌ها بدون به‌روزرسانی هش اجرا نمی‌شود. تغییر `config.js` مشکلی ندارد.
