-- Small-Business CRM / Booking App — demo schema
-- Postgres / Supabase. Run this file first, then rls_policies.sql,
-- then seed_demo_data.sql.
-- Every tenant table has company_id. That is the rule this demo is built on.

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- Companies and membership
-- ---------------------------------------------------------------------------

create table if not exists companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  email text,
  phone text,
  city text,
  subscription_plan text not null default 'free'
    check (subscription_plan in ('free', 'starter', 'pro')),
  subscription_status text not null default 'trialing'
    check (subscription_status in ('trialing', 'active', 'past_due', 'cancelled')),
  subscription_ends_on date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- One row per person per company. A person can belong to more than
-- one company, but each membership is separate.
create table if not exists company_members (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies (id) on delete cascade,
  user_id uuid not null,
  role text not null default 'staff'
    check (role in ('owner', 'admin', 'staff', 'viewer')),
  created_at timestamptz not null default now(),
  unique (company_id, user_id)
);

-- ---------------------------------------------------------------------------
-- Customers, vehicles and services
-- ---------------------------------------------------------------------------

create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies (id) on delete cascade,
  full_name text not null,
  phone text,
  email text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists vehicles (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies (id) on delete cascade,
  customer_id uuid not null references customers (id) on delete cascade,
  make text not null,
  model text not null,
  year int,
  plate_no text,
  colour text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Photos of a vehicle. Kept in a separate table so we can test
-- access to them on their own, apart from the vehicle row itself.
create table if not exists vehicle_photos (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies (id) on delete cascade,
  vehicle_id uuid not null references vehicles (id) on delete cascade,
  storage_path text not null,
  caption text,
  created_by uuid,
  created_at timestamptz not null default now()
);

create table if not exists services (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies (id) on delete cascade,
  name text not null,
  description text,
  price_half numeric(10, 2) not null default 0,
  duration_minutes int,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Bookings, invoices and expenses
-- ---------------------------------------------------------------------------

create table if not exists bookings (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies (id) on delete cascade,
  customer_id uuid not null references customers (id) on delete cascade,
  vehicle_id uuid references vehicles (id) on delete set null,
  booked_for timestamptz not null,
  status text not null default 'scheduled'
    check (status in ('scheduled', 'in_progress', 'completed', 'cancelled', 'no_show')),
  notes text,
  created_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- One line per service on a booking, so a booking can have
-- more than one service and each service keeps its own price.
create table if not exists booking_services (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies (id) on delete cascade,
  booking_id uuid not null references bookings (id) on delete cascade,
  service_id uuid not null references services (id) on delete restrict,
  price_half numeric(10, 2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists invoices (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies (id) on delete cascade,
  booking_id uuid references bookings (id) on delete set null,
  customer_id uuid not null references customers (id) on delete cascade,
  invoice_no text not null,
  total_half numeric(10, 2) not null default 0,
  status text not null default 'unpaid'
    check (status in ('unpaid', 'paid', 'partial', 'cancelled')),
  issued_on date not null default current_date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (company_id, invoice_no)
);

create table if not exists expenses (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies (id) on delete cascade,
  title text not null,
  amount_half numeric(10, 2) not null default 0,
  spent_on date not null default current_date,
  category text,
  receipt_path text,
  created_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Indexes: most queries are "for this company, ordered by date"
-- ---------------------------------------------------------------------------

create index if not exists idx_company_members_user_id
  on company_members (user_id);
create index if not exists idx_company_members_company_id
  on company_members (company_id);
create index if not exists idx_customers_company_id
  on customers (company_id);
create index if not exists idx_vehicles_company_id
  on vehicles (company_id);
create index if not exists idx_vehicles_customer_id
  on vehicles (customer_id);
create index if not exists idx_vehicle_photos_company_id
  on vehicle_photos (company_id);
create index if not exists idx_vehicle_photos_vehicle_id
  on vehicle_photos (vehicle_id);
create index if not exists idx_services_company_id
  on services (company_id);
create index if not exists idx_bookings_company_id
  on bookings (company_id);
create index if not exists idx_bookings_booked_for
  on bookings (company_id, booked_for);
create index if not exists idx_booking_services_booking_id
  on booking_services (booking_id);
create index if not exists idx_invoices_company_id
  on invoices (company_id);
create index if not exists idx_expenses_company_id
  on expenses (company_id);
create index if not exists idx_expenses_spent_on
  on expenses (company_id, spent_on);
