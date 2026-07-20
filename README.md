# DoomWizard
Simplifying Doom mod setup, one launcher at a time. Currently featuring PortMaster Edition for Doom Engines handhelds.

## What is DoomWizard?

DoomWizard is a utility that automates the creation of Doom Engines launcher profiles for PortMaster.

Instead of manually creating .doom launcher files, creating save folders, copying gzdoom.ini, configuring save paths, and selecting IWADs, DoomWizard handles everything through a simple guided wizard.

The goal is simple:

Download mods → Run DoomWizard → Play

## Features
Automatic .doom launcher creation
Automatic save folder creation
Dedicated gzdoom.ini for every launcher
Automatic save directory configuration
Multiple PK3 and WAD mod support
IWAD selection
IWAD validation
Duplicate launcher protection
Save folder name sanitization
Create multiple launchers in a single session
One-click BAT launcher

## Requirements
Windows PC

PortMaster Doom Engines

PowerShell (included with Windows)

No administrator rights required.

## Installation
Download the latest release.
Extract the files into your doomengines folder.
Double-click Doom Wizard.bat.
Follow the prompts.
Expected Folder Structure
doomengines/
│
├── Doom Wizard.bat
├── DoomWizard-Core.ps1
├── Mods/
├── doomfiles/
├── iwads/
└── configs/

# Usage
## Step 1

Copy your Doom mods into the Mods folder.

Supported formats:

.wad
.pk3

## Step 2

Launch:

Doom Wizard.bat

## Step 3

Follow the prompts:

Enter launcher name
Choose save folder name
Select an IWAD
Select mods to load

## Step 4

DoomWizard automatically:

Creates a save folder
Creates a dedicated gzdoom.ini
Configures the save directory
Generates a PortMaster-compatible .doom launcher

Done.

Current Release
PortMaster Edition v0.1.2

Features included:

Launcher generation
Save folder generation
Per-launcher configuration files
IWAD detection
Duplicate launcher prevention
One-click launcher
Why DoomWizard?

Creating PortMaster launchers manually can become repetitive and error-prone when managing multiple mods.

DoomWizard removes the tedious setup process so you can spend less time editing configuration files and more time playing Doom.

## License

Free to use, modify, and share.

If you improve DoomWizard, consider contributing your changes back to the community.

Happy Dooming!
