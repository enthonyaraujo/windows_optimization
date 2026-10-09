@echo off
:: Executa o script PowerShell ignorando politicas restritivas de execucao e solicitando permissao de admin se necessario
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0otimizar_gpedit.ps1"
