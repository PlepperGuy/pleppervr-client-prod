## CONTEXT & ENVIRONMENT

1.  **Host:** Windows Desktop
2.  **Minecraft Version:** 1.20.1
3.  **Modloader:** Forge 47.2.20
4.  **Launcher:** Prism Launcher (MultiMC-based launcher with enhanced mod management)
5.  **Mod Manager:** `Minecraft Mod Manager (mmm)` - pre-installed in the minecraft directory.

**⚠️ CRITICAL: You MUST use Prism Launcher as the primary launcher and mmm for mod management.**

**Prism Launcher Configuration:**
- **Instance Name:** `PlepperVR_Test` (Testing Environment)
- **Instance Type:** OneSix (Minecraft 1.20.1 + Forge)
- **Memory Allocation:** 4GB-8GB (8GB+ recommended for VR)
- **Java Version:** 17+ (auto-detected)
- **Instance Path:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\`

**mmm Configuration Files:**
- `modlist.json` - Main configuration file with mod definitions
- `modlist-lock.json` - Version-locked mod information for consistency
- `.mmmignore` - Files to exclude from mmm management

**Repository Structure:**
- **Client Testing:** `https://github.com/PlepperGuy/pleppervr-client-testing.git`
- **Client Production:** `https://github.com/PlepperGuy/pleppervr-client-prod.git`
- **Server Testing:** `https://github.com/PlepperGuy/pleppervr-server-testing.git`
- **Server Production:** `https://github.com/PlepperGuy/pleppervr-server-prod.git`

**Directory Paths:**
- **Client Instance:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\`
- **Minecraft Directory:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft\`
- **Client Mods:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft\mods\`
- **Server Testing:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test_Server\`
- **Server Production:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Server\`

## GOAL

**THIS IS THE TESTING ENVIRONMENT DOCUMENTATION**

1.  Use `mmm` to manage and install all client-side mods into the **TESTING** Prism Launcher instance (`PlepperVR_Test`).
2.  Create the full **TESTING** server file structure, download the Forge server files, and create a launch script.
3.  Copy all mods from the client folder to the **TESTING** server's new `mods` folder, creating a complete server modpack archive.
4.  **TEST:** Thoroughly test all functionality in the testing environment before proceeding to production.
5.  **BACKUP:** Maintain Git backups of client and server configurations to GitHub repositories (only from production after testing).

## FULL MOD LIST (Client-Side - Managed by mmm)

**Total Mods: 86 managed by mmm + 1 unmanaged**

### PRIORITY DEPENDENCIES (Core Libraries)
* **Sophisticated Core**
* **Cloth Config**
* **FTB Library**
* **FTB Teams**

### 🛠️ VR Foundation & Core Support
* ImmersiveMC
* Oculus
* Vivecraft (manual installation, excluded from mmm)

### 🚀 Performance & Utility
* Embeddium, FerriteCore, ModernFix, Entity Culling, Clumps, NetherPortalFix
* Better Advancements (unmanaged version)

### 🗺️ Exploration, Mobs, & World Gen
* Terralith, YUNG's Better Structures (Series), Alex's Mobs, Alex's Caves, Naturalist
* Waystones, Nature's Compass, Lootr

### 🎒 Core QoL & Inventory
* Sophisticated Backpacks, Sophisticated Storage
* Just Enough Items (JEI), Jade, AppleSkin, Controlling, Mouse Tweaks
* Inventory Tweaks: ReFoxed, Carry On, Enchantment Descriptions, KleeSlabs

### ⚙️ Technology (Core & Addons)
* Mekanism (Core Mod), Mekanism: Generators, Mekanism: Additions
* Applied Energistics 2 (AE2)
* Iron Jetpacks
* Create (Core Mod)
* Create: Enchantment Industry, Create: Ore Excavation, Create Deco

### ✨ Magic & Adventure
* Ars Nouveau (Core Mod), Ars Caelum
* Curios API

### ⛏️ Mining & Utility
* Vein Mining, FallingTree

### 🧱 Enhanced Building Tools
* Effortless Building

### 🧑‍🌾 Farming, Cooking & Communication
* Farmer's Delight, Cooking for Blockheads
* My Nether's Delight
* Macaw's Series (Furniture/Doors/Windows), Supplementaries
* Simple Voice Chat

---

## STEP-BY-STEP INSTRUCTIONS

### PART 1: mmm Mod Management

**IMPORTANT:** Always run mmm commands from the PlepperVR_Test directory.

**Basic mmm Commands:**
```bash
# Navigate to mod directory first
cd "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test"

