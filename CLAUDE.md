# PlepperVR Modpack Documentation

**This document is the central hub for the setup, management, and maintenance of the PlepperVR modpack. It serves as the official source of policies and procedures that all agents must adhere to.**

All development and commands should be executed from the root of the `pleppervr-client-testing` directory.

## 1. Project Structure Policy

The repository must adhere to the following structure. The Compliance Agent will verify this structure during audits.

pleppervr-client-testing/
│
├── docs/
│   └── MODLIST.md              # The complete, up-to-date list of mods.
│
├── scripts/
│   ├── START_SERVER.bat        # Windows script to launch the server.
│   ├── start_server.sh         # Linux script to launch the server.
│   ├── upload_to_github.bat    # Script for backing up client releases.
│   └── update_modpack.bat      # Client-side update script.
│
├── .gitignore                  # Ignores logs, personal configs, etc.
├── modlist.json                # mmm's primary mod configuration file.
├── modlist-lock.json           # mmm's version lock file for consistency.
├── mmm.exe                     # The mod manager executable.
└── claude.md                   # This file (The master policy document).

## 2. Agent Definitions

This project is managed by specialized agents. Each has a specific, non-overlapping role.

*   **Mod Research Agent:** Gathers information about mods (dependencies, IDs, conflicts) *before* modification.
*   **Mod Manager Agent:** Executes `mmm.exe` commands to add, remove, or update mods.
*   **Documentation Agent:** Edits this document (`claude.md`) and `CHANGELOG.md`.
*   **Testing Agent:** Performs automated launch tests (smoke tests) on the client and server.
*   **Git Manager Agent:** Executes all `git` commands and file transfers between environments.
*   **Compliance Agent:** Audits the project against the policies defined in this document.

## 3. Policy: Standard Workflow for Mod Changes

All modifications to the modpack **must** follow this sequence of steps precisely. The Compliance Agent will audit changes against this workflow.

**Step 1: Research (Mod Research Agent)**
*   Before any changes are made, the **Mod Research Agent** must be used to find the target mod's Project ID, all required dependencies, and any known incompatibilities.

**Step 2: Modification (Mod Manager Agent)**
*   The **Mod Manager Agent** must be used to add, remove, or update mods.
*   It must be invoked with the correct `mmm.exe` commands (`add`, `remove`, `update`, `install`).
*   All dependencies identified in Step 1 must be included in this step.

**Step 3: Documentation (Documentation Agent)**
*   Immediately following modification, the **Documentation Agent** must be used to:
    1.  Update the mod list and total mod count in `docs/MODLIST.md`.
    2.  Create or update an entry in `CHANGELOG.md` detailing the changes.

**Step 4: Automated Testing (Testing Agent)**
*   After documentation is complete, the **Testing Agent** must be run to perform a smoke test.
*   The workflow cannot proceed if the automated test reports a `FAIL` status.

**Step 5: Manual Testing (Human Operator)**
*   After automated tests pass, a Human Operator must perform thorough manual testing of in-game functionality (VR, multiplayer, mod features).
*   The operator must provide explicit confirmation that manual testing was completed successfully before the workflow can proceed.

**Step 6: Backup to Testing (Git Manager Agent)**
*   Following successful manual testing, the **Git Manager Agent** must be used to commit and push all changes to the `testing` repositories.

**Step 7: Production Deployment (Git Manager Agent)**
*   Only after a successful push to `testing`, the **Git Manager Agent** may be used to copy all files to the `production` directories and push the final release.

## 4. Policy: Setup Guides

### 4.1. Client Setup (`pleppervr-client-testing`)
1.  **Prerequisites:** Prism Launcher, Git.
2.  **Clone:** `git clone https://github.com/PlepperGuy/pleppervr-client-testing.git`
3.  **Instance Setup:** Create a new Prism Launcher instance named `PlepperVR_Test` for Minecraft 1.20.1 with Forge 47.2.20. Point the "Instance Folder" to the cloned repository directory.
4.  **Install Mods:** Run `./mmm.exe install` from the instance directory.

### 4.2. Server Setup (`pleppervr-server-testing`)
1.  **Prerequisites:** Java 17+, Git.
2.  **Clone:** `git clone https://github.com/PlepperGuy/pleppervr-server-testing.git`
3.  **Copy Mods:** Copy all `.jar` files from the client's `mods` folder to the server's `mods` folder.
4.  **Install Forge:** Run `java -jar forge-1.20.1-47.2.20-installer.jar --installServer` in the server directory.
5.  **Accept EULA:** Change `eula=false` to `eula=true` in `eula.txt`.

## 5. Policy: Mod Management (`mmm.exe`)

The **Mod Manager Agent** must use the following `mmm.exe` commands.

*   `./mmm.exe install`: To install all mods from `modlist.json`.
*   `./mmm.exe add modrinth <id>`: To add a new mod from Modrinth.
*   `./mmm.exe add curseforge <id>`: To add a new mod from CurseForge.
*   `./mmm.exe remove <name>`: To remove a mod.
*   `./mmm.exe update`: To update all mods.