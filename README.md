# Camel

A tool to collect, analyze and display forensic findings from windows machines.
<br/><br/>

Version: 1.0
<br/><br/>


Camel uses tools from the NirSoft and SysInternals suites in addition to powershell and cmd commands
to collect useful data from a Windows machine via live analysis.
After the collection it parses the data from txt or csv formats to html.  
<br/><br/>
Execution:
<br/><br/>
To execute Camel, move the main folder ("Camel") to the computer being investigated and execute the main
script - "camel.bat" from cmd with administrative permissions.
<br/><br/>
The execution takes 3-12 minutes.
<br/><br/>

Camel.bat collects forensic data from a variety of sources and saves the output in txt and csv files.
<br/>
TXTtoHTML.bat and CSVtoHTML.bat located in the "Converters" folder parse the data from txt and
csv formats to html.
<br/>
In the "Tools" folder you will find all the tools used by Camel to collect the forensic data.
<br/><br/><br/><br/>
The output folder:
<br/><br/>
After the execution, a folder with the name "Camel_Findings_<local computer name>" will create
in the main folder (inside the "camel" folder)
<br/><br/>

The folders "TXT", "comma_CSV", "tab_CSV" and "hash_CSV" contain the output of all the commands
from the camel.bat script before it parsed by the converters.
<br/>
The folder "Event_Viewer" contains the event log files collected by Camel and the fulleventLogView
tool (NirSoft) that is used to display them together (the instructions to run this tool will be in the "Event
Viewer" tab in the web interface).
<br/>
The folder "HTML" contains the parsed output. To open the web interface double click the "Home.html" file
(it will also work if you double click any other html file).
<br/><br/>

Screenshots:
<br/><br/><br/>
<img src="https://user-images.githubusercontent.com/79016465/114467366-7dce6000-9bf2-11eb-88a8-fa89f9d3b65c.PNG" width="450" height="200">
<img src="https://user-images.githubusercontent.com/79016465/114399978-2d331480-9baa-11eb-8620-eabb2e5d9300.PNG" width="450" height="200">
<img src="https://user-images.githubusercontent.com/79016465/114400082-48058900-9baa-11eb-9149-9fa20d02f67c.PNG" width="450" height="200">
<img src="https://user-images.githubusercontent.com/79016465/114471764-d35a3b00-9bf9-11eb-8cb8-e6cd0ac6359d.PNG" width="450" height="200">
<img src="https://user-images.githubusercontent.com/79016465/114400098-4b007980-9baa-11eb-9dca-b586dddf7fe0.PNG" width="450" height="200">
<img src="https://user-images.githubusercontent.com/79016465/114400116-4f2c9700-9baa-11eb-8ede-17d23bc754d2.PNG" width="450" height="200">
<br/><br/>

Every tab in the web interface contains parsed output from one of the commands in the Camel.bat script.
<br/><br/>
The tool has been tested on Windows 10 only, however, it supposed to work well on Windows 7 and above.
<br/>
