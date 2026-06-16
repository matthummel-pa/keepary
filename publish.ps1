# Keepary -> GitHub one-step publisher
# Run this from the keepary folder:  Right-click > "Run with PowerShell"
# ...or in a terminal:  cd C:\ClaudeCowork\Projects\DevProjects\keepary ; .\publish.ps1

Set-Location $PSScriptRoot
Write-Host ""
Write-Host "==  Keepary GitHub publisher  ==" -ForegroundColor Magenta
Write-Host ""

# 1) Is Git installed?
try { git --version | Out-Null }
catch {
  Write-Host "Git is not installed. Download it from https://git-scm.com/download/win, reboot, then rerun this." -ForegroundColor Red
  Read-Host "Press Enter to exit"; exit 1
}

# 2) Make sure Git knows who you are
if (-not (git config user.name))  { git config user.name  (Read-Host "Your name (for commits)") }
if (-not (git config user.email)) { git config user.email (Read-Host "Your email (for commits)") }

# 3) Initialize the repo if needed
if (-not (Test-Path ".git")) {
  git init | Out-Null
  git branch -M main
  Write-Host "Initialized a new Git repository." -ForegroundColor Green
}

# 4) Stage and commit everything (.gitignore already excludes secrets/build files)
git add .
$hasHead = $true; try { git rev-parse HEAD 2>$null | Out-Null } catch { $hasHead = $false }
if ((git status --porcelain) -or -not $hasHead) {
  git commit -m "Initial commit: Keepary" | Out-Null
  Write-Host "Committed all project files." -ForegroundColor Green
} else {
  Write-Host "Nothing new to commit." -ForegroundColor DarkGray
}

# 5) Your GitHub username + create the empty repo on github.com
$user = Read-Host "Your GitHub username"
Write-Host ""
Write-Host "Opening GitHub so you can create the empty 'keepary' repo..." -ForegroundColor Cyan
Start-Process "https://github.com/new?name=keepary"
Write-Host "In the browser:  name = keepary,  Public,  and DO NOT add a README / .gitignore / license." -ForegroundColor Yellow
Write-Host "Then click 'Create repository'." -ForegroundColor Yellow
Read-Host "When the repo has been created, come back here and press Enter"

# 6) Wire up the remote and push
$url = "https://github.com/$user/keepary.git"
if (git remote | Select-String -Quiet "^origin$") { git remote set-url origin $url } else { git remote add origin $url }
git branch -M main

Write-Host ""
Write-Host "Pushing to GitHub... a sign-in window may pop up - approve it." -ForegroundColor Cyan
git push -u origin main

if ($LASTEXITCODE -eq 0) {
  Write-Host ""
  Write-Host "Success!  Your repository is live at:" -ForegroundColor Green
  Write-Host "   https://github.com/$user/keepary" -ForegroundColor Green
} else {
  Write-Host ""
  Write-Host "The push didn't complete. Common fixes:" -ForegroundColor Red
  Write-Host "  - Make sure you created the empty repo named 'keepary' (no README/license)." -ForegroundColor Red
  Write-Host "  - Make sure the username you entered ($user) is correct." -ForegroundColor Red
  Write-Host "  - If asked to sign in, complete the browser approval, then rerun this script." -ForegroundColor Red
}
Read-Host "Press Enter to close"
