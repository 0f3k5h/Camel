@echo off

REM saving the Execution start time
set startTime=%time%

REM Check Administrative Permissions
net session >nul 2>&1
    if %errorLevel% == 0 (goto :banner)

REM Display no administrative permissions error
:NoAdmin
echo.
echo Please launch Camel.exe with administrative permissions.
goto :eof

REM starts to run
:banner
echo                                                                            ,,__
echo                                                                  __  __   / o._)  
echo     ______     ______     __    __     ______     __            /--\/--\  \  /
echo    /\  ___\   /\  __ \   /\ "-./  \   /\  ___\   /\ \          /        \_/ /   
echo    \ \ \____  \ \  __ \  \ \ \-./\ \  \ \  __\   \ \ \____   .'\  \__\  __ /     
echo     \ \_____\  \ \_\ \_\  \ \_\ \ \_\  \ \_____\  \ \_____\    )\ ^|  )\ ^|      
echo      \/_____/   \/_/\/_/   \/_/  \/_/   \/_____/   \/_____/   // \\ // \\
echo                                                              ^|^|_  \\^|_  \\_
echo                                                              '--' '--'' '--' 
echo    auther: 0f3k5h    version: 1.0    march 2021
echo.
echo.
echo.

Title Camel -  Windows host IR Tool

REM Defines variables for working folder and output folder
set working_folder=%~dp0
set output_folder=%~dp0\Camel_Findings_%computername%


REM Creates the output folder
if not exist %output_folder% (mkdir %output_folder%)
if not exist %output_folder%\TXT (mkdir %output_folder%\TXT)
if not exist %output_folder%\Comma_CSV (mkdir %output_folder%\Comma_CSV)
if not exist %output_folder%\Tab_CSV (mkdir %output_folder%\Tab_CSV)
if not exist %output_folder%\Hash_CSV (mkdir %output_folder%\hash_CSV)
if not exist %output_folder%\HTML (mkdir %output_folder%\HTML)
if not exist %output_folder%\Event_Viewer (mkdir %output_folder%\Event_Viewer)
if not exist %output_folder%\Event_Viewer\FullEventLogView (mkdir %output_folder%\Event_Viewer\FullEventLogView)

REM Accepting eula for all sysinternals tools
reg.exe ADD HKCU\Software\Sysinternals /v EulaAccepted /t REG_DWORD /d 1 /f >nul
reg.exe ADD HKCU\Software\Sysinternals\Autoruns /v EulaAccepted /t REG_DWORD /d 1 /f >nul
reg.exe ADD HKCU\Software\Sysinternals\listdlls /v EulaAccepted /t REG_DWORD /d 1 /f >nul
reg.exe ADD HKU\.DEFAULT\Software\Sysinternals /v EulaAccepted /t REG_DWORD /d 1 /f >nul

REM Starts to collects evidence
echo collecting ARP Cache...
arp -a > "%output_folder%\txt\Arp_Cache.txt"
echo.

echo collecting Autoruns...
"%working_folder%\Tools\autorunsc\autorunsc.exe" -a * -nobanner -ct -o "%output_folder%\tab_csv\Autorunsc.csv"
"%working_folder%\Tools\autorunsc\autorunsc.exe" -a * -m -nobanner -ct -o "%output_folder%\tab_csv\Autorunsc_Without_Windows_Entries.csv"
echo.


echo Collecting Important Folders content...
chcp 437 > nul
powershell "Get-ChildItem -Path %systemroot% | select attributes, fullname, creationtime, lastwritetime, lastaccesstime, length | sort creationtime -descending | Export-Csv -path "%output_folder%\hash_csv\Windows_Folder.csv" -NoTypeInformation -Delimiter '#' -Append" 2>nul
powershell "Get-ChildItem -Path %systemroot%\system32 | select attributes, fullname, creationtime, lastwritetime, lastaccesstime, length | sort creationtime -descending | Export-Csv -path "%output_folder%\hash_csv\System32_Folder.csv" -NoTypeInformation -Delimiter '#' -Append" 2>nul
powershell "Get-ChildItem -Path %temp% | select attributes, fullname, creationtime, lastwritetime, lastaccesstime, length | sort creationtime -descending | Export-Csv -path "%output_folder%\hash_csv\Temp_Folder.csv" -NoTypeInformation -Delimiter '#' -Append" 2>nul
echo.

echo collecting DNS Cache...
ipconfig /displaydns > "%output_folder%\txt\Dns_Cache.txt"
echo.

echo collecting Environment Variables data...
set > "%output_folder%\txt\Environment_Variables.txt"
echo.

echo collecting Event Log files...
copy "%SystemRoot%\system32\winevt\Logs\application.evtx" "%output_folder%\Event_Viewer" >nul
copy "%SystemRoot%\system32\winevt\Logs\security.evtx" "%output_folder%\Event_Viewer" >nul
copy "%SystemRoot%\system32\winevt\Logs\system.evtx" "%output_folder%\Event_Viewer" >nul
if exist "%SystemRoot%\system32\winevt\Logs\Microsoft-Windows-sysmon*operational.evtx" (copy "%SystemRoot%\system32\winevt\Logs\Microsoft-Windows-sysmon*operational.evtx" "%output_folder%\Event_Viewer" >nul)
copy "%working_folder%\Tools\fulleventlogview" "%output_folder%\Event_Viewer\FullEventLogView" >nul
echo.


echo collecting Host file...
type "%SystemRoot%\system32\drivers\etc\hosts" > "%output_folder%\txt\Hosts.txt"
echo.

echo collecting Last Activity...
"%working_folder%\Tools\lastactivityview\LastActivityView.exe" /stab "%output_folder%\tab_csv\Last_Activity.csv"
echo.

