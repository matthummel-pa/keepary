# Architecture

Keepary is a single-page React application backed entirely by Supabase. There is no custom server to operate — the database, authentication, file storage, realtime, and a small amount of privileged server logic (Edge Functions) are all provided by Supabase, and the SPA is served as static assets from a CDN.

## High-level

```
React SPA (Vite build)  ──HTTPS/REST──▶  Supabase Postgres (RLS)
        │                ──Realtime───▶  chat messages & reactions
        │                ──Auth────────  email + TOTP MFA
        │                ──Storage─────  private "documents" bucket
        │                ──Functions──▶  Deno Edge Functions (service-role)
        ▼
   Netlify CDN (SPA redirects + asset caching)
```

## Frontend

- **React 18 + Vite 6.** Each screen is a self-contained component under `src/` (`Home`, `Blog` (feed), `Chat`, `Profile`, `Followers`, `FileManager`, `Notes`, `Calendar`, `Settings`, `Admin`).
- **Routing** is a lightweight `view` state in `App.jsx` rather than a router library — appropriate for an auth-gated app with a fixed nav.
- **Tailwind CSS v4** via `@tailwindcss/vite`, with a small brand layer and accessibility utility classes in `styles.css`.
- **Per-device preferences** (theme, accessibility, market) live in `localStorage`; **account-level preferences** (privacy, profile) live in Postgres.

## Backend (Supabase)

### Authentication & access
- Email/password auth with optional **TOTP multi-factor**.
- Sign-up is restricted by an `allowed_users` allowlist enforced by a database trigger — unknown emails cannot create accounts.
- A `user_roles` table maps users to WordPress-style roles (`administrator`, `editor`, `author`, `contributor`, `subscriber`, `friend`).

### Authorization (Row-Level Security)
Every table has RLS enabled. Reusable checks are implemented as `SECURITY DEFINER` SQL helper functions so policies stay readable:
- `is_allowed()` — caller is on the allowlist.
- `user_role()` / `can_write()` — role lookups.
- `is_friend()` / `in_channel(uuid)` — relationship/membership checks.

`EXECUTE` on these is granted to `authenticated` only (not `anon`).

### Data model (selected)
- **Social:** `profiles`, `relationships` (friend/follow), `blocks`, `feed_posts`, `feed_likes`, `feed_comments`.
- **Chat:** `channels`, `channel_members`, `messages`, `message_reactions` (the last two on the Realtime publication).
- **Utilities:** `notes`, `notebooks`, `todos`, `events`, `calendars`, `favorites`, `posts`.
- **Config:** `allowed_users`, `user_roles`, `app_settings`.

See [`../supabase/SCHEMA.md`](../supabase/SCHEMA.md) and [`../supabase/policies.sql`](../supabase/policies.sql).

### Storage
A single **private** bucket (`documents`) holds user files plus profile media under reserved prefixes (`_avatars/`, `_covers/`, `_gallery/`). The browser receives time-limited **signed URLs**, never public links.

### Edge Functions (Deno)
Privileged operations that need the service-role key run server-side:
- `admin` — owner/administrator user management (add user, reset, roles, 2FA reset).
- `account` — self-service account operations.
- `trending`, `summarize`, `blog`, `images`, `notion` — supporting/pending feature backends.

### Scheduled jobs
`pg_cron` runs a daily `purge_deactivated_accounts()` function that permanently deletes accounts left deactivated for more than 30 days (the soft-deactivation grace period).

## Security model

- The client only ever holds the Supabase **anon** key; all privileged writes go through RLS or Edge Functions.
- Signed URLs and a private bucket keep files from being publicly addressable.
- IP/usage details surfaced in the admin console are masked at the database layer.
- Accounts can enable 2FA, auto-lock on inactivity, and sign out everywhere.

## Deployment

- Static build (`npm run build`) deployed to Netlify.
- `netlify.toml` defines the SPA fallback redirect and long-lived caching for hashed assets.
- Environment variables (`VITE_SUPABASE_URL`, `VITE_SUPABASE_KEY`, `VITE_OWNER_EMAIL`) are injected at build time.

## Product focus

The live navigation centers on the **feed + profiles + chat** loop with vault/notes/calendar as supporting utilities. A trending-news reader, a full blog/CMS, and a tasks manager are implemented but hidden from navigation (`HIDDEN_NAV` in `App.jsx`) until they're ready to ship.
