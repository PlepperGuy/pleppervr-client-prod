# PlepperVR Client Testing Instance

**Repository:** https://github.com/PlepperGuy/pleppervr-client-testing.git
**Instance Type:** Prism Launcher Client
**Version:** 1.20.1 with Forge 47.2.20

## Testing Environment

This is the **testing client** instance for PlepperVR development.

### Launcher Configuration
- **Launcher:** Prism Launcher
- **Instance Name:** pleppervr-client-testing
- **Memory Allocation:** 4-8GB (8GB+ for VR)
- **Java Version:** 17+
- **VR Ready:** Yes (ImmersiveMC + Vivecraft)

### Mod Management
- **Mod Manager:** Minecraft Mod Manager (mmm)
- **Total Mods:** 86 (managed) + 1 (unmanaged)
- **Configuration:** modlist.json + modlist-lock.json

### Quick Start
1. **Launch with Prism Launcher**
2. **Test mod loading:** All 86+ mods should load successfully
3. **Test VR functionality:** Connect VR headset before launching
4. **Test performance:** Target 30+ FPS in VR

### Development Workflow
```bash
# Navigate to minecraft directory
cd minecraft

# Install/update mods
./mmm.exe install
./mmm.exe update

# Add new mods
./mmm.exe add modrinth <mod-id>
./mmm.exe add curseforge <project-id>

# List managed mods
./mmm.exe list
```

### Testing Checklist
- [ ] Instance launches without errors
- [ ] All mods load successfully
- [ ] VR controllers work (ImmersiveMC)
- [ ] Performance acceptable in VR
- [ ] No mod conflicts or crashes
- [ ] Multiplayer connection works

### Key Features
- **VR Support:** Full VR gameplay with ImmersiveMC
- **Performance:** Optimized with Embeddium, FerriteCore, ModernFix
- **Technology:** Mekanism, Create, Applied Energistics 2
- **Magic:** Ars Nouveau, Curios API
- **Exploration:** Terralith, Better Structures, Alex's Mobs

Last Updated: November 5, 2025
Status: Testing Ready