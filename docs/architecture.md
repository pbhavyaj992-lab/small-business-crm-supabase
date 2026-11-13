# Architecture — Small-Business CRM / Booking App (Demo)

This is a demo, not a production system. The point is to show the shape of a real multi-tenant app, without the production parts.

## The flow

```
Browser / simple front end
  -> Supabase Auth (login)
  -> Supabase Postgres
  -> Row Level Security (RLS) checks every row
  -> Only rows for the active company come back
```

There is no separate back-end server in this demo. The database does the hard work: it checks who you are and which company you are acting as, before it returns any row.

## What each part does

- **Browser / front end:** the screens a staff member sees. Not included in this folder. Any simple front end can call Supabase.
- **Supabase Auth:** login. Each person gets a user ID (`auth.uid()`).
- **Postgres:** the tables in `sql/schema.sql`.
- **RLS:** the rules in `sql/rls_policies.sql`. Every table that belongs to a company has RLS turned on.
- **Current company:** the app sets `app.current_company_id` for a request. The RLS rules use `current_company_id()` to know which company is active. In a real app, the server must agree that value. Do not let the browser set it on its own.

## Tables

| Table | What it holds | Company-scoped? |
|---|---|---|
| `companies` | One row per business | Yes — you only read companies you belong to |
| `company_members` | Who belongs to which company, and their role | Yes |
| `customers` | Customers of a company | Yes, `company_id` |
| `vehicles` | A customer's vehicle | Yes, `company_id` |
| `vehicle_photos` | Photo paths for a vehicle | Yes, `company_id` |
| `services` | What the company sells, and its price | Yes, `company_id` |
| `bookings` | A booking for a customer and vehicle | Yes, `company_id` |
| `booking_services` | Services on a booking, with the price at booking time | Yes, `company_id` |
| `invoices` | Invoice for a booking / customer | Yes, `company_id` |
| `expenses` | Money spent by the company | Yes, `company_id` |

Every tenant table has `company_id`. That is the rule. If a new table is added later and it forgets `company_id`, it will not be isolated. Check that first.

## Roles

- **owner:** can change the company and manage members.
- **admin:** can manage members and do day-to-day work.
- **staff:** can do day-to-day work — customers, bookings, invoices, expenses.
- **viewer:** can read, cannot write. There is no write policy for viewers, so a write is denied.

The `has_role()` helper in `rls_policies.sql` checks the role for the active company only. A person who is an owner in Studio A is not automatically an owner in Studio B.

## Subscription enforcement — test mode only

The `companies` table has:

- `subscription_plan` — `free`, `starter`, or `pro`
- `subscription_status` — `trialing`, `active`, `past_due`, or `cancelled`
- `subscription_ends_on` — a date

In this demo, those are just columns. They do **not** charge anyone, and they do **not** block access on their own.

A real version would need:

1. A payment provider. In my ISHAN work I used Razorpay Subscriptions. For a new client, I would ask which provider they already use before I pick one.
2. A server check before a booking or invoice is created: is this company's subscription active?
3. A clear message for the user when a plan has ended: what they can still see, and what they cannot do until they renew.

No real keys are in this folder. Do not put a payment key in a browser app.

## What is not here

- No front end.
- No email or SMS reminders.
- No payment code.
- No file storage bucket. `vehicle_photos.storage_path` and `expenses.receipt_path` are just paths. A real app would store the files in Supabase Storage and check the same company rule there too.
- No reports page. The data is there to build one: bookings by week, money in from invoices, money out from expenses.
