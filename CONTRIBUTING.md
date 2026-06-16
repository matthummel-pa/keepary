# Contributing to Keepary

Thanks for your interest! Keepary is primarily a personal portfolio project, but issues and pull requests are welcome.

## Development setup

1. Fork and clone the repo.
2. `npm install`
3. `cp .env.example .env` and fill in a Supabase project's values.
4. `npm run dev`

## Branching & commits

- Branch from `main`: `git checkout -b feat/short-description`.
- Use [Conventional Commits](https://www.conventionalcommits.org/) where practical: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`.
- Keep PRs focused and reasonably small.

## Before you open a PR

```bash
npm run lint      # no lint errors
npm run format    # consistent formatting
npm run build     # builds cleanly
```

CI runs the production build on every push and pull request — please make sure it's green.

## Code style

- React function components with hooks; no class components.
- Tailwind utility classes for styling (Tailwind v4).
- Keep components self-contained and colocate state with the UI that uses it.
- Never commit secrets. Client code may only use the Supabase **anon** key.

## Reporting bugs / requesting features

Use the issue templates under **Issues → New issue**. Include reproduction steps and your environment for bugs.
