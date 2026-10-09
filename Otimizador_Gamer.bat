@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: -----------------------------------------------------------------------------
:: Verificacao e Auto-Elevacao de Privilegios de Administrador
:: -----------------------------------------------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ==============================================================================
    echo  [!] Solicitando privilegios de Administrador...
    echo ==============================================================================
    powershell -NoProfile -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

title SUPER OTIMIZADOR DO WINDOWS - JOGOS E DESEMPENHO
color 0A

:MENU
cls
echo ==============================================================================
echo              SUPER OTIMIZADOR DO WINDOWS - JOGOS E DESEMPENHO
echo ==============================================================================
echo  Compativel com qualquer computador (Windows 10 / Windows 11)
echo ==============================================================================
echo.
echo   [1] SUPER OTIMIZACAO COMPLETA (Recomendado - Aplica TODOS os Modulos)
echo   [2] Apenas Jogos e Baixa Latencia (HAGS, Nagle, Input Lag, Throttling, Servicos)
echo   [3] Apenas Politicas GPEDIT e Privacidade (Telemetria, Widgets, Edge, Update)
echo   [4] Limpeza do Sistema (Liberar Espaco em Disco, Temp e Flush DNS)
echo   [5] Restaurar Sistema e Servicos ao Padrao de Fabrica do Windows
echo   [0] Sair
echo.
echo ==============================================================================
set /p "OPCAO= Escolha uma opcao [0-5] e pressione Enter: "

if "%OPCAO%"=="1" goto APLICAR_TUDO
if "%OPCAO%"=="2" goto APLICAR_JOGOS
if "%OPCAO%"=="3" goto APLICAR_GPEDIT
if "%OPCAO%"=="4" goto APLICAR_LIMPEZA
if "%OPCAO%"=="5" goto RESTAURAR_TUDO
if "%OPCAO%"=="0" exit /b
goto MENU


:: ==============================================================================
:: SUBROTINA 1: JOGOS, BAIXA LATENCIA E HARDWARE
:: ==============================================================================
:SUB_JOGOS
echo.
echo ==============================================================================
echo [MODULO JOGOS] 1. Desativando servicos desnecessarios do Windows...
echo ==============================================================================
set "SERVICES=SysMain TrkWks InventorySvc dptftcs DoSvc DPS WdiServiceHost WdiSystemHost PcaSvc whesvc DusmSvc CDPSvc WerSvc wercplsupport MapsBroker PhoneSvc RetailDemo wisvc WpcMonSvc WalletService cplspcon"

for %%s in (%SERVICES%) do (
    sc query "%%s" >nul 2>&1
    if !errorlevel! equ 0 (
        sc stop "%%s" >nul 2>&1
        sc config "%%s" start= disabled >nul 2>&1
        echo   [+] Servico desativado: %%s
    )
)

echo.
echo [MODULO JOGOS] 2. Ativando Plano de Energia de Alto Desempenho...
powercfg /setactive 804c2055-e7c2-4cd8-8f81-9c94d14153a0 >nul 2>&1
if !errorlevel! neq 0 (
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
)
if !errorlevel! neq 0 (
    powercfg /setactive 391ed73f-956a-401e-9534-4827df3eedcb >nul 2>&1
)
echo   [+] Plano de Alto Desempenho ativado.

echo.
echo [MODULO JOGOS] 3. Desativando Power Throttling global da CPU...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f >nul 2>&1
echo   [+] Power Throttling desativado (CPU mantem clock estavel em jogos).

echo.
echo [MODULO JOGOS] 4. Ativando Agendamento de GPU (HAGS) e Modo de Jogo...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo   [+] HAGS (Hardware Accelerated GPU Scheduling) ativado.
echo   [+] Modo de Jogo do Windows (Game Mode) forcado como ATIVO.

echo.
echo [MODULO JOGOS] 5. Otimizando Latencia de Rede (NetworkThrottling e Algoritmo Nagle)...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1

powershell -NoProfile -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue }" >nul 2>&1
echo   [+] Limitacao de rede (Network Throttling) desativada.
echo   [+] Algoritmo Nagle desativado (Pacotes de rede enviados imediatamente).
echo   [+] Prioridade de GPU e Escalonador de Jogos configurados no nivel MAXIMO.

echo.
echo [MODULO JOGOS] 6. Reduzindo Input Lag e Atrasos de Interface...
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "122" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "58" /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f >nul 2>&1
echo   [+] Delay de menus zerado (MenuShowDelay = 0).
echo   [+] Teclas de Aderencia desativadas (sem pop-ups ao pressionar Shift/Ctrl em jogos).
echo   [+] Taxa de repeticao do teclado otimizada para resposta rapida.

