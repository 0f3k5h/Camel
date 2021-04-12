@echo off
REM Convert txt file to HTML file

Rem overwrite html file if already exist
if exist "%2" del /f /q "%2"

REM Calls the main function with the input [%1] and output [%2] files path
Call :CreateHTMLFile "%1" "%2"
exit /b

::******************************************************************************************************
:CreateHTMLFile <inputfile> <outputfile>

REM Write the default HTML, CSS and JS commands and the data
REM from the current converted txt file to the output html file
setlocal
(
 echo ^<!DOCTYPE HTML PUBLIC
 echo "-//W3C//DTD HTML 4.01 Transitional//EN"
 echo  "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd"^>
 echo ^<HTML^>
 echo ^<HEAD^>
 echo ^<title^>Camel^</title^>
 echo ^<link rel = "icon" href ="favicon.png" type = "image/png" sizes="16x16"^>
 echo ^<script src="menu.js"^>^</script^>
 echo ^<META HTTP-EQUIV="Content-Type"
 echo CONTENT="text/html; charset=utf-8"^>
 echo ^<h1 id="headline"^>%~n1^</h1^> 
 echo ^<style type="text/css"^>
 echo h1 {text-align: center; color:#cccccc; font-size:2.5vw; font-family:Arial;}
 echo body {background-color:#000000;}
 echo .outDiv {margin: auto; overflow-wrap: break-word; word-wrap: break-word; hyphens: auto; padding-right: 7vw; txt_File: auto; background-color: #00080b; color: #ffffff; border-style: solid; border-width: 0.2vw; border-color: #133b4a; font-family: Arial; font-size:20px; overflow-y: auto; width: 90vw; height: 77vh; text-align: left;}
 echo .output {padding-left: 8vw; white-space: pre-wrap; max-width: 90vw;}
 echo .outDiv::-webkit-scrollbar {width: 1vw;}
 echo .outDiv::-webkit-scrollbar-track {background: #133b4a;}
 echo .outDiv::-webkit-scrollbar-thumb {background: #0d1b21; }
 echo .outDiv::-webkit-scrollbar-thumb:hover {background: #101010;}
 echo .footerWrapper {align-items: center; display: flex; justify-content: center; height: 5vh; width: 50vw; padding-top: 3vh;}
 echo .footer {color: #a9a9a9; font-size: 1vw; font-family:Arial;}
 echo .footer-logo {height: 4vh;width: 6.5vw;}
 echo ^</style^>
 echo ^</HEAD^>
 echo ^<BODY^>
 echo ^<div class="outDiv"^>
 echo ^<p class="output"^>
)>%2

setlocal enabledelayedexpansion
SET "br=^<br^>"
SET "hr=^<hr^>"
SET "h1=^<h1^>"
SET "sh1=^</h1^>"
SET "bold=^<b^>"
SET "sbold=^</b^>"


(
FOR /f "delims=" %%i IN ('type "%~1"^|findstr /n "$"') DO (
SET line=%%i&CALL :process
)
)2>&1 >>%2

(
 echo ^</p^>
 echo ^</div^>
 echo ^<script type="text/javascript"^>
 echo document.getElementById^("headline"^).innerHTML = document.getElementById^("headline"^).innerHTML.split^('_'^).join^(' '^); 
 echo ^</script^>
 echo ^<center^>^<div class="footerWrapper"^>^<img class="footer-logo" src="footer-logo.png" alt="logo"^>^<div class="footer"^>^&copy2021 Written by 0f3k5h^</div^>^</div^>
 echo ^</BODY^>
 echo ^</HTML^>
)>>%2

:process
REM remove line number from line
SET "line=%line:*:=%"
IF NOT DEFINED line ECHO(%br%&GOTO :EOF
SET "line2=%line:"=_%"
SET "line3=%line:"=%"
IF NOT "%line2%"=="%line3%" GOTO rawout
IF "%line%"=="==="  ECHO(%hr%&GOTO :EOF
IF "%line:~0,5%"=="Date:"  ECHO(%bold%%line%%sbold%&GOTO :EOF
IF "%line:~0,2%%line:~-2%"=="****" ECHO(%h1%%line:~2,-2%%sh1%&GOTO :EOF
:rawout
ECHO(!line!%br%
GOTO :eof
endlocal
::******************************************************************************************************