# Supabase Security: Insert-Only Patterns for Public-Key Clients

Use this resource when the plugin collects telemetry data, stores community-contributed data, or uses shared cloud storage with a public/anon key visible in client code.

---

## Security Model

A public (anon) key visible in a client app means any user can call PostgREST as `anon`. The database must enforce authorization — never rely on frontend gating.

**Rule:** Assume requests are hostile. The DB must guarantee:

| Operation | Public permission |
|-----------|------------------|
| `SELECT`  | Denied |
| `INSERT`  | Allowed (validated) |
| `UPDATE`  | Denied |
| `DELETE`  | Denied |

---

## Architecture A (Recommended): Real Table with RLS = Insert-Only

Create a dedicated ingest table, enable RLS, grant only `INSERT`:

```sql
-- 1) Create ingest table
create table if not exists public.plugin_performance_ingest (
  id bigserial primary key,
  plugin_id uuid not null,
  user_ref text,
  payload jsonb not null,
  created_at timestamptz not null default now()
);

-- 2) Enable RLS
alter table public.plugin_performance_ingest enable row level security;

-- 3) Revoke all, grant only insert
revoke all on public.plugin_performance_ingest from anon, authenticated;
grant insert on public.plugin_performance_ingest to anon, authenticated;

-- 4) Insert-only policy
create policy "insert-only to ingest"
on public.plugin_performance_ingest
for insert
to anon, authenticated
with check (true);

-- 5) Do NOT add SELECT/UPDATE/DELETE policies
```

No `FOR SELECT` policy → reads denied (under RLS).
No `FOR UPDATE` policy → updates denied.
No `FOR DELETE` policy → deletes denied.

### Validate Inputs in WITH CHECK

Replace `with check (true)` to restrict allowable data:

```sql
create policy "insert-only valid plugin"
on public.plugin_performance_ingest
for insert
to anon, authenticated
with check (
  plugin_id in (select id from public.plugins where is_active = true)
);
```

### Extra Lockdown

```sql
revoke update, delete on public.plugin_performance_ingest from anon, authenticated;
```

---

## Architecture B: Insert via RPC Function

Use when direct table access is undesirable and writes must go through a controlled endpoint:

```sql
-- Revoke table access entirely
revoke all on public.plugin_performance_ingest from anon, authenticated;

-- Create insert-only function (SECURITY INVOKER)
create function public.ingest_plugin_data(
  p_plugin_id uuid,
  p_payload jsonb
)
returns void
language sql
security invoker
as $$
  insert into public.plugin_performance_ingest (plugin_id, payload)
  values (p_plugin_id, p_payload);
$$;

-- Grant execute only
grant execute on function public.ingest_plugin_data to anon, authenticated;
```

**Important:** Use `security invoker` — not `security definer` — to avoid privilege escalation. SECURITY DEFINER functions run as the owner and can bypass RLS.

---

## SECURITY DEFINER Views: Why to Avoid in Public Schemas

Postgres views default to `security definer`, meaning they run with the owner's privileges. If the view owner has broader access than `anon`/`authenticated`, the view can expose rows that RLS policies were supposed to restrict.

**If a view must exist, force security invoker:**
```sql
create view public.safe_view
with (security_invoker = on)
as select ...;
```

---

## Agent Prompt for Future Similar Scenarios

Copy this when generating Supabase-backed plugins:

> **Scenario:** Supabase project using a public/anon key. All external users must have INSERT allowed but SELECT/UPDATE/DELETE denied.
>
> **Rules:**
> 1. Assume requests are hostile; never rely on frontend gating
> 2. Prefer a real ingest table with `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`
> 3. Apply least-privilege grants: `REVOKE ALL` then `GRANT INSERT ONLY`
> 4. Add exactly one RLS policy: an INSERT policy with `WITH CHECK` validation
> 5. Do NOT create SELECT/UPDATE/DELETE policies for the ingest table
> 6. Avoid SECURITY DEFINER views in exposed schemas; use `security_invoker` if a view is needed
> 7. Verify the table cannot be read/updated/deleted through PostgREST (grants + RLS)
