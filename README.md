# Minecraft-World-Sync
A simple Windows Batch manager for running two Minecraft servers (Main + Test). When the main server is stopped, this script automatically syncs its world to the test server and restarts both.

Features:

-Two-Server System: Runs a main "live" server and a secondary "test" server simultaneously.

-Automatic Sync: Automatically detects when the main server is stopped (using `stop` in the console or `/stop` in-game).

-World Copy: Securely stops the test server, deletes its old world, and copies the new world from the main server.

-Auto-Restart: Restarts both servers automatically after the sync is complete.

-External Config: All settings (paths, passwords, RAM) are managed in a simple `server_manager_config.txt` file. No need to edit the script.
.

.

.

.

.

Guide: 

This system uses a manager script (start_manager.bat) to run two servers. When you stop the Main Server (Server 1), the manager automatically copies its world to the Test Server (Server 2) and restarts both.

=== 1. Prerequisites ===

* Two separate Minecraft server folders (e.g., Server1 and Server2).
* mcrcon.exe (must be placed inside the Server1 folder).
* Java installed on the PC.

=== 2. Step 1: Enable RCON (for Server 2 ONLY) ===

For this system, only Server 2 needs RCON enabled so the manager can stop it.

1.  Open the server.properties file in your Server2 folder.
2.  Find (or create) these lines and set them:
    enable-rcon=true
    rcon.port=25576
    rcon.password=YourSecurePassword
3.  Save the file. (Server 1 does *not* need RCON for this script).

=== 3. Step 2: Set up the Project Folder ===

This guide assumes you are placing all management scripts inside your Server1 folder.

Your final structure must look like this:

    |\My_Server_Project\  
    
    |--- Server1\  <-- (Main Server)
    |      |
    |      |--- server_manager_config.txt  <-- CONFIG
    |      |--- start_manager.bat          <-- SCRIPT
    |      |--- mcrcon.exe                 <-- TOOL
    |      |
    |      |--- server.jar
    |      |--- server.properties
    |      \--- \world\
    |
    \--- Server2\  <-- (Test Server)
           |--- server.jar
           |--- server.properties
           \--- \world\

=== 4. Step 3: Configure server_manager_config.txt ===

This is the most important step. Open server_manager_config.txt (inside Server1) and fill in your details.

This file MUST use full, absolute paths.

Pro-Tip: To get the full path of a folder, Shift + Right-click the folder and select "Copy as path". Then, remove the quotation marks.

* MAIN_SERVER_DIR=
    Enter the full path to your Server1 folder.
    Example: MAIN_SERVER_DIR=C:\Users\YourName\Desktop\My_Server_Project\Server1

* TEST_SERVER_DIR=
    Enter the full path to your Server2 folder.
    Example: TEST_SERVER_DIR=C:\Users\YourName\Desktop\My_Server_Project\Server2

* RCON_PASS= and TEST_RCON_PORT=
    Enter the password and port you set in Step 1 for Server2.

* JAVA_ARGS=
    Adjust your RAM here (e.g., -Xmx10G -Xms1G...).

=== 5. Step 4: How to Use ===

1.  Go into your Server1 folder.
2.  Run start_manager.bat (by double-clicking it).
3.  The script will first start Server 2 (minimized in your taskbar) and then start Server 1 (in the main window).
4.  Play on Server 1 as long as you want.
5.  To trigger the sync: type "/stop".
6.  The start_manager.bat script will detect this. It will automatically stop Server 2 (via RCON), delete the old world, copy the new world from Server 1, and then restart both servers, beginning the loop again.
