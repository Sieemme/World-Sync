# Minecraft-World-Sync
A simple Windows Batch manager for running two Minecraft servers (Main + Test). When the main server is stopped, this script automatically syncs its world to the test server and restarts both.

Features:

-Two-Server System: Runs a main "live" server and a secondary "test" server simultaneously.

-Automatic Sync: Automatically detects when the main server is stopped (using `stop` in the console or "/stop" in-game).

-World Copy: Securely stops the test server, deletes its old world, and copies the new world from the main server.

-Auto-Restart: Restarts both servers automatically after the sync is complete.

-External Config: All settings (paths, passwords, RAM) are managed in a simple `server_manager_config.txt` file. No need to edit the script.

