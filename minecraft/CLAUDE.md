## CONTEXT & ENVIRONMENT

1.  **Host:** Windows Desktop
2.  **Minecraft Version:** 1.20.1
3.  **Modloader:** Forge
4.  **Mod Manager:** `Minecraft Mod Manager (mmm)` - located in the instance directory.
5.  **Launcher:** `Prism Launcher` - MultiMC-based launcher with enhanced mod management.

**⚠️ CRITICAL: You MUST use Prism Launcher as the primary launcher for this modpack.**

**mmm Configuration Files:**
- `modlist.json` - Main configuration file with mod definitions
- `modlist-lock.json` - Version-locked mod information for consistency
- `.mmmignore` - Files to exclude from mmm management

**Instance Location:**
- **Prism Launcher Instance:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\`
- **Minecraft Directory:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft\`
- **Mods Directory:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft\mods\`
- **Server Root Directory:** `C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\`

## GOAL

**THIS IS THE MAIN PRODUCTION DOCUMENTATION**

1.  Use **Prism Launcher** to manage and launch the PlepperVR modpack.
2.  Use **mmm** for mod management operations (adding, updating, removing mods).
3.  Create server file structure and setup for multiplayer deployment.
4.  **TEST:** Thoroughly test all functionality before production deployment.
5.  **BACKUP:** Maintain Git backups of configurations to GitHub repositories.

## FULL MOD LIST (Managed by mmm)

**Total Mods: 86 managed by mmm + 1 unmanaged**

### 🛠️ VR Foundation & Core Support
* **ImmersiveMC** - VR interface integration
* **Oculus** - Shaders support for VR
* **Vivecraft** - Main VR mod (manual installation, excluded from mmm)

### 🚀 Performance & Utility
* **Embeddium** - Performance optimization (successor to Sodium)
* **FerriteCore** - Memory optimization
* **ModernFix** - Game optimization and bug fixes
* **Entity Culling** - Performance enhancement
* **Clumps** - Experience orb optimization
* **NetherPortalFix** - Portal optimization
* **Better Advancements** - (unmanaged version for custom configuration)

### 🗺️ Exploration, Mobs & World Gen
* **Terralith** - Enhanced world generation
* **YUNG's Better Structures** - Complete structure overhaul series
  - YUNG's Better Desert Temples
  - YUNG's Better Jungle Temples
  - YUNG's Better Mineshafts
  - YUNG's Better Ocean Monuments
  - YUNG's API (required library)
* **Alex's Mobs** - Extensive mob additions
* **Alex's Caves** - Cave generation overhaul
* **Naturalist** - Nature additions
* **Waystones** - Teleportation system
* **Nature's Compass** - Biome finding
* **Lootr** - Improved loot chests

### 🎒 Core QoL & Inventory
* **Sophisticated Backpacks** - Advanced backpack system
* **Sophisticated Storage** - Advanced storage solutions
* **Sophisticated Core** - Required library for Sophisticated mods
* **Just Enough Items (JEI)** - Item and recipe viewer
* **Jade** - Information overlay HUD
* **AppleSkin** - Food saturation display
* **Controlling** - Keybinding management
* **Mouse Tweaks** - Enhanced mouse controls
* **Inventory Tweaks: ReFoxed** - Inventory management
* **Carry On** - Block and entity carrying
* **Enchantment Descriptions** - Tooltips for enchantments
* **KleeSlabs** - Slab and stair variations

### ⚙️ Technology (Core & Addons)
* **Mekanism** - Complete tech suite
  - Mekanism (Core Mod)
  - Mekanism: Generators
  - Mekanism: Additions
* **Applied Energistics 2 (AE2)** - Advanced item/fluid storage and automation
* **Iron Jetpacks** - Flight equipment
* **Create** - Comprehensive automation and building mod
  - Create: Enchantment Industry
  - Create: Ore Excavation
  - Create Deco
* **Pipez** - Simple pipe system for item/fluid transport

### ✨ Magic & Adventure
* **Ars Nouveau** - Magic system
* **Ars Caelum** - Ars Nouveau expansion
* **Curios API** - Equipment slots system
  - Curios API (Forge/NeoForge)

### ⛏️ Mining & Utility
* **Vein Mining** - Automated vein mining
* **FallingTree** - Tree chopping automation

### 🧱 Enhanced Building Tools
* **Effortless Building** - Advanced building tools

### 🧑‍🌾 Farming, Cooking & Communication
* **Farmer's Delight** - Comprehensive farming and cooking
* **Cooking for Blockheads** - Advanced kitchen system
* **My Nether's Delight** - Nether farming expansion
* **Macaw's Series** - Building decorations
  - Macaw's Doors
  - Macaw's Windows
  - Macaw's Furniture
* **Supplementaries** - Additional building blocks and items
* **Simple Voice Chat** - Proximity voice chat

### 🔧 Libraries & Dependencies
* **Sophisticated Core** - Core library
* **Cloth Config API** - Configuration system
* **Architectury API** - Cross-mod loader compatibility
* **FTB Library** - FTB mod foundation
* **FTB Teams** - Team management
* **Balm** - Shared library
* **Citadel** - Library dependency
* **Bookshelf** - Library for mod compatibility
* **Cucumber Library** - Testing and utility library
* **Kotlin for Forge** - Kotlin language support
* **Moonlight Lib** - Library for various mods
* **libIPN** - Cross-mod communication
* **SuperMartijn642's Config Lib** - Configuration library
* **SuperMartijn642's Core Lib** - Core library for SM642 mods
* **Patchouli** - Documentation system
* **GuideME** - In-game guide system

### 🌐 Utility & UI
* **JourneyMap** - Minimap and world map
* **Not Enough Crashes** - Crash reporting
* **Configured** - Configuration menu
* **Searchables** - Search functionality
* **Trash Cans** - Item disposal

---

## STEP-BY-STEP INSTRUCTIONS

### PART 1: Prism Launcher Setup

**Prism Launcher is the primary launcher for this modpack.**

**Installation:**
1. **Download Prism Launcher** from https://prismlauncher.org/download
2. **Install** Prism Launcher (Windows executable recommended)
3. **Launch** Prism Launcher

**Import the Instance:**
1. **Open Prism Launcher**
2. **Add Instance** → **Import**
3. **Navigate to:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\`
4. **Select** `instance.cfg` and import
5. **Configure** Java settings (Java 17+ recommended, 8GB RAM)

**Instance Configuration:**
- **Minecraft Version:** 1.20.1
- **Mod Loader:** Forge
- **Memory:** 8GB recommended for VR
- **Java:** 17+ (auto-detected or manual selection)

### PART 2: mmm Mod Management

**All mod management operations use mmm from the minecraft directory.**

**Navigate to Instance Directory:**
```bash
cd "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft"
```

**Basic mmm Commands:**
```bash
# Install all mods from configuration
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
- **Loader:** Forge
- **Game Version:** 1.20.1
- **Mods Folder:** mods (relative)
- **Allowed Release Types:** release, beta
- **Managed Mods:** 85
- **Unmanaged Mods:** 1 (Better Advancements - manual version)

