# Tenant Isolation Test

Goal: prove that a user from Demo Studio A cannot see Demo Studio B's data, and the other way round.

This is a demo test. I have not run it against the ISHAN production database. Run it only on a demo Supabase project with the seed data from `sql/seed_demo_data.sql`.

## What you need first

1. Run `sql/schema.sql`, then `sql/rls_policies.sql`, then `sql/seed_demo_data.sql`.
2. Create two demo Auth users in Supabase. For the test below, call them User A and User B.
3. Add them to `company_members` with their real Auth user IDs (replace the placeholder IDs in the seed file if you need to):

```sql
-- User A, owner of Studio A
-- Replace 'REAL-USER-A-UUID' with the real Auth user ID.
insert into company_members (company_id, user_id, role)
values
  ('11111111-1111-4111-8111-111111111111', 'REAL-USER-A-UUID', 'owner')
on conflict (company_id, user_id) do nothing;

-- User B, owner of Studio B
insert into company_members (company_id, user_id, role)
values
  ('22222222-2222-4222-8222-222222222222', 'REAL-USER-B-UUID', 'owner')
on conflict (company_id, user_id) do nothing;
```

Without that step, `auth.uid()` will not match a member row, and both users will see nothing. That is also RLS working — it just means the test was not set up yet.

## Test 1 — User A tries to read Studio B's expense bills

1. Log in as **User A**.
2. In the app, set the active company to Studio A:

```sql
-- In the SQL editor, this is what the app session should do.
select set_config('app.current_company_id',
                  '11111111-1111-4111-8111-111111111111', true);
```

3. Run:

```sql
select id, title, amount_half, spent_on
from expenses
order by spent_on;
```

**Expected result:** 3 rows, all Studio A expenses — demo shampoo stock, demo microfibre cloths, demo polish stock. No Studio B rows. Studio B has its own 3 expenses (shampoo, wax, electricity bill), and none of them should appear.

4. Now try to force it. Run:

```sql
select count(*)
from expenses
where company_id = '22222222-2222-4222-8222-222222222222';
```

**Expected result:** `0`. Not an error, just no rows. RLS filters the rows out instead of telling you they exist.

## Test 2 — User A tries to read Studio B's vehicle photos

1. Still logged in as **User A**, active company Studio A.
2. Run:

```sql
select id, storage_path, caption
from vehicle_photos
order by storage_path;
```

**Expected result:** 3 rows, all with paths starting `demo-studio-a/`. No `demo-studio-b/` rows.

3. Try the direct check:

```sql
select count(*)
from vehicle_photos
where company_id = '22222222-2222-4222-8222-222222222222';
```

**Expected result:** `0`.

Do the same check for customers and bookings while you are here:

```sql
select count(*) from customers;
-- Expected for User A: 12

select count(*) from bookings;
-- Expected for User A: 25
```

## Test 3 — Switch to User B

1. Log in as **User B**, active company Studio B (`22222222-2222-4222-8222-222222222222`).
2. Run the same queries.

**Expected result:**

- `expenses`: 3 rows, Studio B only.
- `vehicle_photos`: 2 rows, `demo-studio-b/` only.
- `customers`: 9.
- `bookings`: 18.
- A direct count for Studio A's `company_id` returns `0` in every case.

## Test 4 — User A tries to write into Studio B

1. Logged in as **User A**, active company Studio A.
2. Try to insert an expense for Studio B:

```sql
insert into expenses (company_id, title, amount_half, spent_on)
values ('22222222-2222-4222-8222-222222222222',
        'Test — should fail', 1, current_date);
```

**Expected result:** the insert is denied by the RLS `with check` rule. You should get a policy error, not a new row.

3. Try to update a Studio B expense the same way. It should also be denied.

## If a test fails

Stop and check these, in order:

1. Did you run all three SQL files, in order?
2. Is RLS enabled? Run `select tablename, rowsecurity from pg_tables where schemaname = 'public';` — every tenant table should show `rowsecurity = true`.
3. Is `app.current_company_id` set to the company you think it is? Run `select current_company_id();` — it should return that company's UUID, not null.
4. Is the user actually a member of that company? Check `company_members` for their real `auth.uid()`.
5. Is the row's `company_id` really the other company's ID? A wrong seed would look like a leak, when it is just wrong data.

Do not try to fix a failing test by turning RLS off. That would hide the problem, not fix it.

## What this test does not prove

- It does not prove the front end cannot leak data. A front end could still show the wrong company's data if it caches it or calls the wrong API.
- It does not prove file storage is safe. Photo paths are strings here. Real files need the same check in Storage.
- It does not prove subscriptions are enforced. That is a separate check, and it is not in this demo.
