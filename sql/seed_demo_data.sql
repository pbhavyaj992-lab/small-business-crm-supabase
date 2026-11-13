-- Small-Business CRM / Booking App — demo seed data
-- Run schema.sql, then rls_policies.sql, then this file.
-- All names, phones, plates and emails here are FAKE.
-- Do not use this file with real customer data.
--
-- Demo tenants:
--   A: Demo Detailing Studio A — 12 customers, 25 bookings
--   B: Demo Studio B           —  9 customers, 18 bookings
--
-- Demo user IDs below are placeholders (00000000-...-a1 / a2).
-- In a real project, replace them with real Supabase Auth user IDs
-- after you create the two demo accounts, and re-run the
-- company_members inserts with those IDs.

begin;

-- ---------------------------------------------------------------------------
-- Companies
-- ---------------------------------------------------------------------------

insert into companies (id, name, slug, email, phone, city,
                       subscription_plan, subscription_status)
values
  ('11111111-1111-4111-8111-111111111111',
   'Demo Detailing Studio A', 'demo-studio-a',
   'hello@demo-studio-a.example', '+91 98765 00001', 'Anand',
   'starter', 'active'),
  ('22222222-2222-4222-8222-222222222222',
   'Demo Studio B', 'demo-studio-b',
   'hello@demo-studio-b.example', '+91 98765 00002', 'Anand',
   'free', 'trialing')
on conflict (id) do nothing;

-- ---------------------------------------------------------------------------
-- Demo members (placeholder Auth user IDs — see note at the top)
-- ---------------------------------------------------------------------------

insert into company_members (company_id, user_id, role)
values
  ('11111111-1111-4111-8111-111111111111',
   '00000000-0000-4000-8000-0000000000a1', 'owner'),
  ('22222222-2222-4222-8222-222222222222',
   '00000000-0000-4000-8000-0000000000a2', 'owner')
on conflict (company_id, user_id) do nothing;

-- ---------------------------------------------------------------------------
-- Customers: 12 for Studio A, 9 for Studio B
-- Fake names and fake Indian-style mobile numbers only.
-- ---------------------------------------------------------------------------