### PART 3: Server Setup & Server File Creation

**Create Server Directory Structure:**
1. **Create Server Directory:** `C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\`
2. **Create Mods Directory:** `C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\mods\`

**Copy Mods to Server:**
3. **Copy all mods** from Prism instance to server:
   ```bash
   Copy-Item "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft\mods\*.jar" "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\mods\"
   ```

**Forge Server Installation:**
4. **Download Forge Server Installer** for 1.20.1
5. **Extract** to server directory
6. **Run Forge Installer:** `java -jar forge-1.20.1-47.2.20-installer.jar --installServer`
7. **Accept EULA:** Create `eula.txt` with `eula=true`

**Create Server Launch Script:**
8. **Create** `START_SERVER.bat` in server directory:
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

**Server Exclusions:**
9. **Remove VR-only mods** from server (client-side only):
   - Oculus (shaders)
   - Vivecraft (VR-specific features)

---

## 🧪 TESTING WORKFLOW

### Testing Environment

**Primary Testing Environment:**
- **Client:** Prism Launcher instance (`PlepperVR_Test`)
- **Server:** Local server setup for multiplayer testing
- **Mod Management:** mmm for all operations

**Testing Paths:**
- **Client Instance:** `C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\`
- **Server Instance:** `C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\`
- **Production Repository:** `https://github.com/PlepperGuy/PlepperVR`