# Install all mods from modlist.json
./mmm.exe install

# Add new mods
./mmm.exe add modrinth <project-id>      # From Modrinth
./mmm.exe add curseforge <project-id>    # From CurseForge

# Update all mods to latest versions
./mmm.exe update

# List all managed mods
./mmm.exe list

# Scan for unmanaged mods and optionally add them
./mmm.exe scan --add

# Remove mods
./mmm.exe remove <mod-name>
```

**Current mmm Configuration:**
- **Loader:** Forge 47.2.20
- **Game Version:** 1.20.1
- **Mods Folder:** mods (relative to minecraft directory)
- **Allowed Release Types:** release, beta
- **Managed Mods:** 86
- **Unmanaged Mods:** 1 (Better Advancements - manual version)
- **mmm Version:** v2.0.12 (latest)
- **Last Updated:** November 5, 2025

### PART 2: Server Setup & Server File Creation

1.  Set `SERVER_ROOT_DIR` to: `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test_Server\`
2.  Set `SERVER_MOD_DIR` to: `%SERVER_ROOT_DIR%\mods`
3.  Create both directories: `%SERVER_ROOT_DIR%` and `%SERVER_MOD_DIR%`
4.  **Copy Mods:** Copy **ALL** `.jar` files from `mods` directory to `%SERVER_MOD_DIR%`
5.  Change directory to `%SERVER_ROOT_DIR%`
6.  **Download Forge Installer:** Download Forge 1.20.1 installer JAR into `%SERVER_ROOT_DIR%`
7.  **Install Forge Server:** Execute: `java -jar forge-1.20.1-47.2.20-installer.jar --installServer`
8.  **Accept EULA:** Create `eula.txt` with `eula=true`
9.  **Create Launch Script:** Create `START_SERVER.bat` in `%SERVER_ROOT_DIR%`:

```batch
@echo off
set JAVACMD=java
set MIN_RAM=4G
set MAX_RAM=8G
set SERVER_JAR=libraries/net/minecraftforge/forge/1.20.1-47.2.20/win_args.txt

echo Starting Minecraft Forge Server...
"%JAVACMD%" -Xmx%MAX_RAM% -Xms%MIN_RAM% @user_jvm_args.txt @%SERVER_JAR% nogui
PAUSE
```

---

## 🧪 TESTING WORKFLOW

### Testing Environment Setup

**This is a testing instance** of the PlepperVR modpack. All changes should be thoroughly tested here before publishing to production.

**Testing Paths:**
- **Client Test Instance:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test`
- **Server Test Instance:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test_Server`
- **Production Repository:** `https://github.com/PlepperGuy/PlepperVR`

### 🚨 TESTING PROTOCOL

**Before Publishing to Production:**

1. **Client Testing:**
   - Launch `PlepperVR_Test` instance
   - Verify all 86 mods load without crashes
   - Test VR functionality (ImmersiveMC, Vivecraft)
   - Test major mod interactions (JEI, Mekanism, Create, Ars Nouveau)
   - Test performance with Embeddium and optimizations
   - Test key features: Waypoints, inventory management, building tools

2. **Server Testing:**
   - Start `PlepperVR_Test_Server` using `START_SERVER.bat`
   - Verify server loads without crashes (Oculus should be excluded)
   - Test client connection to test server
   - Test mod interactions in multiplayer
   - Test world generation and dimension loading
   - Test server-specific features (chunks, waystones sharing)

3. **mmm Testing:**
   - Test `mmm.exe install` works correctly
   - Test `mmm.exe update` updates mods properly
   - Test `mmm.exe add` can add new mods
   - Verify modlist.json and modlist-lock.json are created correctly

4. **Performance Testing:**
   - Monitor RAM usage with all mods loaded
   - Test FPS stability in VR
   - Test world loading times
   - Test server TPS with multiple players

### 📋 Testing Checklist

