@echo off
title Canary Auto-Restarter
echo :: --- Auto-Restarter ---
echo :: %date%
echo :: %time%
:begin
canary.exe
echo :: --- Server Restarted ---
echo :: %date%
echo :: %time%
goto begin
:goto begin