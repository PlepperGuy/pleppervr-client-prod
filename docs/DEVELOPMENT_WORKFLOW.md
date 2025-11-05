# Development & Backup Workflow

This workflow ensures that changes are tested before being pushed to production and that all repositories are kept in sync.

## Overview

The development process follows three main stages:
1. **Testing Environment**: Make and test changes
2. **Backup to GitHub**: Commit changes to testing repositories
3. **Production Push**: Update production folders and repositories

## Step 1: Making Changes (Testing Environment)

### Client Changes
Modify mods using mmm in the `pleppervr-client-testing` directory:

```bash
# Add new mod
./mmm.exe add modrinth <project-id>

# Update mods
./mmm.exe update

# Remove mod
./mmm.exe remove <mod-name>
```

### Server Changes
Copy updated mods to the server testing directory:

```bash
# Copy all mods to server testing directory
cp minecraft/mods/*.jar /path/to/pleppervr-server-testing/mods/
```

### Testing Requirements
**Client Testing:**
1. Launch the PlepperVR_Test instance
2. Verify all mods load correctly
3. Check for crashes and performance issues
4. Test core functionality (VR, performance mods, etc.)

**Server Testing:**
1. Copy updated mods to `pleppervr-server-testing`
2. Start the server
3. Test multiplayer functionality
4. Verify mod compatibility between client and server

## Step 2: Backup to GitHub (Testing Repos)

Once testing is successful, commit and push changes to testing repositories.

### Backup Client
```bash
cd /path/to/pleppervr-client-testing
git add .
git commit -m "Your descriptive commit message"
git push origin master
```

### Backup Server
```bash
cd /path/to/pleppervr-server-testing
git add .
git commit -m "Sync with client changes: <commit message>"
git push origin master
```

## Step 3: Pushing to Production

After confirming stability of testing versions, update production folders and repositories.

### Update Production Folders
```bash
# Update client production
cp -r /path/to/pleppervr-client-testing/* /path/to/pleppervr-client-prod/

# Update server production
cp -r /path/to/pleppervr-server-testing/* /path/to/pleppervr-server-prod/
```

### Backup to GitHub (Production Repos)

**Production Client:**
```bash
cd /path/to/pleppervr-client-prod
git add .
git commit -m "Release vX.X: <Description>"
git push origin master
```

**Production Server:**
```bash
cd /path/to/pleppervr-server-prod
git add .
git commit -m "Release vX.X: <Description>"
git push origin master
```

## Important Notes

1. **Never skip testing**: Always test thoroughly before production deployment
2. **Commit together**: When updating documentation, commit the related files together
3. **Version numbering**: Use semantic versioning for releases (v1.0.0, v1.0.1, etc.)
4. **Change logs**: Create or update `CHANGELOG.md` for each production release
5. **Backup verification**: Verify that commits have been pushed successfully to all repositories

## Emergency Rollback

If a production deployment causes issues:
1. Revert to the previous commit: `git revert HEAD`
2. Push the revert: `git push origin master`
3. Communicate the rollback to users
4. Investigate the issue and create a hotfix if needed