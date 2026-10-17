# 🛡️ SPOOFY — Complete Website, Dashboard, Admin Panel & Staff Portal

```
  ███████╗██████╗  ██████╗  ██████╗ ███████╗██╗   ██╗
  ██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝╚██╗ ██╔╝
  ███████╗██████╔╝██║   ██║██║   ██║█████╗   ╚████╔╝ 
  ╚════██║██╔═══╝ ██║   ██║██║   ██║██╔══╝    ╚██╔╝  
  ███████║██║     ╚██████╔╝╚██████╔╝██║        ██║   
  ╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚═╝        ╚═╝   
```

> **Tagline:** *Your Server. Your Security. Your Control.*  
> **Brand Theme:** Clean dark charcoal (`#09090b`), white typography, purple highlights (`#7c3aed`), and official SPOOFY geometric emblem logo (`assets/spoofy_logo.png`).

**SPOOFY** is a unified, enterprise-grade Discord security, anti-nuke, moderation, disaster recovery, and music streaming platform. It features an integrated public marketing website and three completely isolated, permission-gated control panels:

1. **Public Marketing Website** (`/`, `/features`, `/security`, `/music`, `/commands`, `/premium`, `/docs`, `/status`, `/support`, `/login`, `/legal/privacy`, `/legal/terms`)
2. **Guild Dashboard** (`/dashboard` & `/dashboard/:guildId`) — For Discord server owners and moderators.
3. **Private SPOOFY Owner Admin Panel** (`/admin`) — For official project owners with cross-guild operational controls, incident response, and global feature flags.
4. **Private Staff Team Portal** (`/staff`) — For internal staff agents with ticket claiming, private investigation notes, and staff roster management.

---

## ⚡ Architecture Overview

```
                                      +-----------------------------------------+
                                      |            Discord Gateway / API         |
                                      +--------------------+--------------------+
                                                           |
                                           (discord.js events & slash commands)
                                                           |
                                                           v
+------------------------+                    +----------------------------+                    +----------------------------+
|     Public Website     |                    |    SPOOFY Bot Core Engine   |                    |   Guild Discord Members    |
|   Landing, Docs, etc.  |                    | Shield, Sentinel, Recovery |                    |   Audit Logs, Voice, Roles |
+-----------+------------+                    +--------------+-------------+                    +--------------+-------------+
            |                                                |                                                 |
            |                                                v                                                 |
            |                                 +------------------------------+                                 |
            +-------------------------------->| Express 5 Unified API Server |<--------------------------------+
                                              | Auth, Multi-Tenant Isolation |
                                              +--------------+---------------+
                                                             |
                           +---------------------------------+--------------------------------+
                           |                                 |                                |
                           v                                 v                                v
            +----------------------------+    +----------------------------+    +----------------------------+
            |      Guild Dashboard       |    |   Private Staff Portal     |    |   SPOOFY Owner Admin Panel |
            |  Anti-Nuke, Mod, Tickets   |    | Queue, Investigation Notes |    |  Cross-Guild Ops, Metrics  |
            +----------------------------+    +----------------------------+    +----------------------------+
                                                             |
                                      +----------------------+----------------------+
                                      | SQLite (Dev) / PostgreSQL (Prisma Prod)    |
                                      | Redis Cache (Rate limits & Background Jobs) |
                                      +---------------------------------------------+
```

---

## 🌐 1. Public Marketing Website

The public website introduces Discord communities to the SPOOFY ecosystem with real uptime metrics, zero fabricated numbers, and instant OAuth2 authorization:

- `/` — **Landing Page**: Interactive hero with mascots, direct Discord bot invite button, dashboard launcher, feature showcases, live status banner, and sliding-window FAQ.
- `/features` — **Feature Directory**: Breakdown of Anti-Nuke, Surveillance, Disaster Recovery, Moderation, and Music streaming capabilities.
- `/security` — **Anti-Nuke Deep-Dive**: Technical overview of sliding-window algorithms, exponential audit-log backoff, and quarantined role escalation prevention.
- `/music` — **Music Engine**: 24/7 audio playback capabilities, supported filters (bassboost, 8D, nightcore), and interactive audio commands.
- `/commands` — **Interactive Slash Command Directory**: Real-time searchable command catalog with categorization, permission badges, and syntax examples.
- `/premium` — **Premium Tiers**: Comparison table detailing guild snapshot retention, higher action thresholds, and VIP audio nodes.
- `/docs` — **Documentation**: Setup guide, role hierarchy ordering instructions, permission calculator, and best practices.
- `/status` — **Live System & Service Status**: Real-time status of Discord Gateway, SQLite/PostgreSQL storage, WebSocket streams, and Lavalink nodes.
- `/support` — **Support Server**: Direct links to community support, bug reporting, and feature request tracking.
- `/login` — **Discord OAuth2 Login**: Production-grade OAuth2 initiation with instant dev persona switchers for rapid local development.
- `/legal/privacy` — **Privacy Policy**: Clear explanation of Discord ID retention, audit trail purging, and non-retention of message content.
- `/legal/terms` — **Terms of Service**: Service availability, rate limit compliance, and acceptable usage policy.

