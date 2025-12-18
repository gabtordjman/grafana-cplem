<#
NXLog Installation Script for Windows
-------------------------------------
This script installs NXLog Community Edition on Windows systems.
Steps:
  1. Ensures admin privileges
  2. Downloads and extracts the Grafana CPL&EM repository ZIP
  3. Uses the NXLog MSI package stored in packages\
  4. Installs NXLog with msiexec (interactive mode)
  5. Copies the configuration file (windows-nxlog.conf) to C:\Program Files\nxlog\conf\nxlog.conf
  6. Enables and starts the NXLog service, then verifies its status
#>

function Confirm-Step($message) {
    Write-Host ""
    Write-Host ">>> $message"
    $resp = Read-Host "Continue? (y/n)"
    if ($resp -notin @('y','Y')) { Write-Host "Script aborted."; exit 1 }
    Write-Host "Proceeding..."
    Write-Host ""
}

# --- Admin check ---
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Host "Error: Please run this script as Administrator."
    exit 1
}

Write-Host "=== NXLog Installation Script for Windows ==="

# Step 1: Download repository ZIP
Confirm-Step "Step 1: Download Grafana CPL&EM repository ZIP"
$RepoUrl = "https://github.com/gabtordjman/grafana-cplem/archive/refs/heads/main.zip"
$ZipFile = "$env:TEMP\grafana-cplem.zip"
$RepoDir = "$env:TEMP\grafana-cplem-main"

Invoke-WebRequest -Uri $RepoUrl -OutFile $ZipFile
Expand-Archive -Path $ZipFile -DestinationPath $env:TEMP -Force
Set-Location $RepoDir

# Step 2: Locate NXLog MSI package
Confirm-Step "Step 2: Locate NXLog MSI package in packages\"
$NxlogMsi = Join-Path $RepoDir "packages\nxlog-ce-3.2.2329.msi"

if (-not (Test-Path $NxlogMsi)) {
    Write-Host "Error: NXLog MSI package not found at $NxlogMsi"
    exit 1
}

# Unblock file if Windows marked it as downloaded from Internet
Unblock-File $NxlogMsi

# Step 3: Install NXLog interactively
Confirm-Step "Step 3: Install NXLog using msiexec (interactive)"
Start-Process msiexec.exe -ArgumentList "/i `"$NxlogMsi`"" -Wait

# Step 4: Copy configuration
Confirm-Step "Step 4: Copy NXLog configuration file"
$ConfigSrc  = Join-Path $RepoDir "configs\windows-nxlog.conf"
$ConfigDest = "C:\Program Files\nxlog\conf\nxlog.conf"

if (Test-Path $ConfigSrc) {
    Copy-Item -Path $ConfigSrc -Destination $ConfigDest -Force
    Write-Host "###############################################"
    Write-Host "# WARNING: Please check the IP and PORT in    #"
    Write-Host "# $ConfigDest                                  #"
    Write-Host "# Make sure they match your environment.      #"
    Write-Host "###############################################"
} else {
    Write-Host "Config file not found at $ConfigSrc"
    exit 1
}

# Step 5: Enable and start NXLog service
Write-Host ""
Write-Host ">>> Step 5: Enable and start NXLog service"
try {
    Set-Service -Name nxlog -StartupType Automatic
    Start-Service -Name nxlog
} catch {
    Write-Host "Error starting NXLog service: $($_.Exception.Message)"
}

# Step 6: Verify service status
Write-Host ""
Write-Host ">>> Step 6: Verify NXLog service status"
try {
    Get-Service -Name nxlog | Format-Table Status, Name, DisplayName -AutoSize
} catch {
    Write-Host "Unable to retrieve NXLog service status."
}

Write-Host ""
Write-Host "=== Installation completed successfully ==="
