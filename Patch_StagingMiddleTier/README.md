# Pulse

Pulse is a patching automation app that uses YAML templates to provide structured patch information and drive sequential patching tasks.

Pulse is designed to carry more detail and sequencing logic than a basic patching runbook, giving operators a clear, repeatable process for each environment.

---

## Project: patcharooo

This repo contains YAML patch templates and supporting PowerShell scripts for each environment being patched.

---

## Environments

| Environment | Folder |
|---|---|
| Staging Middle Tier | `Patch_StagingMiddleTier/` |

---

## YAML Template Structure

Each environment has a YAML file that describes all servers and endpoints involved in the patch window.

### Role Definitions

| Role Key | Description |
|---|---|
| `ServerSimSda` | Simple Server - Side A. No special services to stop before reboot. Default active side. |
| `ServerSimSdb` | Simple Server - Side B. No special services to stop before reboot. |
| `ServerSimRes` | Reserved Server. Not in active use but still requires patching. |
| `ServerDbsLow` | Database Server - Lower numbered SQL HA cluster member. |
| `ServerDbsHig` | Database Server - Higher numbered SQL HA cluster member. |
| `F5Sda` | F5 Load Balancer - Side A. Default active side. |
| `F5Sdb` | F5 Load Balancer - Side B. |
| `TimestampStart` | Scheduled start time for the patch window. |

### Example: StagingMiddleTier.yml

```yaml
StagingMiddleTier:
  TimestampStart: "DYNAMIC"  # Patch Tuesday of current month + 7 days, time set at runtime

  ServerSimSda:
    - s0vapp001
    - s0vapp002

  ServerSimSdb:
    - s0vapp003
    - s0vapp004

  ServerSimRes:
    - s0vapp005

  ServerDbsLow:
    - S1VRDBS001

  ServerDbsHig:
    - S1VRDBS002

  F5Sda:
    - "https://8.8.8.8/tmui/login.jsp"

  F5Sdb:
    - "https://4.4.4.4/xui/"
```

---

## PowerShell Scripts

### Get-PatchTimestamp.ps1

Calculates the `TimestampStart` dynamically at runtime.

**Logic:**
- Finds the next Patch Tuesday (2nd Tuesday of the month) that has not yet occurred
- If this month's Patch Tuesday has already passed, it automatically rolls to next month
- Adds 7 days to Patch Tuesday to get the patch window start date
- Time of day is set manually at the top of the script

**Usage:**

```powershell
.\Get-PatchTimestamp.ps1
```

**Example Output:**

```
Today              : 2025-09-28
Next Patch Tuesday : 2025-10-14
TimestampStart     : 2025-10-21T14:00:00
```

**To change the patch time**, edit these variables at the top of the script:

```powershell
$PatchHour   = 14
$PatchMinute = 0
$PatchSecond = 0
```

---

## Getting Started

1. Clone the repo
2. Navigate to the environment folder (e.g. `Patch_StagingMiddleTier`)
3. Review the YAML file for the target environment
4. Run `Get-PatchTimestamp.ps1` to confirm the upcoming patch window date
5. Use the YAML roles to drive your sequential patching tasks

---

## Notes

- Staging Middle Tier mirrors the Prod Middle Tier environment and is used to validate patching steps without touching production servers
- Prod Middle Tier includes spare servers, F5 load balancers, and full A/B side configuration
