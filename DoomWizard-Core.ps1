Clear-Host
do {

Clear-Host
# ==========================================
# PortMaster DoomWizard v0.1.2 by Nerd Triffic
# ==========================================

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

$ModsFolder = Join-Path $Root "Mods"
$ConfigFolder = Join-Path $Root "configs/gzdoom"
$SaveRoot = Join-Path $Root "saves"
$DoomFilesFolder = Join-Path $Root "doomfiles"
$IWADFolder = Join-Path $Root "iwads"

Write-Host "=========================================="
Write-Host "         DOOMWIZARD PORTMASTER"
Write-Host "             Version 0.1.2"
Write-Host "=========================================="
Write-Host ""

# Check folders

foreach($Folder in @($ModsFolder,$SaveRoot,$DoomFilesFolder))
{
    if(!(Test-Path $Folder))
    {
        New-Item -ItemType Directory -Path $Folder | Out-Null
    }
}

$MasterIni = Join-Path $ConfigFolder "gzdoom.ini"

if(!(Test-Path $MasterIni))
{
    Write-Host ""
    Write-Host "[ERROR] Could not find:"
    Write-Host $MasterIni
    Pause
    exit
}

# ------------------------------------------
# Mod Name
# ------------------------------------------

$ModName = Read-Host "Mod Name"

$SaveFolder = Read-Host "Save Folder (Press ENTER to use '$ModName')"

if([string]::IsNullOrWhiteSpace($SaveFolder))
{
    $SaveFolder = $ModName
}

#-------------------------------------------
# Replace spaces with underscores for save folder compatibility
#-------------------------------------------

$SaveFolder = $SaveFolder.Trim() -replace '\s+', '_'

# ------------------------------------------
# IWAD Selection
# ------------------------------------------

Write-Host ""
Write-Host "Select IWAD"
Write-Host "-----------"
Write-Host "1. Doom"
Write-Host "2. Doom II"
Write-Host "3. TNT Evilution"
Write-Host "4. Plutonia"
Write-Host "5. Heretic"
Write-Host "6. Hexen"
Write-Host "7. Strife"
Write-Host ""

do
{
    $Choice = Read-Host "Choice"

    switch($Choice)
    {
        "1" {$IWAD="doom.wad"}
        "2" {$IWAD="doom2.wad"}
        "3" {$IWAD="tnt.wad"}
        "4" {$IWAD="plutonia.wad"}
        "5" {$IWAD="heretic.wad"}
        "6" {$IWAD="hexen.wad"}
        "7" {$IWAD="strife1.wad"}
        default
        {
            Write-Host "Invalid selection."
            $IWAD=$null
        }
    }

} until ($IWAD)
# ------------------------------------------
# Verify IWAD Exists
# ------------------------------------------

$IWADPath = Join-Path $IWADFolder $IWAD

if (!(Test-Path $IWADPath))
{
    Clear-Host

    Write-Host "=========================================="
    Write-Host "ERROR"
    Write-Host "=========================================="
    Write-Host ""
    Write-Host "The selected IWAD could not be found."
    Write-Host ""
    Write-Host "Selected IWAD:"
    Write-Host "  $IWAD"
    Write-Host ""
    Write-Host "Expected location:"
    Write-Host "  $IWADPath"
    Write-Host ""
    Write-Host "Copy the required IWAD into the 'iwads' folder"
    Write-Host "and run Doom Wizard again."
    Write-Host ""
    Pause
    exit
}

Write-Host ""
Write-Host "[OK] IWAD found: $IWAD"
Write-Host ""

# ------------------------------------------
# Scan Mods
# ------------------------------------------

$Files = Get-ChildItem $ModsFolder -File | Where-Object {
    $_.Extension -match '\.(pk3|wad)$'
}

if($Files.Count -eq 0)
{
    Write-Host ""
    Write-Host "[ERROR] No PK3 or WAD files found."
    Pause
    exit
}

Write-Host ""
Write-Host "Detected Files"
Write-Host "--------------"

for($i=0;$i -lt $Files.Count;$i++)
{
    Write-Host "$($i+1). $($Files[$i].Name)"
}

Write-Host ""

$Selection = Read-Host "Select Mods (Example: 1,2,3)"

$Selected=@()

foreach($Item in $Selection.Split(","))
{
    $Item=$Item.Trim()

    if($Item -match '^\d+$')
    {
        $Index=[int]$Item

        if($Index -ge 1 -and $Index -le $Files.Count)
        {
            $Selected+=$Files[$Index-1]
        }
    }
}

if($Selected.Count -eq 0)
{
    Write-Host ""
    Write-Host "[ERROR] No valid mods selected."
    Pause
    exit
}

Write-Host ""
Write-Host "Selected Mods"
Write-Host "-------------"

foreach($Mod in $Selected)
{
    Write-Host " - $($Mod.Name)"
}

Write-Host ""
$Go=Read-Host "Continue? (Y/N)"

if($Go.ToUpper() -ne "Y")
{
    exit
}

# ------------------------------------------
# Create Save Folder
# ------------------------------------------

$SavePath=Join-Path $SaveRoot $SaveFolder

New-Item -ItemType Directory -Force -Path $SavePath | Out-Null

# ------------------------------------------
# Copy gzdoom.ini
# ------------------------------------------

$NewIni=Join-Path $SavePath "gzdoom.ini"

Copy-Item $MasterIni $NewIni -Force

(Get-Content $NewIni) |

ForEach-Object {

    if($_ -match "^save_dir=")
    {
        "save_dir=saves/$SaveFolder"
    }
    else
    {
        $_
    }

} |

Set-Content $NewIni

# ------------------------------------------
# Build MOD lines
# ------------------------------------------

$ModLines=""

foreach($Mod in $Selected)
{
    $ModLines+="MOD=mods/$($Mod.Name)`r`n"
}

# ------------------------------------------
# Create Launcher
# ------------------------------------------

$Launcher=@"
ENGINE=gzdoom
IWAD=iwads/$IWAD
INI=saves/$SaveFolder/gzdoom.ini

$ModLines
"@

$LauncherFile=Join-Path $DoomFilesFolder "$ModName.doom"

if(Test-Path $LauncherFile)
{
    Write-Host ""
    Write-Host "[ERROR] A launcher with this name already exists."
    Write-Host ""
    Write-Host $LauncherFile
    Write-Host ""
    Write-Host "Please choose a different Mod Name."
    Pause
    continue
}
Set-Content $LauncherFile $Launcher

# ------------------------------------------
# Finished
# ------------------------------------------

Clear-Host

Write-Host "=========================================="
Write-Host "SUCCESS!"
Write-Host "=========================================="
Write-Host ""

Write-Host "Launcher:"
Write-Host "  $LauncherFile"
Write-Host ""

Write-Host "IWAD:"
Write-Host "  $IWAD"
Write-Host ""

Write-Host "Config:"
Write-Host "  $NewIni"
Write-Host ""

Write-Host "Selected Mods:"
foreach($Mod in $Selected)
{
    Write-Host "  - $($Mod.Name)"
}

Write-Host ""
Write-Host ""
$Again = Read-Host "Would you like to create another mod launcher? (Y/N)"

} while ($Again.ToUpper() -eq "Y")
Write-Host ""
Write-Host "=========================================="
Write-Host "Thank you for using"
Write-Host "PortMaster Doom Wizard v0.1.2"
Write-Host ""
Write-Host "Happy Dooming!"
Write-Host "=========================================="
Pause