echo.
echo [MODULO JOGOS] 7. Exclusao de Pastas de Jogos no Windows Defender...
if exist "%ProgramFiles(x86)%\Steam\steamapps" (
    powershell -NoProfile -Command "Add-MpPreference -ExclusionPath '%ProgramFiles(x86)%\Steam\steamapps' -ErrorAction SilentlyContinue" >nul 2>&1
    echo   [+] Pasta padrao da biblioteca Steam excluida da verificacao em tempo real.
)

echo.
echo [MODULO JOGOS] 8. Otimizando Agrupamento de Processos SvcHost...
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d 380000000 /f >nul 2>&1
echo   [+] SvcHostSplitThreshold configurado para agrupar servicos do Windows.
echo       (Reduz dezenas de processos svchost em segundo plano apos reiniciar).
exit /b


:: ==============================================================================
:: SUBROTINA 2: DIRETIVAS GPEDIT.MSC, PRIVACIDADE E WIDGETS
:: ==============================================================================
:SUB_GPEDIT
echo.
echo ==============================================================================
echo [MODULO GPEDIT] Aplicando Diretivas de Grupo e Privacidade...
echo ==============================================================================

:: 1.1 Coleta de Dados e Telemetria
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [+] Telemetria de diagnostico desativada.

:: 1.2 Compatibilidade de Aplicativos
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d 1 /f >nul 2>&1
echo   [+] Coletor de Inventario e Assistente de Compatibilidade desativados.

:: 1.3 Conteudo da Nuvem e Sugestoes
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f >nul 2>&1
echo   [+] Conteudo otimizado de nuvem e sugestoes comerciais desativados.

:: 1.4 Dados de Fala
reg add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [+] Atualizacao automatica de modelos de fala desativada.

:: 1.5 Explorador de Arquivos
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ShowRecommendations" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecommendedSection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f >nul 2>&1
echo   [+] Historico recente e recomendacoes do Explorador desativados.

:: 1.6 Localizacao e Sensores
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d 1 /f >nul 2>&1
echo   [+] Servicos de Localizacao e Sensores em segundo plano desativados.

:: 1.7 Microsoft Store
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f >nul 2>&1
echo   [+] Download automatico da Loja configurado para avisar (AutoDownload=2).

:: 1.8 Microsoft Edge
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v "AllowTabPreloading" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [+] Pre-carregamento e Startup Boost do Edge desativados.

:: 1.9 Windows Search
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "EnableDynamicContentInWSB" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AlwaysUseAutoLangDetection" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexingOnBattery" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [+] Busca na nuvem/Bing, Cortana e indexacao na bateria desativadas.

:: 1.10 Apps em Segundo Plano (Forcar Negacao)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
echo   [+] Execucao de aplicativos em segundo plano bloqueada (Force Deny).

:: 1.11 Relatorios de Erros (WER)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DoReport" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [+] Envio de relatorios de erros do Windows desativado.

:: 1.12 Sincronizacao de Configuracoes
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d 1 /f >nul 2>&1
echo   [+] Sincronizacao constante com a nuvem desativada.

:: 1.13 Windows Update (Avisar antes de baixar, sem notificacoes e sem substituir drivers)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetUpdateNotificationLevel" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d 1 /f >nul 2>&1
echo   [+] Windows Update configurado para avisar e NAO substituir drivers.

:: 2.1 - 2.3 ID de Anuncios, Politicas de SO, Widgets e Copilot
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowCrossDeviceClipboard" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [+] ID de publicidade, Feed de atividades, Widgets e Copilot desativados.

echo.
echo [*] Atualizando diretivas locais com gpupdate /force...
gpupdate /force >nul 2>&1
echo   [+] Diretivas de grupo atualizadas com sucesso.
exit /b


:: ==============================================================================
:: SUBROTINA 3: LIMPEZA PROFUNDA E LIBERACAO DE ESPACO
:: ==============================================================================
:SUB_LIMPEZA
echo.
echo ==============================================================================
echo [MODULO LIMPEZA] Liberando espaco no disco e limpando caches...
echo ==============================================================================

:: Desativa Hibernacao e Fast Startup (elimina hiberfil.sys e libera espaco em disco)
powercfg -h off >nul 2>&1
echo   [+] Hibernacao e Fast Startup desativados (Espaco em disco liberado).
echo       (Garante que o Windows sempre inicie com kernel e RAM 100%% limpos).

:: Limpeza de temporarios
echo   [*] Limpando arquivos temporarios do usuario e do sistema...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
echo   [+] Arquivos temporarios excluidos.

:: Flush de DNS
ipconfig /flushdns >nul 2>&1
echo   [+] Cache de rotas DNS limpo com sucesso.
exit /b