**Client Testing:**
- [ ] Instance launches without errors
- [ ] All 86+ mods load successfully
- [ ] VR controllers work (ImmersiveMC)
- [ ] JEI functions correctly
- [ ] JourneyMap renders correctly
- [ ] Major tech mods functional (Mekanism, Create, AE2)
- [ ] Magic mods functional (Ars Nouveau)
- [ ] Performance acceptable (30+ FPS in VR)
- [ ] No mod conflicts or crashes

**Server Testing:**
- [ ] Server starts without Oculus errors
- [ ] All mods load correctly
- [ ] Clients can connect successfully
- [ ] World generation works (Terralith, structures)
- [ ] Multiplayer features work (chunks, voice chat)
- [ ] Server TPS remains stable (18+ TPS)
- [ ] No server crashes or memory issues

**mmm Testing:**
- [ ] `mmm.exe install` downloads all mods
- [ ] `mmm.exe list` shows all 86 mods
- [ ] `mmm.exe update` works without errors
- [ ] Configuration files are properly maintained

### 🚀 PUBLISHING TO PRODUCTION

**Only publish to production after all tests pass:**

1. **Update Documentation:**
   - Update `modlist.md` with current mods
   - Update version information
   - Review and update `CLAUDE.md`

2. **Create Production Release:**
   - Copy tested mods from `PlepperVR_Test` to `PlepperVR`
   - Copy tested server files to `PlepperVR_Server`
   - Copy mmm configuration to production
   - Update main `modlist.md`

3. **Upload to GitHub:**
   - Create Prism Launcher export from `PlepperVR`
   - Use `upload_to_github.bat` in production directory
   - Verify upload completes successfully

4. **Production Verification:**
   - Test download from production repository
   - Verify update scripts work with production files
   - Confirm production repository is updated

## 🔄 REPOSITORY STATUS & SYNCHRONIZATION

### Current Git Status
**All repositories synchronized as of November 5, 2025**

**Latest Commit:** `c6e7405` - "Complete ATLauncher removal and migration to Prism Launcher + mmm"

### Repository Structure
```
pleppervr-client-testing.git    ← Current working repository (origin)
pleppervr-client-prod.git       ← Production client repository
pleppervr-server-testing.git    ← Testing server repository
pleppervr-server-prod.git       ← Production server repository
```

### Synchronization Status
- ✅ **Client Testing**: Up to date (source repository)
- ✅ **Client Production**: Synchronized with latest changes
- ✅ **Server Testing**: Synchronized with latest changes
- ✅ **Server Production**: Synchronized with latest changes

### Git Remote Configuration
```bash
origin          → pleppervr-client-testing.git (current)
client-prod     → pleppervr-client-prod.git
server-testing  → pleppervr-server-testing.git
server-prod     → pleppervr-server-prod.git
```

### Migration Completion
**ATLauncher → Prism Launcher migration:**
- ✅ Complete ATLauncher removal from all documentation
- ✅ Prism Launcher configuration files created and updated
- ✅ mmm integration fully configured
- ✅ All 86 mods managed through mmm system
- ✅ Batch scripts updated for Prism + mmm workflow
- ✅ Repository synchronization complete

### Quick Sync Commands
```bash
# Push to all repositories
git push origin master                    # Testing client
git push client-prod master               # Production client
git push server-testing master            # Testing server
git push server-prod master               # Production server

# Pull latest changes from testing
git pull origin master

# Force update all repositories (if needed)
git push origin master --force
git push client-prod master --force
git push server-testing master --force
git push server-prod master --force
```

---

## BACKUP & VERSION CONTROL (PRODUCTION)

### CLIENT BACKUP INSTRUCTIONS

**IMPORTANT:** Only export from production instance after testing is complete.

1.  **Create Prism Launcher Export:**
    - **IMPORTANT:** Only export from production `PlepperVR` instance (not `PlepperVR_Test`)
    - Open Prism Launcher
    - Navigate to your `PlepperVR` instance (production)
    - Click "Export" or "Create Package"
    - Save the exported `.zip` file to a convenient location

2.  **Backup Export to GitHub:**
    - **Repository:** `https://github.com/PlepperGuy/PlepperVR`
    - Copy the exported `.zip` file to the repository
    - Commit and push with descriptive version notes
    - Example commit message: "Release v1.1.0 - Added VR enhancements and performance optimizations"

