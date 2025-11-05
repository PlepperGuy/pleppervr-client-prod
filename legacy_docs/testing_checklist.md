# PlepperVR Mod Testing Checklist

## 📋 Pre-Testing Setup
- [ ] Switch to `PlepperVR_Test` profile
- [ ] Run `ferium upgrade` to ensure all mods downloaded
- [ ] Verify mod count matches expected
- [ ] Check for any download errors in ferium output

## 🧪 Client Testing
### Launch & Loading
- [ ] Launch PlepperVR_Test instance
- [ ] Verify Minecraft loads without crashes
- [ ] Check for mod loading errors in logs
- [ ] Verify Forge loads correctly
- [ ] Check RAM usage is reasonable (<8GB allocated)

### Core Functionality
- [ ] Test basic movement and controls
- [ ] Test inventory interface
- [ ] Test crafting table functionality
- [ ] Test chest access and storage
- [ ] Test world generation (new world)

### VR-Specific Testing
- [ ] Test VR controllers work (ImmersiveMC)
- [ ] Test VR movement and teleportation
- [ ] Test VR inventory management
- [ ] Test VR build mode
- [ ] Check VR performance (30+ FPS)

### Key Mod Testing
- [ ] Test JEI item viewing and recipes
- [ ] Test JourneyMap rendering and waypoints
- [ ] Test major tech mods (Mekanism, Create, AE2)
- [ ] Test magic mods (Ars Nouveau, Apotheosis)
- [ ] Test performance mods (Embeddium optimizations)

## 🖥️ Server Testing
### Server Launch
- [ ] Start `PlepperVR_Test_Server` using START_SERVER.bat
- [ ] Verify server loads without Oculus errors
- [ ] Check all mods load successfully
- [ ] Verify server TPS remains stable (18+ TPS)
- [ ] Check server RAM usage is reasonable

### Multiplayer Testing
- [ ] Test client connection to test server
- [ ] Test mod interactions in multiplayer
- [ ] Test world generation with multiple players
- [ ] Test server-specific features (chunks, waystones sharing)
- [ ] Test voice chat functionality

## 📊 Performance Testing
- [ ] Monitor RAM usage with all mods loaded
- [ ] Test FPS stability in VR
- [ ] Test world loading times
- [ ] Test server performance with multiple players
- [ ] Check for memory leaks during extended play

## ✅ Completion Checklist
- [ ] All critical functions working
- [ ] No major crashes or errors
- [ ] Performance acceptable for gameplay
- [ ] VR functionality working correctly
- [ ] Server multiplayer working
- [ ] Update modlist.md with any changes
- [ ] Ready for production deployment

## 🚨 Issues Found
Document any issues discovered during testing:

1.
2.
3.

## 🔧 Resolution Status
- [ ] All issues resolved
- [ ] Documentation updated
- [ ] Ready for production