### 🚨 TESTING PROTOCOL

**Before Production Deployment:**

1. **Client Testing:**
   - Launch Prism Launcher instance
   - Verify all 86 mods load without crashes
   - Test VR functionality (ImmersiveMC, Vivecraft)
   - Test major mod interactions (JEI, Mekanism, Create, Ars Nouveau)
   - Test performance with optimizations
   - Test key features: Waypoints, inventory management, building tools

2. **Mod Management Testing:**
   - Test `mmm.exe install` works correctly
   - Test `mmm.exe update` updates mods properly
   - Test `mmm.exe add` can add new mods
   - Verify Prism's built-in mod manager works
   - Test compatibility between Prism and mmm

3. **Server Testing:**
   - Start server using `START_SERVER.bat`
   - Verify server loads without Oculus (client-side only)
   - Test client connection to server
   - Test mod interactions in multiplayer
   - Test world generation and dimension loading
   - Test server-specific features

4. **Performance Testing:**
   - Monitor RAM usage with all mods loaded
   - Test FPS stability in VR (30+ FPS target)
   - Test world loading times
   - Test server TPS with multiple players

### 📋 Testing Checklist

**Prism Launcher Testing:**
- [ ] Instance imports successfully
- [ ] All 86 mods load without errors
- [ ] Java configuration correct (17+)
- [ ] Memory allocation adequate (8GB+)
- [ ] VR settings configured properly

**Client Testing:**
- [ ] Instance launches without errors
- [ ] VR controllers work (ImmersiveMC)
- [ ] JEI functions correctly
- [ ] JourneyMap renders correctly
- [ ] Major tech mods functional (Mekanism, Create, AE2)
- [ ] Magic mods functional (Ars Nouveau)
- [ ] Performance acceptable (30+ FPS in VR)
- [ ] No mod conflicts or crashes

**mmm Testing:**
- [ ] `mmm.exe install` downloads all mods
- [ ] `mmm.exe list` shows all 86 mods
- [ ] `mmm.exe update` works without errors
- [ ] `mmm.exe add` can add new mods successfully
- [ ] Configuration files maintained properly

**Server Testing:**
- [ ] Server starts without Oculus errors
- [ ] All mods load correctly
- [ ] Clients can connect successfully
- [ ] World generation works (Terralith, structures)
- [ ] Multiplayer features work
- [ ] Server TPS remains stable (18+ TPS)
- [ ] No server crashes or memory issues

### 🚀 PRODUCTION DEPLOYMENT

**Only deploy to production after all tests pass:**

1. **Create Production Release:**
   - Copy Prism instance to production location
   - Copy server files to production server
   - Update documentation with final configuration

2. **Upload to GitHub:**
   - Commit Prism configuration files
   - Commit server configuration
   - Create release with version information

3. **Production Verification:**
   - Test production instance launch
   - Test production server functionality
   - Verify documentation accuracy

---

## MODPACK MANAGEMENT & AUTOMATION

### 📋 mmm Mod Management

**Adding New Mods:**
```bash
cd "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft"

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

# Prune orphaned files
./mmm.exe prune -f
```

### 🔧 Prism Launcher Integration

**Built-in Mod Management:**
- **Edit** → **Manage Mods** (Ctrl+M)
- **Direct access** to Modrinth and CurseForge
- **One-click updates** with dependency resolution
- **Enable/disable** mods with checkboxes

**Prism + mmm Workflow:**
1. **Prism Launcher** for quick additions and GUI management
2. **mmm** for batch operations and precise version control
3. **Both systems** synchronized through shared mod files

### 🔄 Development Workflow

