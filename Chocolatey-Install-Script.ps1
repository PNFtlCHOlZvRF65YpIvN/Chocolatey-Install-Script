# Written by Daniel Kill
# Modified: 2019-03-11 by Daniel Kill
# Modified: 2019-03-14 by Daniel Kill
# Modified: 2019-04-07 by Daniel Kill
# Modified: 2020-01-26 by Daniel Kill

# Check if RunAsAdministrator, if not, then RunAsAdministrator
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process PowerShell -Verb runAs -ArgumentList $arguments
    Break
}

# [main code, using sub1 and sub2]
Clear-Host
$ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition # Captures the path of this script
Write-Output $ScriptPath

$dirToCreate = "$env:USERPROFILE\Documents\WindowsPowerShell"
if (!(Test-Path -Path $dirToCreate)) {
    New-Item -Path $dirToCreate -ItemType Directory -Force
}

$junctionToCreate = "$env:USERPROFILE\Documents\PowerShell"
if (!(Test-Path -Path $junctionToCreate)) {
    New-Item -ItemType Junction -Path $junctionToCreate -Target "$env:USERPROFILE\Documents\WindowsPowerShell" -Force
}

$outToFile = @"
# Chocolatey profile
`$ChocolateyProfile = "`$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path(`$ChocolateyProfile))
{
    Import-Module "`$ChocolateyProfile"
}
"@

$fileToWrite = "$env:USERPROFILE\Documents\WindowsPowerShell\profile.ps1"
if (!(Test-Path -Path $fileToWrite)) {
    New-Item -Path $fileToWrite
    $outToFile | Out-File $fileToWrite
}

& $profile

Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#choco.exe install 7zip.install --yes --limitoutput --no-progress
#choco.exe install adobereader --yes --limitoutput --no-progress
#choco.exe install firefox --yes --limitoutput --no-progress
#choco.exe install googlechrome --yes --limitoutput --no-progress
#choco.exe install notepadplusplus.install --yes --limitoutput --no-progress
#choco.exe install python --yes --limitoutput --no-progress
#choco.exe install vlc --yes --limitoutput --no-progress

$fileToWrite = "$env:USERPROFILE\Documents\WindowsPowerShell\profile.ps1"
if (!((Get-Content -Path $fileToWrite) -match "choco upgrade")) {
    Add-Content -Path $fileToWrite "Write-Output `"    *** Optional Installs:`""
    Add-Content -Path $fileToWrite "Write-Output `"choco install draftsight --yes --limitoutput --no-progress`""
    Add-Content -Path $fileToWrite "Write-Output `"choco install dropbox --yes --limitoutput --no-progress`""
    Add-Content -Path $fileToWrite "Write-Output `"choco install gimp --yes --limitoutput --no-progress`""
    Add-Content -Path $fileToWrite "Write-Output `"choco.exe install google-backup-and-sync --yes --limitoutput --no-progress`""
    Add-Content -Path $fileToWrite "Write-Output `"choco.exe install keepass.install --yes --limitoutput --no-progress`""
    Add-Content -Path $fileToWrite "Write-Output `"choco.exe install vscode --yes --limitoutput --no-progress`""
    Add-Content -Path $fileToWrite "Write-Output `"``n``n    *** Chocolatey - To upgrade all Chocolatey packages, run:`""
    Add-Content -Path $fileToWrite "Write-Output `"choco upgrade all --yes --limitoutput --no-progress``n`""
}