insert into customers (id, company_id, full_name, phone, email, notes)
values
  -- Studio A (12)
  ('a1000000-0000-4000-8000-000000000001', '11111111-1111-4111-8111-111111111111', 'Aarav Demo',   '+91 98765 11101', 'aarav.demo@example.com',   'Prefers Saturday morning slots.'),
  ('a1000000-0000-4000-8000-000000000002', '11111111-1111-4111-8111-111111111111', 'Meera Demo',   '+91 98765 11102', 'meera.demo@example.com',   null),
  ('a1000000-0000-4000-8000-000000000003', '11111111-1111-4111-8111-111111111111', 'Rohan Demo',   '+91 98765 11103', 'rohan.demo@example.com',   'Ask before using strong polish.'),
  ('a1000000-0000-4000-8000-000000000004', '11111111-1111-4111-8111-111111111111', 'Kavya Demo',   '+91 98765 11104', 'kavya.demo@example.com',   null),
  ('a1000000-0000-4000-8000-000000000005', '11111111-1111-4111-8111-111111111111', 'Yash Demo',    '+91 98765 11105', 'yash.demo@example.com',    null),
  ('a1000000-0000-4000-8000-000000000006', '11111111-1111-4111-8111-111111111111', 'Anaya Demo',   '+91 98765 11106', 'anaya.demo@example.com',   null),
  ('a1000000-0000-4000-8000-000000000007', '11111111-1111-4111-8111-111111111111', 'Dev Demo',     '+91 98765 11107', 'dev.demo@example.com',     'Regular, every 3 weeks.'),
  ('a1000000-0000-4000-8000-000000000008', '11111111-1111-4111-8111-111111111111', 'Ishita Demo',  '+91 98765 11108', 'ishita.demo@example.com',  null),
  ('a1000000-0000-4000-8000-000000000009', '11111111-1111-4111-8111-111111111111', 'Arjun Demo',   '+91 98765 11109', 'arjun.demo@example.com',   null),
  ('a1000000-0000-4000-8000-000000000010', '11111111-1111-4111-8111-111111111111', 'Sara Demo',    '+91 98765 11110', 'sara.demo@example.com',    null),
  ('a1000000-0000-4000-8000-000000000011', '11111111-1111-4111-8111-111111111111', 'Kabir Demo',   '+91 98765 11111', 'kabir.demo@example.com',   null),
  ('a1000000-0000-4000-8000-000000000012', '11111111-1111-4111-8111-111111111111', 'Naina Demo',   '+91 98765 11112', 'naina.demo@example.com',   null),
  -- Studio B (9)
  ('b1000000-0000-4000-8000-000000000001', '22222222-2222-4222-8222-222222222222', 'Vikram Demo',  '+91 98765 22201', 'vikram.demo@example.com',  null),
  ('b1000000-0000-4000-8000-000000000002', '22222222-2222-4222-8222-222222222222', 'Priya Demo',   '+91 98765 22202', 'priya.demo@example.com',   null),
  ('b1000000-0000-4000-8000-000000000003', '22222222-2222-4222-8222-222222222222', 'Amit Demo',    '+91 98765 22203', 'amit.demo@example.com',    null),
  ('b1000000-0000-4000-8000-000000000004', '22222222-2222-4222-8222-222222222222', 'Riya Demo',    '+91 98765 22204', 'riya.demo@example.com',    null),
  ('b1000000-0000-4000-8000-000000000005', '22222222-2222-4222-8222-222222222222', 'Karan Demo',   '+91 98765 22205', 'karan.demo@example.com',   null),
  ('b1000000-0000-4000-8000-000000000006', '22222222-2222-4222-8222-222222222222', 'Sana Demo',    '+91 98765 22206', 'sana.demo@example.com',    null),
  ('b1000000-0000-4000-8000-000000000007', '22222222-2222-4222-8222-222222222222', 'Manav Demo',   '+91 98765 22207', 'manav.demo@example.com',   null),
  ('b1000000-0000-4000-8000-000000000008', '22222222-2222-4222-8222-222222222222', 'Tara Demo',    '+91 98765 22208', 'tara.demo@example.com',    null),
  ('b1000000-0000-4000-8000-000000000009', '22222222-2222-4222-8222-222222222222', 'Om Demo',      '+91 98765 22209', 'om.demo@example.com',      null)
on conflict (id) do nothing;

-- ---------------------------------------------------------------------------
-- Vehicles: one per customer (12 for A, 9 for B)
-- Fake plates only, e.g. GJ01DEMO01.
-- ---------------------------------------------------------------------------

