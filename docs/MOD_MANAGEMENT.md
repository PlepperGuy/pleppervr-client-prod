# Mod Management with mmm

This guide covers all aspects of using Minecraft Mod Manager (mmm) to maintain the PlepperVR modpack.

## Common Commands

Navigate to the correct directory first:
```bash
cd /path/to/pleppervr-client-testing
```

### Basic Operations

```bash
# Install all mods from modlist.json
./mmm.exe install

# Add a new mod from Modrinth
./mmm.exe add modrinth <project-id>

# Add a new mod from CurseForge
./mmm.exe add curseforge <project-id>

# Update all mods to their latest compatible versions
./mmm.exe update

# List all mods managed by mmm
./mmm.exe list

# Remove a mod
./mmm.exe remove <mod-name>

# Check for available updates
./mmm.exe outdated
```

## Workflow

### Adding New Mods

1. Research the mod on Modrinth or CurseForge
2. Note the project ID
3. Add the mod: `./mmm.exe add modrinth <project-id>`
4. Test in singleplayer
5. Update documentation in `CLAUDE.md`
6. Commit changes to git

### Updating Mods

1. Check for updates: `./mmm.exe outdated`
2. Update all mods: `./mmm.exe update`
3. Test thoroughly in singleplayer
4. Update documentation if versions have changed significantly
5. Commit updated `modlist-lock.json`

### Removing Mods

1. Remove the mod: `./mmm.exe remove <mod-name>`
2. Test that the game still launches properly
3. Check for dependencies that might need removal
4. Update documentation
5. Commit changes

## Important Files

- `modlist.json`: Primary mod configuration file
- `modlist-lock.json`: Version lock file for consistency
- Both files should be committed to git

## Best Practices

1. Always test after mod changes
2. Update documentation immediately after making changes
3. Commit both modlist files together
4. Use specific version numbers when possible for stability
5. Keep backups of working configurations