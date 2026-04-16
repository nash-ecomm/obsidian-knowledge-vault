# Kinobody Daily Web Audit — local runner
# Invoked by Windows Task Scheduler. Pulls repo, runs Claude Code CLI with the audit prompt, logs output.

$ErrorActionPreference = "Continue"
$vaultRoot = "C:\Users\nashu\Claude Vault\Obsidian Knowledge Vault"
$auditDir  = Join-Path $vaultRoot "Kinobody Daily Web Audits"
$logDir    = Join-Path $auditDir "_logs"
$date      = Get-Date -Format "yyyy-MM-dd"
$logFile   = Join-Path $logDir "$date.log"

New-Item -ItemType Directory -Force -Path $logDir | Out-Null
"=== Run started $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz') ===" | Out-File -FilePath $logFile -Append

# Pull from the obsidian-knowledge-vault repo (audit files are tracked here now).
Set-Location $vaultRoot
git pull 2>&1 | Out-File -FilePath $logFile -Append

# Agent works from the audit subdirectory.
Set-Location $auditDir

# Load the prompt from the repo (version-controlled — edit .prompt.md to change behavior).
$prompt = Get-Content -Path (Join-Path $repo ".prompt.md") -Raw

# Run the Claude Code CLI in headless mode. Sonnet 4.6 matches the remote agent.
# --dangerously-skip-permissions: required for an unattended scheduled task (no human to approve tool calls).
$claude = "C:\Users\nashu\AppData\Roaming\npm\claude.cmd"
& $claude -p $prompt `
    --model "claude-sonnet-4-6" `
    --dangerously-skip-permissions `
    --max-turns 150 `
    --verbose `
    --output-format stream-json `
    --include-partial-messages `
    2>&1 | ForEach-Object { $_ | Out-File -FilePath $logFile -Append; $_ }

"=== Run finished $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz') with exit code $LASTEXITCODE ===" | Out-File -FilePath $logFile -Append