insert into vehicles (id, company_id, customer_id, make, model, year, plate_no, colour)
values
  ('a2000000-0000-4000-8000-000000000001', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000001', 'Maruti Suzuki', 'Swift',    2021, 'GJ01DEMO01', 'White'),
  ('a2000000-0000-4000-8000-000000000002', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000002', 'Hyundai',       'i20',      2022, 'GJ01DEMO02', 'Blue'),
  ('a2000000-0000-4000-8000-000000000003', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000003', 'Tata',          'Nexon',    2023, 'GJ01DEMO03', 'Grey'),
  ('a2000000-0000-4000-8000-000000000004', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000004', 'Honda',         'City',     2020, 'GJ01DEMO04', 'Silver'),
  ('a2000000-0000-4000-8000-000000000005', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000005', 'Mahindra',      'Thar',     2022, 'GJ01DEMO05', 'Red'),
  ('a2000000-0000-4000-8000-000000000006', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000006', 'Kia',           'Sonet',    2023, 'GJ01DEMO06', 'White'),
  ('a2000000-0000-4000-8000-000000000007', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000007', 'Maruti Suzuki', 'Baleno',   2021, 'GJ01DEMO07', 'Blue'),
  ('a2000000-0000-4000-8000-000000000008', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000008', 'Hyundai',       'Creta',    2022, 'GJ01DEMO08', 'Black'),
  ('a2000000-0000-4000-8000-000000000009', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000009', 'Tata',          'Harrier',  2023, 'GJ01DEMO09', 'White'),
  ('a2000000-0000-4000-8000-000000000010', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000010', 'Honda',         'Amaze',    2019, 'GJ01DEMO10', 'Grey'),
  ('a2000000-0000-4000-8000-000000000011', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000011', 'Mahindra',      'XUV700',   2023, 'GJ01DEMO11', 'Blue'),
  ('a2000000-0000-4000-8000-000000000012', '11111111-1111-4111-8111-111111111111', 'a1000000-0000-4000-8000-000000000012', 'Maruti Suzuki', 'Wagon R',  2020, 'GJ01DEMO12', 'Silver'),
  ('b2000000-0000-4000-8000-000000000001', '22222222-2222-4222-8222-222222222222', 'b1000000-0000-4000-8000-000000000001', 'Hyundai',       'Verna',    2021, 'GJ01DEMO21', 'White'),
  ('b2000000-0000-4000-8000-000000000002', '22222222-2222-4222-8222-222222222222', 'b1000000-0000-4000-8000-000000000002', 'Maruti Suzuki', 'Swift',    2022, 'GJ01DEMO22', 'Red'),
  ('b2000000-0000-4000-8000-000000000003', '22222222-2222-4222-8222-222222222222', 'b1000000-0000-4000-8000-000000000003', 'Tata',          'Punch',    2023, 'GJ01DEMO23', 'Blue'),
  ('b2000000-0000-4000-8000-000000000004', '22222222-2222-4222-8222-222222222222', 'b1000000-0000-4000-8000-000000000004', 'Kia',           'Seltos',   2022, 'GJ01DEMO24', 'Grey'),
  ('b2000000-0000-4000-8000-000000000005', '22222222-2222-4222-8222-222222222222', 'b1000000-0000-4000-8000-000000000005', 'Honda',         'City',     2020, 'GJ01DEMO25', 'Silver'),
  ('b2000000-0000-4000-8000-000000000006', '22222222-2222-4222-8222-222222222222', 'b1000000-0000-4000-8000-000000000006', 'Mahindra',      'Scorpio',  2021, 'GJ01DEMO26', 'Black'),
  ('b2000000-0000-4000-8000-000000000007', '22222222-2222-4222-8222-222222222222', 'b1000000-0000-4000-8000-000000000007', 'Hyundai',       'i20',      2023, 'GJ01DEMO27', 'White'),
  ('b2000000-0000-4000-8000-000000000008', '22222222-2222-4222-8222-222222222222', 'b1000000-0000-4000-8000-000000000008', 'Maruti Suzuki', 'Fronx',    2023, 'GJ01DEMO28', 'Blue'),
  ('b2000000-0000-4000-8000-000000000009', '22222222-2222-4222-8222-222222222222', 'b1000000-0000-4000-8000-000000000009', 'Tata',          'Altroz',   2022, 'GJ01DEMO29', 'Grey')
on conflict (id) do nothing;

-- A few demo vehicle photos (paths only — no real files are included).
insert into vehicle_photos (company_id, vehicle_id, storage_path, caption, created_by)
values
  ('11111111-1111-4111-8111-111111111111', 'a2000000-0000-4000-8000-000000000001', 'demo-studio-a/vehicles/GJ01DEMO01/before.jpg', 'Before wash — demo photo', '00000000-0000-4000-8000-0000000000a1'),
  ('11111111-1111-4111-8111-111111111111', 'a2000000-0000-4000-8000-000000000001', 'demo-studio-a/vehicles/GJ01DEMO01/after.jpg',  'After wash — demo photo',  '00000000-0000-4000-8000-0000000000a1'),
  ('11111111-1111-4111-8111-111111111111', 'a2000000-0000-4000-8000-000000000003', 'demo-studio-a/vehicles/GJ01DEMO03/before.jpg', 'Before polish — demo photo', '00000000-0000-4000-8000-0000000000a1'),
  ('22222222-2222-4222-8222-222222222222', 'b2000000-0000-4000-8000-000000000001', 'demo-studio-b/vehicles/GJ01DEMO21/before.jpg', 'Before wash — demo photo', '00000000-0000-4000-8000-0000000000a2'),
  ('22222222-2222-4222-8222-222222222222', 'b2000000-0000-4000-8000-000000000002', 'demo-studio-b/vehicles/GJ01DEMO22/after.jpg',  'After wash — demo photo',  '00000000-0000-4000-8000-0000000000a2')
on conflict do nothing;

-- ---------------------------------------------------------------------------
-- Services: 5 per studio, prices in INR (fake demo prices)
-- ---------------------------------------------------------------------------

insert into services (id, company_id, name, description, price_half, duration_minutes)
values
  ('a3000000-0000-4000-8000-000000000001', '11111111-1111-4111-8111-111111111111', 'Basic Wash',        'Exterior wash and tyre clean.',        499,  45),
  ('a3000000-0000-4000-8000-000000000002', '11111111-1111-4111-8111-111111111111', 'Interior Cleaning', 'Seats, mats and dashboard clean.',     899,  60),
  ('a3000000-0000-4000-8000-000000000003', '11111111-1111-4111-8111-111111111111', 'Full Detailing',    'Wash, interior, polish and wax.',      2999, 180),
  ('a3000000-0000-4000-8000-000000000004', '11111111-1111-4111-8111-111111111111', 'Ceramic Coating',   'Demo ceramic coat package.',           9999, 360),
  ('a3000000-0000-4000-8000-000000000005', '11111111-1111-4111-8111-111111111111', 'Headlight Restore', 'Headlight cleaning and polish.',        799,  45),
  ('b3000000-0000-4000-8000-000000000001', '22222222-2222-4222-8222-222222222222', 'Basic Wash',        'Exterior wash and tyre clean.',        449,  45),
  ('b3000000-0000-4000-8000-000000000002', '22222222-2222-4222-8222-222222222222', 'Interior Cleaning', 'Seats, mats and dashboard clean.',     799,  60),
  ('b3000000-0000-4000-8000-000000000003', '22222222-2222-4222-8222-222222222222', 'Full Detailing',    'Wash, interior, polish and wax.',      2799, 180),
  ('b3000000-0000-4000-8000-000000000004', '22222222-2222-4222-8222-222222222222', 'Wax & Polish',      'Wax and polish only.',                 1499, 120),
  ('b3000000-0000-4000-8000-000000000005', '22222222-2222-4222-8222-222222222222', 'Engine Bay Clean',  'Engine bay clean.',                    999,  60)
on conflict (id) do nothing;

-- ---------------------------------------------------------------------------
-- Bookings: 25 for Studio A, 18 for Studio B
-- Generated from the customers / vehicles / services above, cycling
-- through them, so the counts are exact and the rows stay consistent.
-- Dates are recent demo dates, not real bookings.
-- ---------------------------------------------------------------------------

insert into bookings (company_id, customer_id, vehicle_id, booked_for, status, created_by)
select
  '11111111-1111-4111-8111-111111111111',
  c.id,
  v.id,
  timestamp '2026-10-20 09:00' + (g.n - 1) * interval '1 day'
    + ((g.n % 5) * interval '1 hour'),
  case when g.n % 7 = 0 then 'cancelled'
       when g.n % 5 = 0 then 'completed'
       else 'scheduled' end,
  '00000000-0000-4000-8000-0000000000a1'
from generate_series(1, 25) as g(n)
join lateral (
  select id from customers
  where company_id = '11111111-1111-4111-8111-111111111111'
  order by full_name
  limit 1 offset ((g.n - 1) % 12)
) c on true
join lateral (
  select id from vehicles
  where company_id = '11111111-1111-4111-8111-111111111111'
  order by plate_no
  limit 1 offset ((g.n - 1) % 12)
) v on true;

insert into bookings (company_id, customer_id, vehicle_id, booked_for, status, created_by)
select
  '22222222-2222-4222-8222-222222222222',
  c.id,
  v.id,
  timestamp '2026-10-20 10:00' + (g.n - 1) * interval '1 day'
    + ((g.n % 4) * interval '1 hour'),
  case when g.n % 6 = 0 then 'cancelled'
       when g.n % 4 = 0 then 'completed'
       else 'scheduled' end,
  '00000000-0000-4000-8000-0000000000a2'
from generate_series(1, 18) as g(n)
join lateral (
  select id from customers
  where company_id = '22222222-2222-4222-8222-222222222222'
  order by full_name
  limit 1 offset ((g.n - 1) % 9)
) c on true
join lateral (
  select id from vehicles
  where company_id = '22222222-2222-4222-8222-222222222222'
  order by plate_no
  limit 1 offset ((g.n - 1) % 9)
) v on true;

-- One service line per booking, cycling through the studio's services.
-- The offset is based on the booking date, so it stays deterministic
-- without using a window function inside the lateral join.
insert into booking_services (company_id, booking_id, service_id, price_half)
select
  b.company_id,
  b.id,
  s.id,
  s.price_half
from bookings b
join lateral (
  select id, price_half from services
  where company_id = b.company_id
  order by name
  limit 1 offset (
    (extract(day from b.booked_for)::bigint
      + extract(hour from b.booked_for)::bigint) % 5
  )
) s on true;

-- ---------------------------------------------------------------------------
-- Invoices: one for every completed booking (deterministic demo totals)
-- ---------------------------------------------------------------------------

insert into invoices (company_id, booking_id, customer_id, invoice_no,
                      total_half, status, issued_on)
select
  b.company_id,
  b.id,
  b.customer_id,
  'INV-' || left(b.company_id::text, 2) || '-' ||
    lpad(row_number() over (partition by b.company_id order by b.booked_for)::text, 3, '0'),
  coalesce(bs.total_half, 0),
  case when row_number() over (partition by b.company_id order by b.booked_for) % 3 = 0
       then 'unpaid' else 'paid' end,
  b.booked_for::date
from bookings b
left join lateral (
  select sum(price_half) as total_half
  from booking_services
  where booking_id = b.id
) bs on true
where b.status = 'completed';

-- ---------------------------------------------------------------------------
-- Expenses: a few per studio, so the isolation test has something to check
-- ---------------------------------------------------------------------------

insert into expenses (company_id, title, amount_half, spent_on, category, created_by)
values
  ('11111111-1111-4111-8111-111111111111', 'Demo shampoo stock',     2400, '2026-10-18', 'Supplies', '00000000-0000-4000-8000-0000000000a1'),
  ('11111111-1111-4111-8111-111111111111', 'Demo microfibre cloths',  850, '2026-10-22', 'Supplies', '00000000-0000-4000-8000-0000000000a1'),
  ('11111111-1111-4111-8111-111111111111', 'Demo polish stock',      1800, '2026-10-25', 'Supplies', '00000000-0000-4000-8000-0000000000a1'),
  ('22222222-2222-4222-8222-222222222222', 'Demo shampoo stock',     1900, '2026-10-19', 'Supplies', '00000000-0000-4000-8000-0000000000a2'),
  ('22222222-2222-4222-8222-222222222222', 'Demo wax stock',         1200, '2026-10-24', 'Supplies', '00000000-0000-4000-8000-0000000000a2'),
  ('22222222-2222-4222-8222-222222222222', 'Demo electricity bill',  3200, '2026-10-28', 'Utilities', '00000000-0000-4000-8000-0000000000a2')
on conflict do nothing;

commit;

-- Quick count check (run after the seed):
-- select company_id, count(*) from customers group by 1;
--   expect 12 for Studio A, 9 for Studio B
-- select company_id, count(*) from bookings group by 1;
--   expect 25 for Studio A, 18 for Studio B
-- select company_id, count(*) from expenses group by 1;
--   expect 3 and 3
