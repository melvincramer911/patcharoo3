# Create_PatchLog.ps1
# Calculates the next future Patch Tuesday + 7 days
# Creates a patchlog-YYMMDD.yml file for that date
# If the file already exists, the script will complain loudly and stop

# --- User sets the patch time here ---
$PatchHour   = 14
$PatchMinute = 0
$PatchSecond = 0

# --- Function: Get Patch Tuesday for a given Year and Month ---
function Get-PatchTuesday {
    param (
        [int]$Year,
        [int]$Month
    )
    $FirstOfMonth     = Get-Date -Year $Year -Month $Month -Day 1 -Hour 0 -Minute 0 -Second 0
    $DaysUntilTuesday = (2 - [int]$FirstOfMonth.DayOfWeek + 7) % 7
    $FirstTuesday     = $FirstOfMonth.AddDays($DaysUntilTuesday)
    $PatchTuesday     = $FirstTuesday.AddDays(7)
    return $PatchTuesday
}

# --- Find the next future Patch Tuesday ---
$Today        = Get-Date
$PatchTuesday = Get-PatchTuesday -Year $Today.Year -Month $Today.Month

# If today is on or after this month's Patch Tuesday, move to next month
if ($Today.Date -ge $PatchTuesday.Date) {
    $NextMonth    = $Today.AddMonths(1)
    $PatchTuesday = Get-PatchTuesday -Year $NextMonth.Year -Month $NextMonth.Month
}

# --- Calculate TimestampStart: Patch Tuesday + 7 days ---
$RawDate        = $PatchTuesday.AddDays(7)
$TimestampStart = Get-Date -Year $RawDate.Year -Month $RawDate.Month -Day $RawDate.Day `
                           -Hour $PatchHour -Minute $PatchMinute -Second $PatchSecond

# --- Build the filename: patchlog-YYMMDD.yml ---
$DateStamp     = $TimestampStart.ToString("yyMMdd")
$FileName      = "patchlog-$DateStamp.yml"
$FilePath      = Join-Path -Path $PSScriptRoot -ChildPath $FileName

# --- Build the single schedule line ---
$PatchScheduled = $TimestampStart.ToString("yyyy-MM-dd") + "_" + $TimestampStart.ToString("HHmm")

# --- Check if file already exists --- COMPLAIN LOUDLY IF SO ---
if (Test-Path $FilePath) {
    Write-Host ""
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" -ForegroundColor Red
    Write-Host "  ERROR: $FileName ALREADY EXISTS!" -ForegroundColor Red
    Write-Host "  Patch log for this date has already been created." -ForegroundColor Red
    Write-Host "  Delete the existing file if you want to recreate it." -ForegroundColor Red
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" -ForegroundColor Red
    Write-Host ""
    exit 1
}

# --- Create the patchlog YAML file ---
$YmlContent = @"
PatchLog:
  PatchScheduled: "$PatchScheduled"
  PatchTuesday:   "$($PatchTuesday.ToString('yyyy-MM-dd'))"
  CreatedOn:      "$($Today.ToString('yyyy-MM-ddTHH:mm:ss'))"
  Environment:    "StagingMiddleTier"

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
"@

$YmlContent | Out-File -FilePath $FilePath -Encoding utf8

# --- Confirm success ---
Write-Host ""
Write-Host "  Patch log created successfully!" -ForegroundColor Green
Write-Host "  File : $FileName"               -ForegroundColor Green
Write-Host "  Scheduled : $PatchScheduled"    -ForegroundColor Green
Write-Host ""