---

## 🛡️ 2. Guild Dashboard (`/dashboard`)

Built for server owners and authorized moderators (`ManageGuild` or `Administrator`). Revalidates real Discord permissions on every single backend request:

### Multi-Server Selector (`/dashboard`)
- Discovers servers where the authenticated user has management rights.
- Shows bot installation status; eligible servers where SPOOFY is not present display a one-click invite button.
- Strict multi-tenant isolation: backend rejects any unauthorized `guildId` parameter.

### Control Tabs (`/dashboard/:guildId`)
1. **Overview**: Real-time shield switch, threat gauge, emergency lockdown trigger, active alerts breakdown, and quick navigation.
2. **Shield Settings**: Granular switches for Anti-Nuke, Anti-Raid, Anti-Bot, Anti-Webhook, Anti-Role Abuse, Anti-Channel Delete, Anti-Server Settings, Anti-Everyone, and Anti-Invite. Configurable sliding-window limits, durations, and punishments (`BAN`, `QUARANTINE`, `STRIP_ROLES`, `KICK`).
3. **Sentinel Surveillance**: Tiered alerts (`CRITICAL`, `HIGH`, `MEDIUM`, `LOW`) with actor attribution, audit logs, and interactive resolution buttons.
4. **Disaster Recovery**: Captures full hierarchy snapshots (channels, categories, roles, permissions, settings). Features diff generation and one-click rollback.
5. **Permission Scanner**: Scans for privilege escalation risks, excessive Administrator roles, and dangerous channel overwrites.
6. **Moderation Panel**: Issue warnings, apply/remove timeouts, kick, ban, unban, search past cases, and view total penalty counts.
7. **Welcome & Goodbye**: Custom welcome embeds, DM welcome switches, channel selectors, and live message preview before saving.
8. **Logging Channels**: Assign dedicated channels for moderation, security alerts, member join/leaves, message edits, and voice events.
9. **Tickets**: Ticket category selection, support role assignment, transcripts, and status tracking (`OPEN`, `CLAIMED`, `CLOSED`).
10. **Music Player**: Interactive playback controls (play, pause, skip, stop, volume slider), track requester tags, and live track queue.
11. **Raid Simulator**: Safe attack simulator to verify threshold triggers and auto-lockdown responses without endangering live members.

---

## 🔒 3. Private SPOOFY Owner Admin Panel (`/admin`)

Restricted exclusively to official SPOOFY project owners and global system administrators (`BOT_OWNER_ID` or internal `OWNER` role). Ordinary guild administrators cannot access this panel.

- **Global System Overview**: Total registered guilds, live gateway connections, active music sessions, database latency, and system alerts.
- **Cross-Guild Directory**: Search guilds across the bot's entire footprint, inspect protection health, and apply operational overrides with mandatory audit logging.
- **Global Feature Flags**: Toggle bot-wide emergency maintenance mode, feature availability, and announcement banners.
- **Incident Management**: Create, assign, and track platform-level incidents with internal investigation notes and status lifecycles.
- **System Operations**: Live sanitised error logs, database latency checks, and maintenance actions.

---

## 👥 4. Private Staff Team Portal (`/staff`)

Dedicated portal for SPOOFY staff team members with an internal role hierarchy completely independent of Discord guild permissions:

