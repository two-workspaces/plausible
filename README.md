# Deploy and Host Plausible Analytics on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/plausible-web-analytics?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=plausible-web-analytics)

[Plausible Analytics](https://plausible.io/) is a lightweight, open-source alternative to Google Analytics. It shows visitors, page views, sources, UTM campaigns, countries, devices, goals, funnels and custom events on one simple dashboard, without cookies and without collecting personal data. This template runs Plausible Community Edition 3.2.1 from the official image with ClickHouse for events and Postgres for accounts, and creates your admin account on the first boot.

## About Hosting Plausible Analytics

The stack is three services: Plausible, ClickHouse and Postgres.

- **Upstream's images, pinned.** Plausible runs `ghcr.io/plausible/community-edition:v3.2.1`, and ClickHouse runs 24.12, the version Plausible CE ships with. Thin wrappers ([source](https://github.com/two-workspaces/plausible)) add a start script and config files; upgrading means bumping the tags.
- **Admin on first boot.** Plausible normally gives the instance to whoever opens the registration page first. Here the admin is created from `ADMIN_USER_EMAIL` and the generated `ADMIN_USER_PWD` before the server starts, and registration is invite-only from the start.
- **Migrations on every start.** The start script creates the databases if needed and runs Plausible's migrations, so upgrades migrate themselves.
- **ClickHouse tuned for small instances.** Upstream's low-resource settings, logs to the console instead of files on disk, ClickHouse's own telemetry tables switched off, and transparent huge pages disabled for its allocator, which keeps idle memory flat on Railway.
- **Private databases.** ClickHouse and Postgres have no public endpoint; ClickHouse has a generated password.
- **Healthchecked.** Railway's healthcheck calls `/api/health`, which reports ok only when Postgres, ClickHouse and the caches are ready.

## Common Use Cases

- Website analytics without cookie banners, for sites that care about GDPR, CCPA and PECR
- One dashboard for many sites: company site, blog, docs and web app
- Goals, funnels, revenue and UTM campaign tracking for marketing teams
- Public or password-protected dashboards shared with clients or your community
- Importing history from Google Analytics or CSV and leaving it behind

## Dependencies for Plausible Analytics Hosting

- ClickHouse 24.12 (included, private network only)
- Postgres 17 (included, private network only)

### Deployment Dependencies

- [Plausible CE documentation](https://github.com/plausible/community-edition)
- [Configuration reference](https://github.com/plausible/community-edition/wiki/configuration)
- [Plausible on GitHub](https://github.com/plausible/analytics)
- [Template source on GitHub](https://github.com/two-workspaces/plausible)

### Implementation Details

**Before you deploy**, fill in `ADMIN_USER_EMAIL`. That's the email you sign in with.

**Sign in.** When the deploy is green, open your Plausible domain and sign in with `ADMIN_USER_EMAIL` and the password in the Plausible service's `ADMIN_USER_PWD` variable. The variables are only read on the first boot; change the password in Plausible afterwards (Settings, Security).

**Track a site.** Add a website in Plausible, then paste the snippet it shows into your site's `<head>`. The script and the event endpoint are served from your Plausible domain.

**Team members.** Invite people from Site settings, People. Invitations are sent by email, so set up a mailer first. Plausible can send through HTTP APIs, which work on every Railway plan: set `MAILER_ADAPTER` to `Bamboo.PostmarkAdapter` with `POSTMARK_API_KEY`, or `Bamboo.MailgunAdapter` with `MAILGUN_API_KEY` and `MAILGUN_DOMAIN`, or `Bamboo.SendGridAdapter` with `SENDGRID_API_KEY`, plus `MAILER_EMAIL` as the sender. Plain SMTP only works on Railway's Pro plan.

**Custom domains.** Add the domain to the Plausible service in Railway, then set `BASE_URL` to `https://your.domain` and update the snippet on your sites.

**Google Search Console and Google Analytics import.** Set `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` as described in the [configuration reference](https://github.com/plausible/community-edition/wiki/configuration#google).

**Upgrading.** Bump the image tag in the Dockerfile of your fork and redeploy. Migrations run on start; back up both databases before a major version.

**Back up.** Events are in ClickHouse, accounts and sites in Postgres. Use Railway's volume backups on both.

**Resources.** After boot Plausible uses about 550 MB of RAM, ClickHouse about 400 MB and Postgres about 120 MB, so plan for the Hobby plan. ClickHouse grows with traffic but stores events very compactly.

## Why Deploy Plausible Analytics on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Plausible Analytics on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
