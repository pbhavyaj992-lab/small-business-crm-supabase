-- Small-Business CRM / Booking App — Row Level Security
-- Run schema.sql first, then this file.
--
-- The idea is simple. In plain English:
--   "You can only see rows for a company you belong to,
--    and only when you are acting as that company."
--
-- The app tells Postgres which company is active by setting
--   app.current_company_id
-- for the current request / session. In a real Supabase app that
-- value should be agreed by the server code, not trusted blindly
-- from the browser. This demo keeps the rule readable on purpose.

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Returns the company the current request is acting as.
-- Returns null when no company has been set.
create or replace function current_company_id()
returns uuid
language sql
stable
as $$
  select nullif(current_setting('app.current_company_id', true), '')::uuid;
$$;

-- True when the logged-in user is a member of the active company
-- with one of the given roles.
-- Example: has_role('owner') or has_role('admin').
create or replace function has_role(wanted_role text)
returns boolean
language sql
stable
security definer
as $$
  select exists (
    select 1
    from company_members cm
    where cm.company_id = current_company_id()
      and cm.user_id = auth.uid()
      and cm.role = wanted_role
  );
$$;

-- True when the logged-in user belongs to the active company at all.
create or replace function is_company_member()
returns boolean
language sql
stable
security definer
as $$
  select exists (
    select 1
    from company_members cm
    where cm.company_id = current_company_id()
      and cm.user_id = auth.uid()
  );
$$;

-- ---------------------------------------------------------------------------
-- Turn RLS on for every tenant table
-- ---------------------------------------------------------------------------

alter table companies enable row level security;
alter table company_members enable row level security;
alter table customers enable row level security;
alter table vehicles enable row level security;
alter table vehicle_photos enable row level security;
alter table services enable row level security;
alter table bookings enable row level security;
alter table booking_services enable row level security;
alter table invoices enable row level security;
alter table expenses enable row level security;

-- ---------------------------------------------------------------------------
-- Companies
-- You can only read a company you are a member of.
-- Only an owner can change the company row itself.
-- ---------------------------------------------------------------------------

drop policy if exists "members can read their company" on companies;
create policy "members can read their company"
  on companies for select
  to authenticated
  using (
    exists (
      select 1 from company_members cm
      where cm.company_id = companies.id
        and cm.user_id = auth.uid()
    )
  );

drop policy if exists "owners can update their company" on companies;
create policy "owners can update their company"
  on companies for update
  to authenticated
  using (has_role('owner'))
  with check (has_role('owner'));

-- No direct inserts / deletes on companies from the app in this demo.
-- A company is created by the signup flow, not by a normal user query.

-- ---------------------------------------------------------------------------
-- Company members
-- Members can see who else is in their company.
-- Only owners and admins can add or remove members.
-- ---------------------------------------------------------------------------

drop policy if exists "members can read company members" on company_members;
create policy "members can read company members"
  on company_members for select
  to authenticated
  using (company_members.company_id = current_company_id()
    and is_company_member());

drop policy if exists "admins can add members" on company_members;
create policy "admins can add members"
  on company_members for insert
  to authenticated
  with check (company_members.company_id = current_company_id()
    and (has_role('owner') or has_role('admin')));

drop policy if exists "admins can remove members" on company_members;
create policy "admins can remove members"
  on company_members for delete
  to authenticated
  using (company_members.company_id = current_company_id()
    and (has_role('owner') or has_role('admin')));

-- ---------------------------------------------------------------------------
-- Customers, vehicles, vehicle photos, services
-- A member can read and write rows for their active company only.
-- A viewer can read, but cannot write. That is handled by having
-- no insert / update / delete policy for the viewer role here:
-- viewers fall through to no policy, so the write is denied.
-- ---------------------------------------------------------------------------

drop policy if exists "members can read customers" on customers;
create policy "members can read customers"
  on customers for select
  to authenticated
  using (customers.company_id = current_company_id()
    and is_company_member());

drop policy if exists "staff can write customers" on customers;
create policy "staff can write customers"
  on customers for all
  to authenticated
  using (customers.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')))
  with check (customers.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')));

drop policy if exists "members can read vehicles" on vehicles;
create policy "members can read vehicles"
  on vehicles for select
  to authenticated
  using (vehicles.company_id = current_company_id()
    and is_company_member());

drop policy if exists "staff can write vehicles" on vehicles;
create policy "staff can write vehicles"
  on vehicles for all
  to authenticated
  using (vehicles.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')))
  with check (vehicles.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')));

drop policy if exists "members can read vehicle photos" on vehicle_photos;
create policy "members can read vehicle photos"
  on vehicle_photos for select
  to authenticated
  using (vehicle_photos.company_id = current_company_id()
    and is_company_member());

drop policy if exists "staff can write vehicle photos" on vehicle_photos;
create policy "staff can write vehicle photos"
  on vehicle_photos for all
  to authenticated
  using (vehicle_photos.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')))
  with check (vehicle_photos.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')));

drop policy if exists "members can read services" on services;
create policy "members can read services"
  on services for select
  to authenticated
  using (services.company_id = current_company_id()
    and is_company_member());

drop policy if exists "staff can write services" on services;
create policy "staff can write services"
  on services for all
  to authenticated
  using (services.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')))
  with check (services.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')));

-- ---------------------------------------------------------------------------
-- Bookings and booking services
-- Same rule: your active company only.
-- ---------------------------------------------------------------------------

drop policy if exists "members can read bookings" on bookings;
create policy "members can read bookings"
  on bookings for select
  to authenticated
  using (bookings.company_id = current_company_id()
    and is_company_member());

drop policy if exists "staff can write bookings" on bookings;
create policy "staff can write bookings"
  on bookings for all
  to authenticated
  using (bookings.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')))
  with check (bookings.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')));

drop policy if exists "members can read booking services" on booking_services;
create policy "members can read booking services"
  on booking_services for select
  to authenticated
  using (booking_services.company_id = current_company_id()
    and is_company_member());

drop policy if exists "staff can write booking services" on booking_services;
create policy "staff can write booking services"
  on booking_services for all
  to authenticated
  using (booking_services.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')))
  with check (booking_services.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')));

-- ---------------------------------------------------------------------------
-- Invoices and expenses
-- Same rule again. This is the part the isolation test checks:
-- an expense from Company B must return zero rows for a Company A user.
-- ---------------------------------------------------------------------------

drop policy if exists "members can read invoices" on invoices;
create policy "members can read invoices"
  on invoices for select
  to authenticated
  using (invoices.company_id = current_company_id()
    and is_company_member());

drop policy if exists "staff can write invoices" on invoices;
create policy "staff can write invoices"
  on invoices for all
  to authenticated
  using (invoices.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')))
  with check (invoices.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')));

drop policy if exists "members can read expenses" on expenses;
create policy "members can read expenses"
  on expenses for select
  to authenticated
  using (expenses.company_id = current_company_id()
    and is_company_member());

drop policy if exists "staff can write expenses" on expenses;
create policy "staff can write expenses"
  on expenses for all
  to authenticated
  using (expenses.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')))
  with check (expenses.company_id = current_company_id()
    and (has_role('owner') or has_role('admin') or has_role('staff')));