echo collecting Loaded dlls...
"%working_folder%\Tools\listdlls\listdlls.exe" -nobanner > %output_folder%\txt\Loaded_Dlls.txt
echo.

echo collecting Network Shares data...
net share > "%output_folder%\txt\Network_Shares.txt"
echo.

echo collecting Netbios data...
nbtstat -s > "%output_folder%\txt\Netbios.txt"
nbtstat -c >> "%output_folder%\txt\Netbios.txt"
echo.

echo collecting Port Proxy data...
netsh interface portproxy show all > "%output_folder%\txt\Port_Forwarding.txt"
echo.

echo collecting Process List data...
powershell "Get-CimInstance Win32_Process | select ProcessId, ProcessName, Path, CommandLine, Description, ParentProcessId , CreationDate, Handle, HandleCount, @{Label='File Path MD-5'; Expression={(Get-FileHash -Algorithm MD5 -LiteralPath $_.Path).Hash}} | Sort-Object ProcessID | Export-Csv -NoTypeInformation -Path '%output_folder%\hash_csv\Processes.csv' -Delimiter '#'"
echo.


echo collecting Services information...
powershell "Get-WmiObject win32_service | select name, displayname, state, startmode, pathname, description | sort state, name | Export-Csv -NoTypeInformation -path "%output_folder%\hash_csv\Services.csv" -Delimiter '#'
echo.

echo collecting Shellbags data...
"%working_folder%\Tools\ShellBagsView\ShellBagsView.exe" /stab "%output_folder%\Tab_csv\Shellbags.csv"
echo.

powershell "@('Path	Slot Number	Last Modified Time	Mode	Icon Size	Windows Position	Windows Size	Type	Slot Key	Slot Modified Time	User Name') + (Get-Content "%output_folder%\tab_csv\Shellbags.csv") | Set-Content "%output_folder%\tab_csv\Shellbags.csv""

echo collecting Schedule tasks information...
"%working_folder%\Tools\TaskSchedulerView\TaskSchedulerView.exe" /sort~4 /stab "%output_folder%\tab_csv\Scheduletasks.csv"
echo.

echo collecting TCP connections data...
netstat -bao > "%output_folder%\txt\Network_Connections.txt"
echo.

echo collecting the current Time...
date /t > "%output_folder%\txt\Time.txt"
time /t >> "%output_folder%\txt\Time.txt"
echo.

echo collecting USB Devices history...
"%working_folder%\Tools\usbdeview\USBDeview.exe" /sort~2 /stab "%output_folder%\tab_csv\USB_Connections.csv"
echo.

powershell "@('Device Name	Description	Device Type	Connected	Safe To Unplug	Disabled	USB Hub	Drive Letter	Serial Number	Registry Time 1	Registry Time 2	VendorID	ProductID	Firmware Revision	USB Class	USB SubClass	USB Protocol	Hub / Port	Computer Name	Vendor Name	Product Name	ParentId Prefix	Service Name	Service Description	Driver Filename	Device Class	Device Mfg	Friendly Name	Power	USB Version	Driver Description	Driver Version	Driver InfSection	Driver InfPath	Instance ID	Capabilities	Install Time	First Install Time	Connect Time	Disconnect Time')+ (Get-Content "%output_folder%\tab_csv\USB_Connections.csv") | Set-Content "%output_folder%\tab_csv\USB_Connections.csv""

echo collecting UserAssist data...
"%working_folder%\Tools\UserAssistView\UserAssistView.exe" /sort~~3 /scomma "%output_folder%\comma_csv\UserAssist.csv"
echo.

powershell "@('Item Name,Index,Count,Modified Time,ClassID') + (Get-Content "%output_folder%\comma_csv\UserAssist.csv") | Set-Content "%output_folder%\comma_csv\UserAssist.csv""

echo collecting Logon history data...
"%working_folder%\Tools\winlogonview\WinLogOnView.exe" /sort~5 /scomma "%output_folder%\comma_csv\Logons.csv"
echo.

REM Copy necessary files to the html folder
copy "%working_folder%\ToHTML\*" "%output_folder%\HTML" >nul

REM Converts all the comma delimited csv files to html
for %%f in ( "%output_folder%\comma_csv\*" ) do (
	 echo Creating HTML file for %%~nf...
	 echo.
	 call "%working_folder%\Converters\CSVtoHTML.bat" "%%f" "%output_folder%\HTML\%%~nf.htm" comma >nul
)

REM Converts all the tab delimited csv files to html
for %%f in ( "%output_folder%\tab_csv\*" ) do (
	 echo Creating HTML file for %%~nf...
	 echo.
	 call "%working_folder%\Converters\CSVtoHTML.bat" "%%f" "%output_folder%\HTML\%%~nf.htm" tab >nul
)

REM Converts all the hash delimited csv files to html
for %%f in ( "%output_folder%\hash_csv\*" ) do (
	 echo Creating HTML file for %%~nf...
	 echo.
	 call "%working_folder%\Converters\CSVtoHTML.bat" "%%f" "%output_folder%\HTML\%%~nf.htm" hash >nul
)

REM Converts all the txt files to html
for %%f in ( "%output_folder%\txt\*" ) do (
	 echo Creating HTML file for %%~nf...
	 echo.
	 call "%working_folder%\Converters\TXTtoHTML.bat" "%%f" "%output_folder%\HTML\%%~nf.htm" >nul
)

echo.
echo All the output is at %output_folder%

REM Calculating the Execution end time
echo.
echo ---Execution time---
echo Start:    %startTime%
echo End:      %time%
