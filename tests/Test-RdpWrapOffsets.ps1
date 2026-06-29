# tests/Test-RdpWrapOffsets.ps1
# Run: .\tests\Test-RdpWrapOffsets.ps1
# Or in CI: pwsh -File tests/Test-RdpWrapOffsets.ps1

param(
    [string]$OurIni    = "$PSScriptRoot\..\rdpwrap.ini",
    [string]$ReportOut = "$PSScriptRoot\..\tests\last-report.txt"
)

$COMPARE_SOURCES = @(
    @{ Name = "sebaxakerhtc"; Url = "https://raw.githubusercontent.com/sebaxakerhtc/rdpwrap.ini/master/rdpwrap.ini" }
    @{ Name = "asmtron";      Url = "https://raw.githubusercontent.com/asmtron/rdpwrap/master/res/rdpwrap.ini" }
)

$REQUIRED_KEYS = @(
    "SingleUserOffset.x64"
    "DefPolicyOffset.x64"
    "LocalOnlyOffset.x64"
)

$VALID_HEX = '^[0-9A-Fa-f]+$'

# ── helpers ──────────────────────────────────────────────────────────────────

function Parse-Ini([string]$path) {
    $sections = @{}
    $cur = $null
    foreach ($line in (Get-Content $path)) {
        $line = $line.Trim()
        if ($line -match '^\[(.+)\]$') {
            $cur = $Matches[1]
            $sections[$cur] = @{}
        } elseif ($cur -and $line -match '^([^=]+)=(.*)$') {
            $sections[$cur][$Matches[1].Trim()] = $Matches[2].Trim()
        }
    }
    return $sections
}

function Fetch-Ini([string]$url) {
    $tmp = "$env:TEMP\rdpwrap_compare_$([System.IO.Path]::GetRandomFileName()).ini"
    curl.exe -L $url -o $tmp --silent --show-error --fail 2>$null
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $tmp)) { return $null }
    return Parse-Ini $tmp
}

# ── test runner ───────────────────────────────────────────────────────────────

$pass = 0; $fail = 0; $warn = 0
$report = [System.Text.StringBuilder]::new()

function Log([string]$msg) { $report.AppendLine($msg) | Out-Null; Write-Host $msg }

function Test-Pass([string]$name) {
    $script:pass++
    Log "  [PASS] $name"
}
function Test-Fail([string]$name, [string]$detail = "") {
    $script:fail++
    Log "  [FAIL] $name$(if($detail){": $detail"})"
}
function Test-Warn([string]$name, [string]$detail = "") {
    $script:warn++
    Log "  [WARN] $name$(if($detail){": $detail"})"
}

# ─────────────────────────────────────────────────────────────────────────────
Log "═══════════════════════════════════════════════════════"
Log "  RDP Wrap Offset Test Suite"
Log "  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Log "═══════════════════════════════════════════════════════"

# ── Suite 1: File integrity ───────────────────────────────────────────────────
Log ""
Log "── Suite 1: File Integrity ──"

if (Test-Path $OurIni) {
    Test-Pass "rdpwrap.ini exists"
} else {
    Test-Fail "rdpwrap.ini exists" "not found at $OurIni"
    exit 1
}

$ourSections = Parse-Ini $OurIni
$sectionCount = $ourSections.Count
if ($sectionCount -gt 0) {
    Test-Pass "rdpwrap.ini is parseable ($sectionCount sections)"
} else {
    Test-Fail "rdpwrap.ini is parseable" "0 sections found"
}

# ── Suite 2: Section structure ────────────────────────────────────────────────
Log ""
Log "── Suite 2: Section Structure ──"

$malformed = @()
$missingKeys = @()
$badHex = @()

foreach ($sec in $ourSections.Keys) {
    $kv = $ourSections[$sec]
    if ($kv.Count -eq 0) { $malformed += $sec; continue }

    # Required keys check: only CI-generated sections (those with a history/ snapshot)
    # Inherited sections from sebaxakerhtc may legitimately lack some keys for old builds
    $isOurSection = Test-Path "$PSScriptRoot\..\history\$sec.ini"
    if ($isOurSection -and $sec -notmatch '-SLInit$') {
        foreach ($req in $REQUIRED_KEYS) {
            if (-not $kv.ContainsKey($req)) { $missingKeys += "$sec/$req" }
        }
        foreach ($key in $kv.Keys) {
            if ($key -match 'Offset') {
                $val = $kv[$key]
                if ($val -notmatch $VALID_HEX) { $badHex += "$sec/$key=$val" }
            }
        }
    }
}

if ($malformed.Count -eq 0) { Test-Pass "No empty sections" }
else { Test-Fail "No empty sections" "$($malformed.Count) empty: $($malformed -join ', ')" }

if ($missingKeys.Count -eq 0) { Test-Pass "All sections have required offset keys" }
else { Test-Fail "All sections have required offset keys" "$($missingKeys.Count) missing: $($missingKeys[0..4] -join ', ')" }

if ($badHex.Count -eq 0) { Test-Pass "All offset values are valid hex" }
else { Test-Fail "All offset values are valid hex" "$($badHex -join ', ')" }

# ── Suite 3: Local machine coverage ──────────────────────────────────────────
Log ""
Log "── Suite 3: Local Machine Coverage ──"

