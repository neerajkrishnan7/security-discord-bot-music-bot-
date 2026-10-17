# SPOOFY — Fixed Role Security Command Configuration Guide

This guide details the three methods to restrict SPOOFY security, moderation, and music commands to fixed server roles so that standard members are blocked and only authorized roles have command execution access.

---

## 🛠️ Method 1: Discord Slash Command Configuration (Recommended)

You can assign fixed roles directly inside your Discord server using the built-in `/config role` command.

### 1. Bind the Fixed Security Staff Role
To lock all security and moderation commands (`/panic`, `/lock`, `/quarantine`, `/shield`, `/antiraid`, `/mod`, etc.) to your staff team:
```
/config role type:Security Staff Role role:@Staff
```
- **Result**: Any member with the `@Staff` role is immediately authorized by SPOOFY's `commandGuard` engine. Standard members without this role or administrator privileges will be rejected with an access-denied alert.

### 2. Bind the Fixed Music DJ Role
To ensure standard members can queue music with `/music play` but cannot disrupt playback (`/music stop`, `/music skip`, `/music pause`, `/music volume`):
```
/config role type:Music DJ Role role:@DJ
```
- **Result**: Only members with the `@DJ` role or `@Staff` role can modify playback or adjust master volume when multiple listeners are present.

### 3. Verify Your Active Role Bindings
To view which roles and channels are currently active:
```
/config view
```

---

## 📱 Method 2: Discord Native Integration Settings (Client-Level)

Discord allows server administrators to manage slash command permissions natively without changing bot code.

1. Open your Discord server and click on **Server Settings** (top-left dropdown).
2. Navigate to **Integrations** under the *Apps* section.
3. Select **SPOOFY** from the bot list.
4. Under **Command Permissions**, you can:
   - Restrict **All Commands** or individual commands (such as `/panic`, `/mod`, or `/shield`).
   - Click **Add Roles / Members** and select your fixed role (e.g. `@Moderator` or `@Security Team`).
   - Set `@everyone` to **Denied (❌)** and your fixed role to **Allowed (✅)**.

---

## 💻 Method 3: Codebase Enforcement (`commandGuard.js`)

In the backend codebase, role-based authorization is enforced on every command execution inside `src/bot/shield/commandGuard.js`:

```javascript
export function isServerStaff(guild, member) {
  if (!guild || !member) return false;

  // 1. Server Owner & Master Bot Owner always pass
  if (member.id === guild.ownerId || (config.botOwnerId && member.id === config.botOwnerId)) {
    return true;
  }

  // 2. Check fixed staff role assigned in database
  const cfg = getGuildConfig(guild.id);
  if (cfg?.staff_role_id && member.roles.cache.has(cfg.staff_role_id)) {
    return true;
  }

  // 3. Fallback to Discord administrative permissions
  const STAFF_PERMISSIONS = [
    PermissionFlagsBits.Administrator,
    PermissionFlagsBits.ManageGuild,
    PermissionFlagsBits.ManageRoles,
    PermissionFlagsBits.ManageChannels,
    PermissionFlagsBits.ModerateMembers,
    PermissionFlagsBits.BanMembers,
    PermissionFlagsBits.KickMembers
  ];
  return STAFF_PERMISSIONS.some(perm => member.permissions.has(perm));
}
```

### Enforcing on New Commands
To enforce fixed staff role authorization on any custom slash command:
```javascript
const passed = await guardCommand(interaction, {
  staffOnly: true, // Blocks standard members automatically
  requiredPermissions: [PermissionFlagsBits.ManageGuild],
  cooldownSeconds: 3
});
if (!passed) return;
```

---

## 🌐 Method 4: Web Dashboard Role Management

1. Log in to the SPOOFY Web Dashboard at `http://localhost:5173/dashboard`.
2. Select your Discord server from the server selector.
3. Click on the **Settings & Roles** tab.
4. Under **Designated Staff Role**, select your staff role from the dropdown menu and click **Save**.
5. Under **Designated DJ Role**, select your DJ role and click **Save**.