**Daily Development:**
```bash
# 1. Launch with Prism Launcher
# 2. Make changes with mmm or Prism
# 3. Test functionality
# 4. Update documentation
```

**Mod Addition Process:**
```bash
# Option 1: Prism GUI
# Edit → Manage Mods → Download from Modrinth/CurseForge

# Option 2: mmm CLI
cd minecraft
./mmm.exe add modrinth <mod-name>
./mmm.exe install
```

**Bulk Operations:**
```bash
# Update all mods
./mmm.exe update

# Check configuration status
./mmm.exe list

# Clean up orphaned files
./mmm.exe prune -f
```

### 📦 Server Deployment

**Create Server from Prism Instance:**
```powershell
# Create server directory
New-Item -ItemType Directory -Path "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server"

# Copy mods (excluding client-only VR mods)
Copy-Item "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft\mods\*.jar" "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\mods\" -Exclude "Oculus*","vivecraft*"

# Copy configs
Copy-Item "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft\config\*" "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\config\" -Recurse

# Copy mmm configuration for server mod management
Copy-Item "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft\modlist.json" "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\"
Copy-Item "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft\mmm.exe" "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\"
```

---

## ⚡ QUICK REFERENCE COMMANDS

### Prism Launcher Setup
```bash
# Install Prism Launcher
# Download from https://prismlauncher.org/download

# Import instance
# Add Instance → Import → Select instance.cfg
```

### mmm Operations (from minecraft directory)
```bash
# Navigate to instance directory
cd "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft"

# Install all mods
./mmm.exe install

# Update all mods
./mmm.exe update

# Add new mods
./mmm.exe add modrinth <slug>
./mmm.exe add curseforge <id>

# List mods
./mmm.exe list

# Remove mods
./mmm.exe remove <mod-name>

# Scan for changes
./mmm.exe scan --add

# Clean up
./mmm.exe prune -f
```

### Common Mod Examples
```bash
# Performance mods
./mmm.exe add modrinth embeddium
./mmm.exe add modrinth ferritecore
./mmm.exe add modrinth modernfix

# Utility mods
./mmm.exe add modrinth jade
./mmm.exe add modrinth jei

# Technology mods
./mmm.exe add modrinth create
./mmm.exe add modrinth mekanism
```

### Server Management
```powershell
# Create server from Prism instance
New-Item "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server" -ItemType Directory
Copy-Item "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test\minecraft\mods\*.jar" "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\mods"
```

### Configuration Files
- `modlist.json` - Main mmm configuration
- `modlist-lock.json` - Version lock file (commit this!)
- `.mmmignore` - Files to exclude from management
- `instance.cfg` - Prism Launcher configuration

---

## 📚 SUPPORTING DOCUMENTATION

### Migration Guides
- **`PRISM_MIGRATION_GUIDE.md`** - Complete ATLauncher to Prism migration documentation
- **`FERIUM_TO_MMM_MIGRATION.md`** - Ferium to mmm migration history
- **`PRISM_MIGRATION_GUIDE.md`** - Prism Launcher specific guide

### Key Files
- **`CLAUDE.md`** - This main documentation file
- **`prism.md`** - Prism Launcher general information
- **`minecraftmodmanager.md`** - mmm documentation

### Troubleshooting

**Common Issues:**
- **Prism import fails:** Check instance.cfg file exists and is valid
- **Mods not loading:** Verify Forge installation and Java 17+
- **mmm errors:** Ensure running from correct minecraft directory
- **VR issues:** Check ImmersiveMC and Vivecraft configuration

**Recovery Commands:**
```bash
# Reset mmm installation
./mmm.exe install --force

# Clean up orphaned files
./mmm.exe prune -f

# Re-scan for changes
./mmm.exe scan --add

# Check configuration
./mmm.exe list
```

---

**Project Status:** ✅ **Fully Migrated to Prism Launcher + mmm**
**Total Mods:** 86 (85 managed by mmm + 1 unmanaged)
**Launcher:** Prism Launcher (primary)
**Mod Manager:** Minecraft Mod Manager (mmm)
**Last Updated:** November 5, 2025