$localVer = (Get-Item "$env:SystemRoot\System32\termsrv.dll").VersionInfo.FileVersion.Split(' ')[0].Trim()
Log "  termsrv.dll version: $localVer"

if ($ourSections.ContainsKey($localVer)) {
    Test-Pass "Current build [$localVer] has offsets"
} else {
    Test-Fail "Current build [$localVer] has offsets" "missing — RDP Wrapper will not work on this machine"
}

$histFile = "$PSScriptRoot\..\history\$localVer.ini"
if (Test-Path $histFile) {
    Test-Pass "history/$localVer.ini snapshot exists"
} else {
    Test-Warn "history/$localVer.ini snapshot exists" "ini has the offsets but history snapshot missing"
}

# ── Suite 4: History ↔ ini consistency ───────────────────────────────────────
Log ""
Log "── Suite 4: History ↔ INI Consistency ──"

$histDir = "$PSScriptRoot\..\history"
$histFiles = Get-ChildItem $histDir -Filter "*.ini" -ErrorAction SilentlyContinue
$orphaned = @(); $mismatch = @()

foreach ($hf in $histFiles) {
    $hSec = [System.IO.Path]::GetFileNameWithoutExtension($hf.Name)
    if (-not $ourSections.ContainsKey($hSec)) {
        $orphaned += $hSec
        continue
    }
    # Compare key count
    $hParsed = Parse-Ini $hf.FullName
    if ($hParsed.ContainsKey($hSec)) {
        $hKeys = $hParsed[$hSec]
        $mKeys = $ourSections[$hSec]
        foreach ($k in $hKeys.Keys) {
            if ($mKeys[$k] -ne $hKeys[$k]) {
                $mismatch += "${hSec}/${k}: history=$($hKeys[$k]) ini=$($mKeys[$k])"
            }
        }
    }
}

$histCount = $histFiles.Count
if ($histCount -gt 0) { Test-Pass "$histCount history snapshot(s) found" }
else { Test-Warn "history snapshots" "0 files in history/ — expected at least 1" }

if ($orphaned.Count -eq 0) { Test-Pass "All history files have matching ini sections" }
else { Test-Warn "Orphaned history files" "$($orphaned -join ', ') in history/ but not in rdpwrap.ini" }

if ($mismatch.Count -eq 0) { Test-Pass "History snapshots match rdpwrap.ini values" }
else { Test-Fail "History ↔ ini value match" "$($mismatch.Count) mismatches: $($mismatch[0..2] -join ' | ')" }

# ── Suite 5: Cross-repo comparison ───────────────────────────────────────────
Log ""
Log "── Suite 5: Cross-Repo Comparison ──"

foreach ($src in $COMPARE_SOURCES) {
    Log "  Fetching $($src.Name)..."
    $ext = Fetch-Ini $src.Url

    if ($null -eq $ext) {
        Test-Warn "Fetch $($src.Name)" "unreachable or empty"
        continue
    }

    $extCount  = $ext.Count
    $ourCount  = $ourSections.Count
    $common    = ($ourSections.Keys | Where-Object { $ext.ContainsKey($_) })
    $onlyUs    = ($ourSections.Keys | Where-Object { -not $ext.ContainsKey($_) })
    $onlyThem  = ($ext.Keys          | Where-Object { -not $ourSections.ContainsKey($_) })

    Log "    $($src.Name): $extCount sections | ours: $ourCount | common: $($common.Count) | only-ours: $($onlyUs.Count) | only-theirs: $($onlyThem.Count)"

    # Value-level diff on common sections — skip metadata sections like [Main]
    $diffs = @()
    foreach ($sec in $common) {
        if ($sec -notmatch '^\d+\.\d+') { continue }   # skip non-version sections
        $ourKV = $ourSections[$sec]
        $extKV = $ext[$sec]
        foreach ($k in $ourKV.Keys) {
            if ($extKV.ContainsKey($k) -and $ourKV[$k] -ne $extKV[$k]) {
                $diffs += "$sec/$k our=$($ourKV[$k]) $($src.Name)=$($extKV[$k])"
            }
        }
    }

    if ($diffs.Count -eq 0) {
        Test-Pass "[$($src.Name)] All common sections have identical offset values"
    } else {
        Test-Fail "[$($src.Name)] Value-level diff on common sections" "$($diffs.Count) discrepancies:"
        $diffs | Select-Object -First 10 | ForEach-Object { Log "      $_" }
    }

    # Sections we have that they don't = we're ahead
    if ($onlyUs.Count -gt 0) {
        Test-Pass "[$($src.Name)] We have $($onlyUs.Count) newer section(s) not yet in $($src.Name)"
        $onlyUs | Select-Object -First 5 | ForEach-Object { Log "      + $_" }
    }

    # Sections they have that we don't = we're behind
    if ($onlyThem.Count -gt 0) {
        Test-Warn "[$($src.Name)] $($onlyThem.Count) section(s) in $($src.Name) not in ours (older builds we haven't seen)"
    }
}

# ── Summary ───────────────────────────────────────────────────────────────────
Log ""
Log "═══════════════════════════════════════════════════════"
Log "  PASS: $pass   FAIL: $fail   WARN: $warn"
Log "═══════════════════════════════════════════════════════"

$report.ToString() | Out-File $ReportOut -Encoding utf8NoBOM
Write-Host ""
Write-Host "Report saved: $ReportOut"

if ($fail -gt 0) { exit 1 } else { exit 0 }