### Staff Role Hierarchy
| Role | Rank | Permissions |
| :--- | :--- | :--- |
| **OWNER** | 100 | Full access to Admin Panel, staff onboarding, role assignment, and system ops. |
| **ADMINISTRATOR** | 80 | Manage staff roster, broadcast announcements, manage incidents, triage tickets. |
| **SENIOR_STAFF** | 60 | Escalate incidents, publish internal notes, reassign tickets. |
| **MODERATOR** | 40 | Triage tickets, respond to user issues, view internal incident updates. |
| **DEVELOPER** | 35 | Inspect bug reports, review sanitised error telemetry, update incident status. |
| **SUPPORT_AGENT**| 20 | Claim and resolve support tickets, add internal investigation notes. |
| **AUDITOR** | 10 | Read-only access to staff activity logs and ticket resolution timelines. |

### Staff Features
- **Ticket Queue**: View open tickets, claim tickets to personal workload, write private internal notes, and mark tickets resolved/closed.
- **Internal Incidents**: Triage escalated community issues with severity levels and assigned team members.
- **Staff Announcements**: Publish operational memos and maintenance warnings visible only to internal staff.
- **Staff Roster Management**: Onboard staff, change internal roles, or immediately suspend access. Revocation takes effect instantly across all sessions.

---

## 🔑 5. Authentication & Authorization Model

SPOOFY enforces three distinct, independent security perimeters:

```
[Request from Browser]
         │
         ▼
[authenticateUser] ──► Validates 'spoofy_session' cookie against sessions table
         │
         ├──► Route: /api/guild/:guildId/* ──► [requireGuildPermission]
         │                                       • Confirms user owns or has ManageGuild in :guildId
         │                                       • Blocks all cross-guild data queries (403 Forbidden)
         │
         ├──► Route: /api/staff/*          ──► [requireStaff]
         │                                       • Validates active staff membership in staff_members
         │                                       • Enforces minimum rank requirement (403 Forbidden)
         │
         └──► Route: /api/admin/*          ──► [requireSystemAdmin]
                                                 • Restricts to BOT_OWNER_ID or internal OWNER role
                                                 • Strict denial for ordinary guild admins (403 Forbidden)
```

---

## 🧪 6. Automated Testing

SPOOFY includes a built-in automated security, authorization, and multi-tenant isolation test suite using Node.js's native test runner (`node:test` and `node:assert/strict`):

```bash
npm test
```

### Verified Test Cases (16/16 Passed):
- `[Pass]` Alpha moderator accesses Guild Alpha configuration.
- `[Pass]` Alpha moderator attempting to view Beta server configuration is rejected (**403 Forbidden**).
- `[Pass]` Alpha moderator attempting to alter Beta server thresholds is rejected (**403 Forbidden**).
- `[Pass]` Non-member user attempting to read audit logs is rejected (**403 Forbidden**).
- `[Pass]` Multi-tenant isolation guarantees zero data leakage between guilds.
- `[Pass]` Server admin without staff role is blocked from `/api/staff/*` (**403 Forbidden**).
- `[Pass]` Unauthenticated user is rejected with **401 Unauthorized**.
- `[Pass]` Authorized staff member successfully accesses staff overview & tickets.
- `[Pass]` Staff `MODERATOR` attempting to access `/api/admin/*` is blocked (**403 Forbidden**).
- `[Pass]` Global Project Owner successfully accesses owner admin panel.
- `[Pass]` Revoking/suspending staff access immediately blocks subsequent requests.
- `[Pass]` Dashboard settings successfully update database and bot configuration.
- `[Pass]` Action threshold updates persist and reflect in subsequent queries.
- `[Pass]` Moderation and configuration actions generate persistent audit logs.
- `[Pass]` Real system and gateway status returned at `/api/public/status`.
- `[Pass]` Full slash command directory returned at `/api/public/commands`.

---

## 🚀 7. Deployment Guide

### Option A: Docker & Docker Compose (Recommended for Production)

SPOOFY includes a multi-stage Docker build and orchestration setup with PostgreSQL and Redis:

```bash
# 1. Clone repository
git clone https://github.com/your-repo/project-spoofy.git
cd project-spoofy

# 2. Configure environment
cp .env.example .env
nano .env

# 3. Launch unified stack (Bot, API, Web, PostgreSQL, Redis)
docker compose up -d --build

# 4. View logs
docker compose logs -f spoofy
```

---

### Option B: Windows / Local Development

SPOOFY is pre-configured with an embedded, zero-setup SQLite database (`spoofy.sqlite`) with WAL mode enabled:

```powershell
# 1. Install dependencies
npm install
cd dashboard
npm install
npm run build
cd ..

# 2. Configure .env
Copy-Item .env.example .env
notepad .env

# 3. Run test suite
npm test

# 4. Start SPOOFY Unified Server
npm start
```

Visit **[http://localhost:4000](http://localhost:4000)** in your browser.

> **Testing Without Live Discord Bot**:
> If you have not yet created a bot application in the Discord Developer Portal, SPOOFY automatically boots in **Simulator & Dashboard Mode**. You can immediately click **Login with Discord** -> **Instant Dev Personas** to test the Server Owner, Staff Member, or Project Owner experiences!

---

### Option C: Linux VPS Deployment (Ubuntu / Debian)

#### 1. System Setup
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y nodejs npm git nginx certbot python3-certbot-nginx
sudo npm install -g pm2
```

#### 2. Project Installation
```bash
git clone https://github.com/your-org/project-spoofy.git /var/www/spoofy
cd /var/www/spoofy
npm install
cd dashboard && npm install && npm run build && cd ..
cp .env.example .env
nano .env
```

#### 3. PM2 Process Manager
```bash
pm2 start src/index.js --name "spoofy"
pm2 save
pm2 startup
```

#### 4. Nginx Reverse Proxy with HTTPS & WebSockets
Create `/etc/nginx/sites-available/spoofy.conf`:
```nginx
server {
    server_name spoofy.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable site and acquire free SSL certificate:
```bash
sudo ln -s /etc/nginx/sites-available/spoofy.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d spoofy.yourdomain.com
```

---

## ⚙️ 8. Discord Developer Portal Setup

To connect SPOOFY to real Discord servers:

1. Navigate to the **[Discord Developer Portal](https://discord.com/developers/applications)**.
2. Click **New Application**, name it `SPOOFY`, and upload `assets/spoofy_mascot.jpg` as the icon.
3. Under **Bot**:
   - Click **Reset Token** and copy into `DISCORD_TOKEN` in `.env`.
   - Enable **Privileged Gateway Intents**:
     - `Server Members Intent` (Required for join-raid detection and member protection)
     - `Message Content Intent` (Required for anti-phishing, invite detection, and moderation)
4. Under **OAuth2** -> **General**:
   - Copy **Client ID** into `CLIENT_ID`.
   - Copy **Client Secret** into `DISCORD_CLIENT_SECRET`.
   - Add **Redirects**:
     - `http://localhost:4000/api/auth/discord/callback` (Local dev)
     - `https://spoofy.yourdomain.com/api/auth/discord/callback` (Production)
5. Under **OAuth2** -> **URL Generator**:
   - Scopes: `bot`, `applications.commands`, `identify`, `guilds`.
   - Bot Permissions: `Administrator` (Recommended for anti-nuke defense at the top of role hierarchy).

---

## 💾 9. Database Backup & Disaster Recovery

- **SQLite (Default Dev)**: Automated backups can be taken by copying `spoofy.sqlite`:
  ```bash
  cp spoofy.sqlite backups/spoofy_$(date +%Y%m%d_%H%M%S).sqlite
  ```
- **PostgreSQL (Production)**:
  ```bash
  pg_dump -U spoofy -d spoofy -F c -b -v -f /backups/spoofy_backup.dump
  ```
- **Prisma Migrations**:
  ```bash
  npx prisma migrate dev --name init
  ```

---

## 📄 10. License & Support

Distributed under the MIT License. Built with precision for the Discord security community.

- **Discord Support**: [Join SPOOFY Operations HQ](https://discord.gg)
- **Security Inquiries**: `security@spoofy.dev`


## GitHub setup and secret safety

1. Copy `.env.example` to `.env` locally and fill in your own credentials.
2. Never commit `.env`, bot tokens, OAuth client secrets, passwords, or production database URLs.
3. Configure the same values as environment variables in your hosting provider before deployment.
4. The SQLite database is local runtime data and is intentionally excluded from this repository.
5. If a real Discord token or OAuth secret was ever included in an uploaded archive or pushed to GitHub, revoke/rotate it in the Discord Developer Portal immediately. Removing it from a later commit does not make an exposed credential safe.

### Local install

```bash
npm install
cd dashboard && npm install && npm run build && cd ..
cp .env.example .env
npm start
```

On Windows PowerShell, use `Copy-Item .env.example .env` instead of `cp` if needed.
