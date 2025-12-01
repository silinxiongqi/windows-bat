::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDpQQQ2MNXiuFLQI5/rHy+WQrEESVeYsRAcFMzxuwGfAMcI/ihDyNvyOQ/eL38Dfpe0tse+yfbUMs3yAVw==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
:: ============================================
:: DGFC168 
:: 版本: 3.0 |自动跳过无错误步骤
:: ============================================

title Microsoft Activation Scripts 自动激活
color 0A
echo.
echo ============================================
echo    Microsoft Activation Scripts Windows激活工具
echo ============================================
echo.

:: 1. 检查管理员权限
echo [1/3] 正在检查管理员权限...
fsutil dirty query %systemdrive% >nul 2>&1
if %errorLevel% neq 0 (
    echo [×] 需要管理员权限，正在请求提升...
    goto UACPrompt
)
echo [√] 已具备管理员权限
echo.

:: 2. 检查 PowerShell 是否可用
echo [2/3] 检查 PowerShell 环境...
where powershell >nul 2>&1
if %errorLevel% neq 0 (
    echo [×] 错误：未找到 PowerShell，请确保系统已安装！
    pause
    exit /b 1
)
echo [√] PowerShell 可用
echo.

:: 3. 执行激活脚本（仅报错一次）
echo [3/3] 正在激活 Windows/Office...
echo （弹出窗口按数字1为激活Windows，其他按钮按需输入）
echo.

:: 执行核心激活命令，错误只显示一次
powershell -NoProfile -Command ^
    "$ErrorActionPreference = 'Stop';" ^
    "try {" ^
    "    $ProgressPreference = 'SilentlyContinue';" ^
    "    Invoke-RestMethod -Uri 'https://get.activated.win' | Invoke-Expression;" ^
    "    echo [√] 激活成功！;" ^
    "} catch {" ^
    "    echo [×] 激活失败：$($_.Exception.Message);" ^
    "    exit 1;" ^
    "}"

:: 4. 自动退出（无错误时不暂停）
if %errorLevel% equ 0 (
    timeout /t 3 >nul
    exit /b 0
) else (
    pause
    exit /b 1
)

:: ========== 子程序 ==========
:UACPrompt
echo 正在请求管理员权限...
set "batchPath=%~0"
set "batchArgs=%*"

:: 避免重复提权
if "%1"==":admin" (
    shift /1
    goto :admin
)

:: 使用 PowerShell 提权
powershell -Command ^
    "Start-Process cmd -ArgumentList '/c """"%batchPath%"" :admin %batchArgs%""' -Verb RunAs"
exit /b

:admin
cd /d "%~dp0"
:: 重新运行脚本
goto :EOF