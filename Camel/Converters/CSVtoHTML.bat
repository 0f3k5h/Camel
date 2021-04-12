@echo off
REM Convert csv file to HTML file

REM Defines the delimeter of the csv to convert
if %3==comma (set "delims=,")
if %3==tab (set "delims=	")
if %3==hash (set "delims=#")

Rem overwrite html file if already exist
if exist "%2" del /f /q "%2"

REM Calls the main function with the input [%1] and output [%2] files path
Call :CreateHTMLtable "%1" "%2"
exit /b	

::******************************************************************************************************
:CreateHTMLTable <inputfile> <outputfile>

REM Write the default HTML, CSS and JS commands and the data
REM from the current converted csv file to the output html file
setlocal
(
 echo ^<!DOCTYPE HTML PUBLIC
 echo "-//W3C//DTD HTML 4.01 Transitional//EN"
 echo  "http://www.w3.org/TR/10ce3ac/REC-html401-10ce3ac1224/loose.dtd"^>
 echo ^<HTML^>
 echo ^<HEAD^>
 echo ^<title^>Camel^</title^>
 echo ^<link rel = "icon" href ="favicon.png" type = "image/png" sizes="16x16"^>
 echo ^<script src="menu.js"^>^</script^>
 echo ^<META HTTP-EQUIV="Content-Type"
 echo CONTENT="text/html; charset=utf-8"^>
 echo ^<div class="timeDiv"^>
 echo Time on the investigated machine while parsing this page:
 echo ^<p class="time"^>
 set date = date /t
 set time = time /t
 echo %date%
 echo %time%
 echo ^</p^>
 echo ^</div^>
 echo ^<h1 id="headline"^>%~n1^</h1^>
 echo ^<style type="text/css"^>
 echo h1 {padding-top: 1vh; text-align: center; color:#cccccc; font-size:2.5vw; font-family:Arial;}
 echo .note {text-align: center; color:#ffffff; font-size:1.25vw; font-family: Arial;}
 echo body {background-color:#000000;}
 echo table {overflow-wrap: break-word; word-wrap: break-word; border-radius: 10px; border: solid 3px #133b4a; width: 90vw;marging:0 auto;font-family: Arial;color:#ffffff;}
 echo tr {background-color:#0d1b21;}
 echo tr:first-child {color: #0ce3ac; font-size:2.4vh; height:12vh; font-weight: bold; background-color: #1f627a; background-image: linear-gradient^(to bottom, #1f627a, #030812^);}
 echo tr:nth-child^(even^) {background: #000407}
 echo table tr:first-child td:first-child {border-top-left-radius: 6px;}
 echo table tr:first-child td:last-child {border-top-right-radius: 6px;}
 echo table tr:last-child td:last-child {border-bottom-right-radius: 6px;}
 echo table tr:last-child td:first-child {border-bottom-left-radius: 6px;}
 echo td {padding: 1vw; max-width:8vw;font-size:14px;text-align:center;}
 echo .timeDiv {padding-top: 1vh; font-family: Arial; border-style: solid; border-width: 0.1vw; border-color: #133b4a; padding-left: 0.5vw; font-size: 0.8vw; background-color:#0d1b21; display: inline-block; color: #ffffff; font-family:Arial; position: absolute; width: 21vw}
 echo .time {color: #ffffff; font-size: 0.8vw; text-align: center;}
 echo .footerWrapper {align-items: center; display: flex; justify-content: center; height: 5vh; width: 50vw; padding-top: 12vh;}
 echo .footer {color: #a9a9a9; font-size: 1vw; font-family:Arial;}
 echo .footer-logo {height: 4vh;width: 6.5vw;}
 echo ^</style^>
 echo ^</HEAD^>
 echo ^<body^>
)>%2

if %~n1==Autorunsc ( 
	echo ^<p class="note"^>Note: Rows marked in ^<font color="#2b5a6a"^>cyan^</font^> are entry headlines, Rows marked in ^<font color="#ff3c1a"^>red^</font^> are suspicious because of empty "Description" and "Company" columns.^</p^>
) >>%2

if %~n1==Autorunsc_Without_Windows_Entries ( 
	echo ^<p class="note"^>Note: Rows marked in ^<font color="#2b5a6a"^>cyan^</font^> are entry headlines, Rows marked in ^<font color="#ff3c1a"^>red^</font^> are suspicious because of empty "Description" and "Company" columns.^</p^>
) >>%2

if %~n1==USB_Connections ( 
	echo ^<p class="note"^>Note: Rows marked in ^<font color="#ff3c1a"^>red^</font^> due to "USB Mass Storage" description ^(Disk-on-key^).^</p^>
) >>%2

if %~n1==Services ( 
	echo ^<p class="note"^>Note: Rows marked in ^<font color="#ff3c1a"^>red^</font^> are suspicious because of empty "Description" column.^</p^>
) >>%2 


(
 echo ^<center^>^<table id="csvtable" cellspacing="0" cellpadding="0"^>
 echo ^<tbody^>
)>>%2

for /F "delims=" %%A in ('Type "%~1"') do (
 endlocal
 set "var=%%~A"
 setlocal enabledelayedexpansion
 set "var=!var:&=&amp;!"
 set "var=!var:<=&lt;!"
 set "var=!var:>=&gt;!"
 set "var=!var:"=!"
 set "var=!var:%delims%=</td><td>!"
 echo ^<tr id="tr"^>^<td^>!var!^</td^>^</tr^>
)>>%2

(
 echo ^</table^>^</center^>
 echo ^<script type="text/javascript"^>
 echo document.getElementById^("headline"^).innerHTML = document.getElementById^("headline"^).innerHTML.split^('_'^).join^(' '^);
 echo var rows = document.getElementById^("csvtable"^).rows
)>>%2

if %~n1==Shellbags (
	echo for ^(var i = 1 ; i ^< rows.length; i++ ^)
	echo {
	echo 	rows[i].deleteCell^(-1^)
	echo }
	echo var indexes = [10,6,5,4]
	echo for ^(var j = 0; j^< indexes.length; j++^)
	echo {
	echo 	for ^(var i = 0 ; i ^< rows.length; i++ ^)
	echo 	{
    echo 		try{rows[i].deleteCell^(indexes[j]^)}catch^(e^){}
	echo 	}
	echo }
)>>%2

if %~n1==USB_Connections (
	echo var indexes = [35,34,33,32,31,29,28,27,26,25,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4]
	echo for ^(var j = 0; j^< indexes.length; j++^)
	echo {
	echo 	for ^(var i = 0 ; i ^< rows.length; i++ ^)
	echo 	{
    echo 		try{rows[i].deleteCell^(indexes[j]^)}catch^(e^){}
	echo 	}
	echo }
	echo for ^(var i = 1 ; i ^< rows.length; i++ ^)
	echo {
	echo    rows[i].deleteCell^(-1^)
	echo  	if ^(rows[i].cells[2].innerHTML == "Mass Storage"^)
	echo 	    {
	echo	 		rows[i].style.backgroundColor = "#ff3c1a"
	echo 	    }
	echo }
)>>%2

if %~n1==Services (
	echo for ^(var i = 1 ; i ^< rows.length; i++ ^)
	echo {
	echo	if ^(rows[i].cells[5].innerHTML.length == 0^) 
	echo   		{
	echo	 		rows[i].style.backgroundColor = "#ff3c1a"
	echo		}
	echo }
)>>%2

if %~n1==last_activity (
	echo for ^(var i = 0 ; i ^< rows.length; i++ ^)
	echo {
	echo 	rows[i].deleteCell^(-1^)
	echo }
)>>%2

if %~n1==Scheduletasks (
	echo var indexes = [33,32,31,30,27,26,25,24,22,19,18,17,16,15,14,13,12,11,10,9,8,6,3]
	echo for ^(var j = 0; j^< indexes.length; j++^)
	echo {
	echo 	for ^(var i = 0 ; i ^< rows.length; i++ ^)
	echo 	{
    echo 		try{rows[i].deleteCell^(indexes[j]^)}catch^(e^){}
	echo 	}
	echo }
)>>%2

if %~n1==Processes (
	echo var camelEntry = "'"
	echo for ^(var i = 0 ; i ^< rows.length; i++ ^)
	echo {
	echo  	if ^(rows[i].cells[4].innerHTML == camelEntry^)
	echo 	{
	echo 		document.getElementById^("csvtable"^).deleteRow^(i^);
	echo 	}
	echo }
)>>%2

if %~n1==Autorunsc (
	echo for ^(var i = 1 ; i ^< rows.length; i++ ^)
	echo {
	echo  	if ^(rows[i].cells[2].innerHTML.length == 0^)
	echo 	{
	echo	 	rows[i].style.backgroundColor = "#2b5a6a"
	echo 		rows[i].style.fontWeight = 'bold'
	echo 		rows[i].style.height = "12vh"
	echo 		rows[i].style.color = "#0ce3ac"
	echo	} else if ^(rows[i].cells[7].innerHTML.length == 0 ^&^& rows[i].cells[6].innerHTML.length == 0^) {
	echo	 		rows[i].style.backgroundColor = "#ff3c1a"
	echo	}
	echo  	if ^(rows[i].cells[11]^)
	echo 	{
	echo	 	rows[i].deleteCell^(11^)
	echo 	}
	echo }
)>>%2

if %~n1==Autorunsc_Without_Windows_Entries (
	echo for ^(var i = 1 ; i ^< rows.length; i++ ^)
	echo {
	echo  	if ^(rows[i].cells[2].innerHTML.length == 0^)
	echo 	{
	echo	 	rows[i].style.backgroundColor = "#2b5a6a"
	echo 		rows[i].style.fontWeight = 'bold'
	echo 		rows[i].style.height = "12vh"
	echo 		rows[i].style.color = "#0ce3ac"
	echo	} else if ^(rows[i].cells[7].innerHTML.length == 0 ^&^& rows[i].cells[6].innerHTML.length == 0^) {
	echo	 		rows[i].style.backgroundColor = "#ff3c1a"
	echo	}
	echo  	if ^(rows[i].cells[11]^)
	echo 	{
	echo	 	rows[i].deleteCell^(11^)
	echo 	}
	echo }
)>>%2

(
 echo ^</script^>
 echo ^<center^>^<div class="footerWrapper"^>^<img class="footer-logo" src="footer-logo.png" alt="footer-logo"^>^<div class="footer"^>^&copy2021 Written by 0f3k5h^</div^>^</div^>
 echo ^</body^>
 echo ^</HTML^>
)>>%2

endlocal
::******************************************************************************************************