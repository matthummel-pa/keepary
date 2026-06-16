# Security Policy

## Reporting a vulnerability

If you discover a security vulnerability in Keepary, please **do not open a public issue**.
Instead, report it privately through GitHub's [Security Advisories](../../security/advisories/new) feature, or contact the maintainer directly.

Please include:

- A description of the vulnerability and its impact
- Steps to reproduce
- Any relevant logs or proof-of-concept

You can expect an acknowledgement within a few days.

## Security model (summary)

- **Access control:** sign-up is gated by an `allowed_users` allowlist enforced by a database trigger.
- **Authorization:** every table is protected by Postgres Row-Level Security; privileged checks run in `SECURITY DEFINER` helper functions with `EXECUTE` restricted to authenticated users.
- **Secrets:** the browser only ever receives the Supabase **anon** key. Service-role keys live exclusively in server-side Edge Functions.
- **Account protection:** optional TOTP two-factor authentication, inactivity auto-lock, and global sign-out.
- **Data lifecycle:** users can export their data and soft-deactivate; deactivated accounts are permanently purged after 30 days by a scheduled job.

## Supported versions

This is an actively developed personal project; only the latest `main` is supported.