:: ==============================================================================
:: FLUXOS PRINCIPAIS DO MENU
:: ==============================================================================

:APLICAR_TUDO
cls
echo ==============================================================================
echo       [OPCAO 1] APLICANDO SUPER OTIMIZACAO COMPLETA DO SISTEMA
echo ==============================================================================
call :SUB_JOGOS
call :SUB_GPEDIT
call :SUB_LIMPEZA
echo.
echo ==============================================================================
echo             SUPER OTIMIZACAO COMPLETA APLICADA COM SUCESSO!
echo ==============================================================================
echo [Dica]: Reinicie o computador para que todas as mudancas e o HAGS entrem em vigor.
echo.
pause
goto MENU


:APLICAR_JOGOS
cls
echo ==============================================================================
echo       [OPCAO 2] APLICANDO OTIMIZACOES DE JOGOS E BAIXA LATENCIA
echo ==============================================================================
call :SUB_JOGOS
echo.
echo ==============================================================================
echo        OTIMIZACOES DE JOGOS E LATENCIA APLICADAS COM SUCESSO!
echo ==============================================================================
echo.
pause
goto MENU


:APLICAR_GPEDIT
cls
echo ==============================================================================
echo       [OPCAO 3] APLICANDO DIRETIVAS GPEDIT, PRIVACIDADE E WIDGETS
echo ==============================================================================
call :SUB_GPEDIT
echo.
echo ==============================================================================
echo               DIRETIVAS GPEDIT APLICADAS COM SUCESSO!
echo ==============================================================================
echo.
pause
goto MENU


:APLICAR_LIMPEZA
cls
echo ==============================================================================
echo       [OPCAO 4] EXECUTANDO LIMPEZA PROFUNDA E LIBERACAO DE DISCO
echo ==============================================================================
call :SUB_LIMPEZA
echo.
echo ==============================================================================
echo                 LIMPEZA CONCLUIDA COM SUCESSO!
echo ==============================================================================
echo.
pause
goto MENU


:RESTAURAR_TUDO
cls
echo ==============================================================================
echo       [OPCAO 5] RESTAURANDO SISTEMA E SERVICOS AO PADRAO DE FABRICA
echo ==============================================================================
echo.
echo [*] Restaurando servicos do Windows...
set "AUTO_SERVICES=SysMain TrkWks InventorySvc dptftcs DoSvc DPS PcaSvc whesvc DusmSvc CDPSvc MapsBroker cplspcon"
for %%s in (%AUTO_SERVICES%) do (
    sc query "%%s" >nul 2>&1
    if !errorlevel! equ 0 (
        sc config "%%s" start= auto >nul 2>&1
        sc start "%%s" >nul 2>&1
        echo   [+] Restaurado para Automatico: %%s
    )
)

set "MANUAL_SERVICES=WdiServiceHost WdiSystemHost WerSvc wercplsupport PhoneSvc RetailDemo wisvc WpcMonSvc WalletService"
for %%s in (%MANUAL_SERVICES%) do (
    sc query "%%s" >nul 2>&1
    if !errorlevel! equ 0 (
        sc config "%%s" start= demand >nul 2>&1
        echo   [+] Restaurado para Manual: %%s
    )
)

echo.
echo [*] Restaurando Hibernacao e Plano de Energia para 'Equilibrado'...
powercfg -h on >nul 2>&1
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1

echo.
echo [*] Restaurando Power Throttling, HAGS e Agrupamento SvcHost...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d 3670016 /f >nul 2>&1

echo.
echo [*] Restaurando valores padrao de Rede, Multimidia e Nagle...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /f >nul 2>&1
powershell -NoProfile -Command "Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object { Remove-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -ErrorAction SilentlyContinue; Remove-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -ErrorAction SilentlyContinue }" >nul 2>&1

echo.
echo [*] Restaurando delays de interface e teclas de acessibilidade...
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "400" /f >nul 2>&1

echo.
echo [*] Removendo exclusao da Steam no Windows Defender...
if exist "%ProgramFiles(x86)%\Steam\steamapps" (
    powershell -NoProfile -Command "Remove-MpPreference -ExclusionPath '%ProgramFiles(x86)%\Steam\steamapps' -ErrorAction SilentlyContinue" >nul 2>&1
)

echo.
echo [*] Removendo restricoes de politicas de grupo, Widgets e Copilot...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /f >nul 2>&1

gpupdate /force >nul 2>&1
echo.
echo ==============================================================================
echo                 SISTEMA RESTAURADO AO PADRAO COM SUCESSO!
echo ==============================================================================
echo.
pause
goto MENU
