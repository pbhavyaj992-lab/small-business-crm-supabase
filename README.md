# Supabase CRM / Booking App — Demo

I built this as a demo. It is not a production system.

I wanted an example I could show a client in a few minutes. It looks like the kind of CRM a detailing studio, a garage, or a service business would use. I based the idea on the work I did on ISHAN Detailing OS — the real product is live at https://getishan.in — but this is a fresh demo. I did not copy any production code from ISHAN into it.

## What it does

- A business signs up and gets its own company workspace.
- Staff can add customers and their vehicles.
- Staff can create bookings, add services to a booking, and make an invoice.
- Staff can log expenses.
- Each company only sees its own data.

That last point is the main one. If you run two studios, Studio A cannot see Studio B's customers, bookings, invoices, or expenses.

## What is in this folder

- `sql/schema.sql` — the tables.
- `sql/rls_policies.sql` — Row Level Security. This is what keeps companies apart.
- `sql/seed_demo_data.sql` — fake data for two demo studios. No real customers.
- `docs/architecture.md` — how the pieces fit together.
- `docs/tenant_isolation_test.md` — how to check that the isolation works.
- `docs/demo_script.md` — a 2-minute demo flow.
- `.env.example` — placeholder settings only. No real keys.

## How to try it

1. Create a free Supabase project.
2. Run `sql/schema.sql`, then `sql/rls_policies.sql`, then `sql/seed_demo_data.sql` in the SQL editor.
3. Add your Supabase URL and anon key to a copy of `.env.example` called `.env.local`.
4. Build a simple front end on top of it. I have not included one here on purpose. The database is the part I wanted to show.

## What a client would get

If a real business asked me to build this for them, I would not ship this demo as it is. I would:

- Add their real services, prices, and staff roles.
- Add their branding and their booking flow.
- Add a proper subscription check in the app, not just in the database.
- Test the isolation again with their real staff accounts.
- Add simple reports: bookings this week, money in, money out.

## Limits of this demo

- The data is fake.
- There is no front end in this folder.
- The subscription fields are just columns. They do not charge anyone.
- I have not tested this with a large number of users. It is a demo for two studios.

## Tech used

Postgres, Supabase Auth, Row Level Security. That is it.

## Contact

If you want me to build a version like this for your business, tell me what services you offer, how bookings work now, and who should see what. I can work from there.
