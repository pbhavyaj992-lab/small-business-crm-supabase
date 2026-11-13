# Demo Script — 2 Minutes

Use this when you show the app to a client or a friend. Keep it to 2 minutes. Do not explain the database first. Show the work first, then the isolation.

You need the seed data loaded first (`sql/seed_demo_data.sql`). Use Demo Studio A first, then Demo Studio B.

## 0:00–0:20 — Log in as Demo Studio A

- Say: "This is Demo Detailing Studio A. I am logged in as the owner."
- Show the list of customers. Point out: "12 demo customers. All fake names."
- Open one customer, for example Aarav Demo, and show their vehicle.

## 0:20–0:50 — Create a booking

- Click "New booking".
- Pick a customer and a vehicle.
- Pick a date and time for tomorrow.
- Say: "A booking is just a customer, a vehicle, and a time. Nothing more."

## 0:50–1:20 — Add a service and make an invoice

- Add a service to that booking. For example, "Full Detailing".
- Show the price coming from the service list.
- Generate the invoice.
- Say: "The invoice takes the service price from the booking, so no one has to type it twice."

## 1:20–1:50 — Switch to Demo Studio B

- Log out, then log in as Demo Studio B.
- Say: "Now I am a different studio. Same app, different login."
- Show the customers list. Point out: "9 customers here. None of the Studio A customers are here."
- Show bookings: "18 bookings here, not the 25 from Studio A."
- Show expenses: "Only Studio B's expenses. Studio A had its own three."

## 1:50–2:00 — Show the subscription page

- Open the subscription / company page for Studio B.
- Say: "Studio B is on the free trial. Studio A is on the starter plan. The plan is stored on the company, not on each user."
- Stop there. Ask: "What would you want different for your business?"

## If they ask questions

- **"Can staff see everything?"** — "No. Owners and admins manage members. Staff do the day-to-day work. Viewers can only read."
- **"Can you add my services?"** — "Yes. Services, prices, and booking times are just data. I would add yours when I set it up."
- **"Is my data safe from other businesses?"** — "That is what the test in `docs/tenant_isolation_test.md` checks. Each company only sees its own rows."
- **"Can I try it?"** — "Yes, on the demo. I would set up your own company for a real trial, not share the demo login."

## What not to say

- Do not say this demo is a production system. It is not.
- Do not say a real client is using it. No real client is in the seed data.
- Do not promise a price or a date on the spot. Say you will work it out after you know their services and staff.
