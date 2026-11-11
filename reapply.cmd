@echo off
rem Apply the Korean language pack to the installed dsh-TUI package.
rem Usage: reapply.cmd [--pkg <dsh-tui package dir>] [--profile <name>]
setlocal

set "NODE=node"
where node >nul 2>nul
if errorlevel 1 set "NODE="

if not defined NODE (
  for %%P in (
    "%LOCALAPPDATA%\Programs\DeepSeek Harness\resources\runtime\primary-runtime\dependencies\node\bin\node.exe"
    "%USERPROFILE%\.dsh\dsh-runtimes\dsh-primary-runtime\dependencies\node\bin\node.exe"
  ) do (
    if exist %%P set "NODE=%%~P"
  )
)

if not defined NODE (
  echo Node.js not found. Install Node.js 18+ from https://nodejs.org
  echo or run: node apply.mjs --pkg ^<path to @deepseek-harness-tui/dsh-tui^>
  exit /b 1
)

"%NODE%" "%~dp0apply.mjs" %*
exit /b %errorlevel%