### SERVER BACKUP INSTRUCTIONS

1.  **Initialize Server Git Repository:**
    - **IMPORTANT:** Only backup production server after testing is complete
    - Navigate to `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Server\` (production)
    - Initialize Git and connect to remote repository

2.  **Backup to GitHub:**
    - **Repository:** `https://github.com/PlepperGuy/PlepperVR-Server`
    - Commit all server files (mods, configs, scripts)
    - Push to GitHub with version information

### BACKUP WORKFLOW

1.  **Before Making Changes:** Create current backup
2.  **After Major Updates:** Export client and backup server
3.  **Version Naming:** Use semantic versioning (v1.0.0, v1.0.1, etc.)
4.  **Commit Messages:** Include change summary and date

---

## MODPACK MANAGEMENT & AUTOMATION

### 📋 Updating modlist.md

**When to Update:**
- After installing or removing mods
- After major version updates
- Before creating releases
- When sharing modpack with others

**Update Process:**
1. **Check Installed Mods:**
   ```bash
   cd "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test"
   ./mmm.exe list
   ```

2. **Update modlist.md:**
   - Remove non-existent mods
   - Add newly installed mods
   - Update descriptions and categories
   - Update total mod count
   - Update version and date

3. **Verify Accuracy:**
   - Cross-check with `mmm.exe list` output
   - Ensure all categories are correct
   - Verify descriptions match functionality

### 🚀 Automated Scripts

#### Client Upload Script (`upload_to_github.bat`)

**Purpose:** Upload modpack exports to GitHub with automatic naming and Git operations

**Prerequisites:**
- Git installed and configured
- `PlepperVR 1.20.1.zip` in current directory
- Push access to the repository

**Usage:**
1. Create Prism Launcher export as `PlepperVR 1.20.1.zip`
2. Run `upload_to_github.bat`
3. Script will:
   - Validate file exists and size
   - Rename to `PlepperVR-main.zip` (expected by update scripts)
   - Initialize Git repository if needed
   - Create commit with timestamp
   - Push to GitHub

#### Update Scripts

**Client Update Script (`update_modpack.bat`)**
- Downloads latest modpack from GitHub
- Creates backup of current installation
- Extracts and installs updates
- Works with both curl and PowerShell

**Server Update Script (`update_server.bat`)**
- Downloads latest server files from GitHub
- Backs up existing server installation
- Updates mods and configurations
- Preserves server-specific settings

### 🔄 Development Workflow

**1. Making Mod Changes with mmm:**

**Adding New Mods:**
```bash
cd "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test"

# Add Modrinth mod (using slug or ID)
./mmm.exe add modrinth sodium
./mmm.exe add modrinth AANobbMI

# Add CurseForge mod (using project ID)
./mmm.exe add curseforge 306612

# Install the new mod
./mmm.exe install
```

**Updating Existing Mods:**
```bash
# Update all mods to latest versions
./mmm.exe update

# Install specific version (if needed)
./mmm.exe add modrinth sodium --version 0.5.5
```

**Managing Mod Configuration:**
```bash
# List all mods and their status
./mmm.exe list

# Remove a mod
./mmm.exe remove sodium

# Scan for unmanaged mods
./mmm.exe scan --add
```

**2. Update Documentation:**
- Edit `modlist.md` with new mods
- Update descriptions and categories
- Verify total count is accurate

**3. Create Backup:**
```bash
# Create Prism Launcher export
# Then run upload script
upload_to_github.bat
```

**4. Test Updates:**
- Run `update_modpack.bat` to test client download
- Run `update_server.bat` to test server update
- Verify both scripts work correctly

**5. Complete Testing Checklist:**
- Use `mmm.exe list` to verify all mods are managed
- Follow VR-specific testing procedures
- Validate server multiplayer functionality
- Document any issues found

### 🧪 MMM-SPECIFIC WORKFLOW

### Mod Management with mmm

**Adding Mods:**
```bash
# From Modrinth (preferred)
./mmm.exe add modrinth <slug-or-id>

# From CurseForge
./mmm.exe add curseforge <project-id>

# Examples
./mmm.exe add modrinth sodium
./mmm.exe add modrinth AANobbMI
./mmm.exe add curseforge 306612
```

