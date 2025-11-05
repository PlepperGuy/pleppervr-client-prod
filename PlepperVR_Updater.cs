using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PlepperVR_Updater
{
    public class UpdaterConfig
    {
        public string RepoOwner { get; set; } = "PlepperGuy";
        public string RepoName { get; set; } = "pleppervr-client-production";
        public string InstanceName { get; set; } = "PlepperVR_Test";
        public string PrismLauncherPath { get; set; } = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Programs", "PrismLauncher", "prismlauncher.exe");
        public string PrismDataDir { get; set; } = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "PrismLauncher");
        public bool EnableBackup { get; set; } = true;
        public bool LaunchAfterUpdate { get; set; } = true;
        public bool SkipUpdateIfCurrent { get; set; } = false;
        public string[] BackupItems { get; set; } = new[] { "options.txt", "config", "saves", "resourcepacks", "shaderpacks", "screenshots", "instance.cfg" };
    }

    public class GitHubRelease
    {
        public GitHubAsset[] assets { get; set; }
    }

    public class GitHubAsset
    {
        public string name { get; set; }
        public string browser_download_url { get; set; }
    }

    public class Program
    {
        private static UpdaterConfig config = new UpdaterConfig();
        private static string tempDir = Path.Combine(Path.GetTempPath(), "PlepperVR_Update");
        private static string logFile = Path.Combine(tempDir, "update_log.txt");

        [STAThread]
        static void Main(string[] args)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            try
            {
                // Load external config if exists
                LoadExternalConfig();

                // Initialize logging
                Directory.CreateDirectory(tempDir);
                WriteLog("PlepperVR Updater Started");
                WriteLog("========================================");

                // Show console window
                AllocConsole();

                // Run the update process
                RunUpdateProcess();

                WriteLog("Press any key to exit...");
                Console.ReadKey();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Fatal error: {ex.Message}", "PlepperVR Updater", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                Cleanup();
            }
        }

        [System.Runtime.InteropServices.DllImport("kernel32.dll")]
        private static extern bool AllocConsole();

        private static void LoadExternalConfig()
        {
            string configPath = Path.Combine(Application.StartupPath, "updater_config.json");
            if (File.Exists(configPath))
            {
                try
                {
                    string json = File.ReadAllText(configPath);
                    var externalConfig = JsonSerializer.Deserialize<UpdaterConfig>(json);
                    if (externalConfig != null)
                    {
                        config = externalConfig;
                        WriteLog("Loaded external configuration");
                    }
                }
                catch (Exception ex)
                {
                    WriteLog($"Failed to load external config: {ex.Message}");
                }
            }
        }

        private static void WriteLog(string message, string level = "INFO")
        {
            string timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            string logMessage = $"[{timestamp}] [{level}] {message}";

            // Set console color based on level
            switch (level)
            {
                case "ERROR":
                    Console.ForegroundColor = ConsoleColor.Red;
                    break;
                case "WARNING":
                    Console.ForegroundColor = ConsoleColor.Yellow;
                    break;
                case "SUCCESS":
                    Console.ForegroundColor = ConsoleColor.Green;
                    break;
                default:
                    Console.ForegroundColor = ConsoleColor.White;
                    break;
            }

            Console.WriteLine(message);
            Console.ResetColor();

            // Write to log file
            try
            {
                File.AppendAllText(logFile, logMessage + Environment.NewLine);
            }
            catch
            {
                // Ignore log file errors
            }
        }

        private static void RunUpdateProcess()
        {
            WriteLog("========================================");
            WriteLog("PlepperVR Auto-Updater and Launcher");
            WriteLog("========================================");
            WriteLog($"Repository: {config.RepoOwner}/{config.RepoName}");
            WriteLog($"Instance: {config.InstanceName}");
            WriteLog("");

            // Check if Prism Launcher exists
            if (!File.Exists(config.PrismLauncherPath))
            {
                WriteLog($"ERROR: Prism Launcher not found at: {config.PrismLauncherPath}", "ERROR");
                WriteLog("Please check the PrismLauncherPath in configuration", "ERROR");
                return;
            }

            WriteLog($"Prism Launcher found: {config.PrismLauncherPath}", "SUCCESS");

            // Clean up and create temp directory
            if (Directory.Exists(tempDir))
            {
                Directory.Delete(tempDir, true);
            }
            Directory.CreateDirectory(tempDir);

            // Check current instance
            string instanceDir = Path.Combine(config.PrismDataDir, "instances", config.InstanceName);
            bool instanceExists = Directory.Exists(instanceDir);

            if (instanceExists)
            {
                WriteLog($"Current instance found: {config.InstanceName}");
            }
            else
            {
                WriteLog("No existing instance found, will create new one", "WARNING");
            }

            // Get latest release information
            WriteLog("[1/5] Fetching latest release information...");
            string downloadUrl;
            string mrpackName;

            try
            {
                string apiUrl = $"https://api.github.com/repos/{config.RepoOwner}/{config.RepoName}/releases/latest";

                using (var client = new WebClient())
                {
                    client.Headers.Add("User-Agent", "PlepperVR-Updater");
                    string json = client.DownloadString(apiUrl);
                    var release = JsonSerializer.Deserialize<GitHubRelease>(json);

                    var mrpackAsset = Array.Find(release.assets, asset => asset.name.EndsWith(".mrpack"));
                    if (mrpackAsset == null)
                    {
                        WriteLog("ERROR: No mrpack file found in latest release", "ERROR");
                        return;
                    }

                    downloadUrl = mrpackAsset.browser_download_url;
                    mrpackName = mrpackAsset.name;
                }

                WriteLog($"Found mrpack: {mrpackName}", "SUCCESS");
            }
            catch (Exception ex)
            {
                WriteLog($"ERROR: Failed to fetch release information: {ex.Message}", "ERROR");
                return;
            }

            // Download the mrpack file
            WriteLog("[2/5] Downloading mrpack file...");
            string mrpackPath = Path.Combine(tempDir, "latest.mrpack");

            try
            {
                using (var client = new WebClient())
                {
                    client.DownloadProgressChanged += (sender, e) =>
                    {
                        int percent = (int)((long)e.BytesReceived * 100 / e.TotalBytesToReceive);
                        Console.Write($"\rDownloading: {percent}% complete");
                    };

                    client.DownloadFileAsync(new Uri(downloadUrl), mrpackPath);

                    while (client.IsBusy)
                    {
                        System.Threading.Thread.Sleep(100);
                    }
                }

                Console.WriteLine(); // New line after progress
                WriteLog("Downloaded successfully", "SUCCESS");
            }
            catch (Exception ex)
            {
                WriteLog($"ERROR: Failed to download mrpack file: {ex.Message}", "ERROR");
                return;
            }

            // Backup user configurations
            string backupDir = Path.Combine(tempDir, "config_backup");
            if (config.EnableBackup && instanceExists)
            {
                WriteLog("[3/5] Backing up user configurations...");
                Directory.CreateDirectory(backupDir);

                foreach (string item in config.BackupItems)
                {
                    string sourcePath = Path.Combine(instanceDir, "minecraft", item);
                    BackupItem(sourcePath, backupDir, item);
                }

                WriteLog("Configuration backup completed", "SUCCESS");
            }
            else if (!instanceExists)
            {
                WriteLog("Instance directory not found, will create new instance", "WARNING");
            }

            // Import the mrpack file
            WriteLog("[4/5] Importing mrpack file to Prism Launcher...");

            try
            {
                var process = Process.Start(new ProcessStartInfo
                {
                    FileName = config.PrismLauncherPath,
                    Arguments = $"-d \"{config.PrismDataDir}\" -I \"{mrpackPath}\"",
                    UseShellExecute = false,
                    CreateNoWindow = false
                });

                process.WaitForExit();

                if (process.ExitCode == 0)
                {
                    WriteLog("Mrpack imported successfully", "SUCCESS");
                }
                else
                {
                    WriteLog($"WARNING: Import process may have failed (exit code: {process.ExitCode})", "WARNING");
                }
            }
            catch (Exception ex)
            {
                WriteLog($"ERROR: Failed to import mrpack file: {ex.Message}", "ERROR");
                return;
            }

            // Restore user configurations
            if (config.EnableBackup && Directory.Exists(backupDir))
            {
                WriteLog("[5/5] Restoring user configurations...");

                foreach (string item in config.BackupItems)
                {
                    string destPath = Path.Combine(instanceDir, "minecraft", item);
                    RestoreItem(backupDir, destPath, item);
                }

                WriteLog("User configurations restored", "SUCCESS");
            }

            // Launch the game
            if (config.LaunchAfterUpdate)
            {
                WriteLog("");
                WriteLog("========================================");
                WriteLog("Launching PlepperVR...");
                WriteLog("========================================");
                WriteLog("");
                WriteLog($"Starting Prism Launcher with instance: {config.InstanceName}");
                WriteLog("");

                try
                {
                    Process.Start(new ProcessStartInfo
                    {
                        FileName = config.PrismLauncherPath,
                        Arguments = $"-d \"{config.PrismDataDir}\" -l \"{config.InstanceName}\"",
                        UseShellExecute = false
                    });

                    WriteLog("Game launched successfully!", "SUCCESS");
                }
                catch (Exception ex)
                {
                    WriteLog($"WARNING: Failed to launch game automatically: {ex.Message}", "WARNING");
                    WriteLog("Please launch the game manually from Prism Launcher", "WARNING");
                }
            }
            else
            {
                WriteLog("Update completed. Auto-launch is disabled.");
            }

            WriteLog("");
            WriteLog("Update process completed!", "SUCCESS");
        }

        private static void BackupItem(string source, string backupDir, string itemName)
        {
            try
            {
                if (Directory.Exists(source))
                {
                    string dest = Path.Combine(backupDir, itemName);
                    CopyDirectory(source, dest);
                    WriteLog($"  - Backed up {itemName}");
                }
                else if (File.Exists(source))
                {
                    string dest = Path.Combine(backupDir, itemName);
                    File.Copy(source, dest, true);
                    WriteLog($"  - Backed up {itemName}");
                }
            }
            catch (Exception ex)
            {
                WriteLog($"  - Failed to backup {itemName}: {ex.Message}", "WARNING");
            }
        }

        private static void RestoreItem(string backupDir, string destination, string itemName)
        {
            try
            {
                string source = Path.Combine(backupDir, itemName);

                if (Directory.Exists(source))
                {
                    CopyDirectory(source, destination);
                    WriteLog($"  - Restored {itemName}");
                }
                else if (File.Exists(source))
                {
                    Directory.CreateDirectory(Path.GetDirectoryName(destination));
                    File.Copy(source, destination, true);
                    WriteLog($"  - Restored {itemName}");
                }
            }
            catch (Exception ex)
            {
                WriteLog($"  - Failed to restore {itemName}: {ex.Message}", "WARNING");
            }
        }

        private static void CopyDirectory(string source, string destination)
        {
            if (!Directory.Exists(destination))
            {
                Directory.CreateDirectory(destination);
            }

            // Copy files
            foreach (string file in Directory.GetFiles(source))
            {
                string destFile = Path.Combine(destination, Path.GetFileName(file));
                File.Copy(file, destFile, true);
            }

            // Copy subdirectories
            foreach (string dir in Directory.GetDirectories(source))
            {
                string destDir = Path.Combine(destination, Path.GetFileName(dir));
                CopyDirectory(dir, destDir);
            }
        }

        private static void Cleanup()
        {
            try
            {
                if (Directory.Exists(tempDir))
                {
                    Directory.Delete(tempDir, true);
                }
            }
            catch (Exception ex)
            {
                WriteLog($"Failed to clean up temporary files: {ex.Message}", "WARNING");
            }
        }
    }
}