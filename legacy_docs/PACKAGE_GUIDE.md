# PlepperVR - Distribution Package Guide

## ⚠️ IMPORTANT: How to Create a Clean Modpack Package

Your friend's crash is caused by corrupted mod files and missing Forge libraries. Here's how to create a proper distribution package:

## 📦 Method 1: Prism Launcher Export (Recommended)

1. **Open Prism Launcher**
2. **Right-click on PlepperVR instance**
3. **Select "Export Instance"**
4. **Choose Export Format:**
   - ✅ "CurseForge" format (most compatible)
   - ✅ "Zip" format (alternative)
5. **Export Settings:**
   - ✅ Include mods
   - ✅ Include configs
   - ✅ Include resource packs
   - ❌ Exclude libraries (Prism Launcher will handle this)
6. **Send the exported file to your friend**

## 📦 Method 2: Manual Clean Package

If Prism Launcher export doesn't work, create a manual package:

### Step 1: Clean Your Instance First
```bash
# In your Prism Launcher instance folder, remove corrupted files:
rm -f mods/*IPADDRESS*.jar
rm -f .old/*.jar
```

### Step 2: Create the Package Structure
Create a zip file containing ONLY these folders:

```
PlepperVR-Modpack/
├── mods/                    # ALL your 70 JAR files
├── config/                 # All config files
├── resourcepacks/          # If you have any
├── OPTIONAL: options.txt   # If you want to share settings
└── README_INSTALL.txt      # Installation instructions
```

### Step 3: Create Installation Instructions
Create a `README_INSTALL.txt` file with:
```
=== PlepperVR Modpack Installation ===

REQUIREMENTS:
- Minecraft 1.20.1
- Forge 47.4.0
- Prism Launcher

INSTALLATION:
1. Create new instance: "PlepperVR"
2. Minecraft version: 1.20.1
3. Modloader: Forge 47.4.0
4. Copy ALL files from zip to instance folder
5. Launch game

VR SUPPORT:
- Vivecraft is included for VR
- Requires VR headset and Oculus software
```

## ⚠️ FILES TO NEVER INCLUDE:
- ❌ `libraries/` folder (causes crashes)
- ❌ `logs/` folder
- ❌ `crash-reports/` folder
- ❌ `.old/` folder
- ❌ Any ATLauncher specific files (should not exist)
- ❌ Any Prism Launcher specific files
- ❌ Any corrupted files with "IPADDRESS" in name

## 🔧 Friend's Installation Steps:

1. **Delete their current corrupted instance**
2. **Create fresh instance:**
   - Name: "PlepperVR"
   - Minecraft: 1.20.1
   - Loader: Forge 47.4.0
3. **Extract your clean zip to the instance folder**
4. **Launch normally**

## 🎯 Quick Fix for Current Issue:

Your friend needs to:
1. Delete the current corrupted instance
2. Install fresh Forge 47.4.0
3. Get a clean package from you using this guide

## 🚀 Alternative: Modrinth/CurseForge Distribution

For future sharing, consider publishing on:
- Modrinth (easier distribution)
- CurseForge (larger audience)
- Both platforms handle all the packaging automatically

This ensures everyone gets clean, working mod files without corruption issues.