**Managing Versions:**
```bash
# Install specific version
./mmm.exe add modrinth sodium --version 0.5.5

# Lock current versions (modlist-lock.json does this automatically)
./mmm.exe install
```

**Bulk Operations:**
```bash
# Install all mods from configuration
./mmm.exe install

# Update all mods
./mmm.exe update

# Remove multiple mods
./mmm.exe remove mod1 mod2 mod3
```

**Configuration Management:**
- `modlist.json` - Edit manually for advanced configuration
- `modlist-lock.json` - Auto-generated, ensures version consistency
- `.mmmignore` - Exclude specific files from management

### Troubleshooting mmm

**Common Issues:**
```bash
# Check configuration
./mmm.exe list

# Fix version conflicts
./mmm.exe install --force

# Scan for orphaned files
./mmm.exe scan

# Prune unmanaged files
./mmm.exe prune -f
```

### 📝 Important Notes

- **ALWAYS use `./mmm.exe install` to install mods** - this ensures proper dependency resolution
- **modlist.json is the primary configuration file** - edit with care
- **modlist-lock.json ensures version consistency** - commit both files to version control
- **Update scripts use main branch archives** - not GitHub releases (no releases created yet)
- **Server excludes large files** from Git (mods, libraries) to stay within GitHub limits
- **Always test after changes** - run both update scripts to verify functionality
- **Keep backups** - scripts create automatic backups before updating

## ⚡ QUICK REFERENCE COMMANDS

### Most Common mmm Tasks:
```bash
# Navigate to mod directory (always do this first)
cd "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test"

# Install all mods from configuration
./mmm.exe install

# Update all mods to latest versions
./mmm.exe update

# Add new mods
./mmm.exe add modrinth <slug>
./mmm.exe add curseforge <id>

# List all managed mods
./mmm.exe list

# Remove mods
./mmm.exe remove <mod-name>

# Scan for unmanaged mods
./mmm.exe scan --add
```

### Mod Addition Examples:
```bash
# Performance mods
./mmm.exe add modrinth embeddium
./mmm.exe add modrinth ferritecore

# Utility mods
./mmm.exe add modrinth jade
./mmm.exe add modrinth jei

# Technology mods
./mmm.exe add modrinth create
./mmm.exe add modrinth mekanism
```

### Troubleshooting:
```bash
# Check configuration status
./mmm.exe list

# Force reinstall all mods
./mmm.exe install --force

# Clean up orphaned files
./mmm.exe prune -f

# Check for version conflicts
./mmm.exe install
```

### Configuration Files:
- `modlist.json` - Main configuration
- `modlist-lock.json` - Version lock file (commit this!)
- `.mmmignore` - Files to exclude from management

---

## 📊 PROJECT STATUS SUMMARY

### ✅ **COMPLETED MIGRATION - NOVEMBER 5, 2025**

**Migration from ATLauncher to Prism Launcher + mmm is 100% COMPLETE**

### 🎯 **Current State**
- **Launcher:** Prism Launcher (fully configured)
- **Mod Manager:** Minecraft Mod Manager (mmm) v2.0.12
- **Total Mods:** 86 (managed by mmm) + 1 (unmanaged)
- **Minecraft:** 1.20.1 with Forge 47.2.20
- **All Repositories:** Synchronized and up to date

### 🚀 **Ready for Production**
- ✅ Documentation fully updated
- ✅ All scripts migrated to Prism + mmm
- ✅ Configuration files properly structured
- ✅ Repository synchronization complete
- ✅ Testing environment ready

### 🔄 **Next Steps**
1. **Test** the current setup in Prism Launcher
2. **Verify** all 86 mods load correctly
3. **Test VR functionality** (ImmersiveMC, Vivecraft)
4. **Deploy** to production when testing is complete

### 📞 **Support**
- **Documentation:** This CLAUDE.md file
- **Migration History:** See `PRISM_MIGRATION_GUIDE.md`
- **mmm Documentation:** See `MinecraftModManager.md`
- **Troubleshooting:** Run `./mmm.exe list` to check status

**🎉 PlepperVR is now fully modernized with Prism Launcher and ready for VR adventures!**