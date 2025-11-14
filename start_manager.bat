@echo off
SETLOCAL

:: ==========================================================
:: --- SERVER MANAGER (Final Version) ---
:: --- (Make all settings in server_manager_config.txt) ---
:: ==========================================================

:: 1. Set default values
SET "WAIT_TEST_SERVER_START=10"
SET "WAIT_BOTH_SERVERS_STOP=15"
SET "WAIT_BEFORE_RESTART=5"

:: 2. Load all settings from config.txt
echo [MANAGER] Loading configuration from server_manager_config.txt...

:: === FILENAME CHANGED ===
SET "CONFIG_FILE=%~dp0server_manager_config.txt"

:: === FILENAME IN ERROR MESSAGE CHANGED ===
if not exist "%CONFIG_FILE%" (
    echo [ERROR] server_manager_config.txt not found!
    echo Please create the config file in the same folder.
    pause
    exit /b
)

:: Read the config.txt line by line
FOR /F "usebackq eol=# delims== tokens=1,*" %%G IN ("%CONFIG_FILE%") DO (
    SET "%%G=%%H"
)

:: 3. Set mcrcon path based on config
SET "MCRCON_PATH=%MAIN_SERVER_DIR%\mcrcon.exe"

:: 4. Convert wait times for PING command
SET /A "PING_WAIT_START=%WAIT_TEST_SERVER_START% + 1"
SET /A "PING_WAIT_STOP=%WAIT_BOTH_SERVERS_STOP% + 1"
SET /A "PING_WAIT_RESTART=%WAIT_BEFORE_RESTART% + 1"

:: 5. Check if mcrcon.exe exists
if not exist "%MCRCON_PATH%" (
    echo [ERROR] mcrcon.exe not found!
    echo Expected path: %MCRCON_PATH%
    echo Please make sure mcrcon.exe is in the Server 1 folder.
    pause
    exit /b
)

:: 6. Check if paths were loaded
if not defined MAIN_SERVER_DIR (
    echo [ERROR] MAIN_SERVER_DIR not found in server_manager_config.txt!
    pause
    exit /b
)

echo [MANAGER] Configuration loaded successfully. Starting servers...

:: ==========================================================
:: --- STARTING SCRIPT LOGIC ---
:: ==========================================================

:start_both_servers_loop

echo ===================================
echo  [MANAGER] Starting TEST Server (Server 2) MINIMIZED...
echo ===================================
START "Test Server 2" /MIN /D %TEST_SERVER_DIR% "java" %JAVA_ARGS%

echo [MANAGER] Waiting %WAIT_TEST_SERVER_START% seconds...
ping -n %PING_WAIT_START% 127.0.0.1 > nul

echo ===================================
echo  [MANAGER] Starting MAIN Server (Server 1) in this window...
echo ===================================
cd /d %MAIN_SERVER_DIR%
java %JAVA_ARGS%

::
:: IF YOU TYPE 'stop' IN SERVER 1, THE SCRIPT CONTINUES FROM HERE
::

echo [SYNC] MAIN Server was stopped. Starting synchronization...

echo [SYNC 1/4] Stopping TEST Server (Server 2) via RCON...
%MCRCON_PATH% -H 127.0.0.1 -P %TEST_RCON_PORT% -p %RCON_PASS% "stop"

echo [SYNC 2/4] Waiting %WAIT_BOTH_SERVERS_STOP% seconds...
ping -n %PING_WAIT_STOP% 127.0.0.1 > nul

echo [SYNC 3/4] Deleting old world from TEST Server...
echo     Old world deleted.

echo [SYNC 4/4] Copying new world from MAIN Server to TEST Server...
xcopy %MAIN_SERVER_DIR%\world %TEST_SERVER_DIR%\world\ /E /I /H /Y
echo     World copied.

echo [SYNC] Synchronization complete. Restarting both servers...
ping -n %PING_WAIT_RESTART% 127.0.0.1 > nul

goto :start_both_servers_loop
ENDLOCAL