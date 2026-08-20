@echo off
chcp 65001 >nul
title C盘一键安全清理工具

:: 自动获取管理员权限
fltmc >nul 2>&1 || (
    echo 正在请求管理员权限...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cls
echo ======================================
echo          C盘一键安全清理工具
echo ======================================
echo 本次清理包含以下安全项：
echo   1. 当前用户临时文件
echo   2. 系统全局临时文件
echo   3. 系统预读取缓存
echo   4. 回收站全部文件
echo   5. Windows组件存储冗余文件
echo   6. 系统更新缓存、旧安装包等垃圾
echo ======================================
echo 提示：部分文件被占用无法删除属于正常现象
echo.
set /p confirm=确认开始清理？输入Y继续：
if /i not "%confirm%"=="Y" (
    echo 已取消清理
    pause
    exit /b
)

echo.
echo ========== 清理开始 ==========

echo.
echo [1/6] 清理用户临时文件...
del /f /s /q "%temp%\*.*" >nul 2>&1
for /d %%p in ("%temp%\*") do rd /s /q "%%p" >nul 2>&1
echo 完成

echo.
echo [2/6] 清理系统临时文件...
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*") do rd /s /q "%%p" >nul 2>&1
echo 完成

echo.
echo [3/6] 清理系统预读取缓存...
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo 完成

echo.
echo [4/6] 清空回收站...
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo 完成

echo.
echo [5/6] 清理Windows组件冗余文件...
DISM /Online /Cleanup-Image /StartComponentCleanup /NoRestart >nul 2>&1
echo 完成

echo.
echo [6/6] 执行系统磁盘深度清理...
cleanmgr /verylowdisk >nul 2>&1
echo 完成

echo.
echo ========== 清理完成 ==========
echo 已完成C盘安全垃圾清理
pause
exit /b
