<div align="center">

<img src="brand/keepary-logo.svg" alt="Keepary" width="96" height="96" />

# Keepary

**A private, invite-only social space for families and close friends — the calm internet, without the algorithm.**

[![CI](https://github.com/REPO_OWNER/keepary/actions/workflows/ci.yml/badge.svg)](https://github.com/REPO_OWNER/keepary/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-7c3aed.svg)](LICENSE)
[![React](https://img.shields.io/badge/React-18-2563eb?logo=react&logoColor=white)](https://react.dev)
[![Vite](https://img.shields.io/badge/Vite-6-646CFF?logo=vite&logoColor=white)](https://vitejs.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Postgres%20%7C%20Auth%20%7C%20Storage-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-v4-38BDF8?logo=tailwindcss&logoColor=white)](https://tailwindcss.com)

</div>

---

## Overview

Keepary is a self-contained "social, but only us" web app: a private feed, member profiles, and real-time chat for an invite-only circle of family and friends — with a handful of supporting utilities (document vault, notes, calendar). No ads, no algorithmic ranking, no data harvesting. Access is gated by an explicit allowlist, and every table is protected by Postgres Row-Level Security.

It was built as an end-to-end product: authentication, authorization, real-time data, file storage, a serverless backend, two production deployments, and a full privacy/security surface (2FA, account deactivation, data export, blocking).

> **Live demo:** https://keepary.netlify.app — _invite-only; the sign-up page is allowlist-gated by design._

## Highlights

- 🔐 **Real auth & RLS** — Supabase Auth with an email allowlist enforced by a signup trigger, plus Row-Level Security policies on every table.
- 🛡️ **Security surface** — TOTP two-factor auth, inactivity auto-lock, password strength metering, "sign out everywhere," and WordPress-style roles (administrator → subscriber → friend).
- 🧑‍🤝‍🧑 **Social graph** — one-way follows and mutual friend requests, a member directory, and per-page friend visibility controls.
- 💬 **Real-time chat** — Slack/Discord-style channels and DMs with live updates and emoji reactions over Supabase Realtime.
- 📰 **Private feed** — Bluesky-style posts with likes, comments, and sharing, visible only inside your circle.
- 🪪 **Rich profiles** — LinkedIn/Bluesky-inspired cards with experience, education, skills, social links, and animated photo / video / split covers.
- ♿ **Accessibility** — text scaling, high-contrast mode, reduced motion, dyslexia-friendly typography, and link underlining.
- 🔏 **Privacy & data rights** — discoverability and request controls, user blocking, JSON data export, and Facebook/Google-style soft account deactivation with a 30-day grace period (auto-purged by a scheduled job).
- 🗂️ **Supporting utilities** — private document vault, rich-text notes with notebooks, and a personal calendar with shareable color-coded calendars.

## Tech stack

| Layer | Technology |
| --- | --- |
| Frontend | React 18, Vite 6, Tailwind CSS v4 |
| Backend | Supabase — Postgres, Auth (TOTP MFA), Storage, Edge Functions (Deno), Realtime |
| Data security | Row-Level Security on every table; `SECURITY DEFINER` helper functions |
| Scheduling | `pg_cron` (daily account-purge job) |
| Hosting | Netlify (SPA + redirects + asset caching) |
| Tooling | ESLint, Prettier, GitHub Actions CI, Dependabot |

## Architecture

```
┌─────────────────────────────┐         ┌──────────────────────────────────┐
│  React SPA (Vite)           │  HTTPS  │  Supabase                        │
│  • feed / chat / profiles   │ ──────▶ │  • Postgres + Row-Level Security │
│  • vault / notes / calendar │         │  • Auth (email + TOTP MFA)       │
│  • settings / admin console │ ◀────── │  • Storage (private bucket)      │
│                             │ Realtime│  • Edge Functions (Deno)         │
└─────────────────────────────┘         │  • pg_cron scheduled jobs        │
            │  served by                └──────────────────────────────────┘
            ▼
       Netlify CDN
```

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the data model, security model, and request flows, and [`supabase/SCHEMA.md`](supabase/SCHEMA.md) for the schema.

## Getting started

### Prerequisites

- Node.js 20+
- A free [Supabase](https://supabase.com) project

### 1. Install

```bash
git clone https://github.com/REPO_OWNER/keepary.git
cd keepary
npm install
```

### 2. Configure

Copy the example env file and fill in your Supabase project values:

```bash
cp .env.example .env
```

```ini
VITE_SUPABASE_URL=https://YOUR-PROJECT.supabase.co
VITE_SUPABASE_KEY=your-anon-public-key
VITE_OWNER_EMAIL=you@example.com   # account treated as the owner/admin
```

> Only the **anon/public** key belongs in the client. Never ship a service-role key to the browser.

### 3. Run

```bash
npm run dev      # start the dev server
npm run build    # production build
npm run preview  # preview the production build
npm run lint     # lint
npm run format   # format with Prettier
```

## Backend setup (Supabase)

This repo ships the SQL and Edge Function references the app expects:

- [`supabase/SCHEMA.md`](supabase/SCHEMA.md) — tables, columns, and relationships.
- [`supabase/policies.sql`](supabase/policies.sql) — Row-Level Security policies and helper functions.
- [`supabase/migrations/`](supabase/migrations) — incremental schema migrations.

Apply the schema and policies to your Supabase project, create a **private** Storage bucket named `documents`, enable Realtime on the chat tables, and add your email to the `allowed_users` table to grant access.

## Deployment

The app is a static SPA and deploys to any static host. A [`netlify.toml`](netlify.toml) is included with the SPA redirect and asset-caching headers. Set `VITE_SUPABASE_URL`, `VITE_SUPABASE_KEY`, and `VITE_OWNER_EMAIL` as build environment variables.

## Project status

Keepary is an active personal project and portfolio piece. The live experience is intentionally focused on the **feed + profiles + chat** loop with vault/notes/calendar as supporting utilities. Additional modules (a trending-news reader, a full blog/CMS with cross-posting, and a tasks manager) are built and retained in the codebase as **pending features**, hidden from navigation until they're ready to ship.

## License

[MIT](LICENSE) © Matt Hummel

<div align="center"><sub>Built with care for the people who matter. · <a href="https://matthummel.com">matthummel.com</a></sub></div>
