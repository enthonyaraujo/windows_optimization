# ==============================================================================
# SCRIPT DE OTIMIZACAO DO WINDOWS 11 VIA REGISTRO (DIRETIVAS GPEDIT.MSC)
# Arquivo de origem: politica_de_grupo.md
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. Verificacao de Privilegios de Administrador (com elevacao automatica)
# ------------------------------------------------------------------------------
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]$currentUser
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[!] Privilegios de Administrador necessarios." -ForegroundColor Yellow
    Write-Host "[*] Solicitando elevacao de UAC..." -ForegroundColor Cyan
    try {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    } catch {
        Write-Error "Nao foi possivel elevar automaticamente. Abra o PowerShell como Administrador e execute este script."
        Read-Host "Pressione Enter para sair..."
        exit 1
    }
}

# Funcao auxiliar para criar caminho de registro e definir propriedade com seguranca
function Set-RegPolicy {
    param (
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][object]$Value,
        [string]$Type = "DWord",
        [string]$Description = ""
    )
    try {
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
        if ($Description) {
            Write-Host " [+] $Description" -ForegroundColor Green
        }
    } catch {
        Write-Host " [-] Falha ao definir $Name em $Path : $_" -ForegroundColor Red
    }
}

Clear-Host
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "       APLICANDO DIRETIVAS DE GRUPO (GPEDIT.MSC) VIA REGISTRO DO WINDOWS     " -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host ""

# ==============================================================================
# 1. COMPONENTES DO WINDOWS
# ==============================================================================

# --- Coleta de Dados e Compilacoes de Visualizacao ---
# Permitir dados de diagnostico: Desativado (0 = Segurança / Desativado)
Write-Host "--- 1.1 Coleta de Dados e Telemetria ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
              -Name "AllowTelemetry" -Value 0 -Type DWord `
              -Description "Telemetria de dados de diagnostico desativada (AllowTelemetry = 0)"

# --- Compatibilidade de Aplicativos ---
# Desativar Telemetria, Engine, PCA e Inventario
Write-Host "--- 1.2 Compatibilidade de Aplicativos ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" `
              -Name "AITEnable" -Value 0 -Type DWord `
              -Description "Telemetria de Aplicativos desativada (AITEnable = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" `
              -Name "DisableEngine" -Value 1 -Type DWord `
              -Description "Mecanismo de Compatibilidade de Aplicativos desativado (DisableEngine = 1)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" `
              -Name "DisablePCA" -Value 1 -Type DWord `
              -Description "Assistente de Compatibilidade de Programas desativado (DisablePCA = 1)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" `
              -Name "DisableInventory" -Value 1 -Type DWord `
              -Description "Coletor de Inventario de Aplicativos desativado (DisableInventory = 1)"

# --- Conteudo da Nuvem ---
# Desativar conteudo otimizado de nuvem e experiencias do consumidor (bloatware/sugestoes)
Write-Host "--- 1.3 Conteudo da Nuvem e Sugestoes de Consumo ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" `
              -Name "DisableCloudOptimizedContent" -Value 1 -Type DWord `
              -Description "Conteudo otimizado de nuvem desativado (DisableCloudOptimizedContent = 1)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" `
              -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord `
              -Description "Experiencias do consumidor Microsoft desativadas (DisableWindowsConsumerFeatures = 1)"

# --- Controle por Voz / Fala ---
# Permitir a Atualizacao Automatica de Dados de Fala: Desativado
Write-Host "--- 1.4 Controle por Voz / Fala ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Speech" `
              -Name "AllowSpeechModelUpdate" -Value 0 -Type DWord `
              -Description "Atualizacao automatica de modelos de fala desativada (AllowSpeechModelUpdate = 0)"

# --- Explorador de Arquivos ---
# Desativar historico, recomendados, favoritos e insights baseados em conta
Write-Host "--- 1.5 Explorador de Arquivos ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
              -Name "ShowRecent" -Value 0 -Type DWord `
              -Description "Ocultar arquivos recentes no Explorer (ShowRecent = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
              -Name "ShowFrequent" -Value 0 -Type DWord `
              -Description "Ocultar pastas frequentes no Explorer (ShowFrequent = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
              -Name "ShowRecommendations" -Value 0 -Type DWord `
              -Description "Ocultar secao recomendados no Explorer (ShowRecommendations = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
              -Name "HideRecommendedSection" -Value 1 -Type DWord `
              -Description "Secao de recomendados oculta (HideRecommendedSection = 1)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
              -Name "NoRecentDocsHistory" -Value 1 -Type DWord `
              -Description "Historico de documentos recentes desativado (NoRecentDocsHistory = 1)"

# --- Local e Sensores ---
# Desativar Localizacao do Windows e Sensores
Write-Host "--- 1.6 Localizacao e Sensores ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" `
              -Name "DisableLocation" -Value 1 -Type DWord `
              -Description "Servico de Localizacao do Windows desativado (DisableLocation = 1)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" `
              -Name "DisableSensors" -Value 1 -Type DWord `
              -Description "Sensores em segundo plano desativados (DisableSensors = 1)"

# --- Microsoft Store (Loja) ---
# Desativar download e instalacao automatica de atualizacoes da Loja (2 = Notificar/Nao baixar auto)
Write-Host "--- 1.7 Microsoft Store ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" `
              -Name "AutoDownload" -Value 2 -Type DWord `
              -Description "Download automatico de atualizacoes da Loja desativado (AutoDownload = 2)"

# --- Microsoft Edge ---
# Impedir pré-inicializacao e pre-carregamento da pagina Nova Guia
Write-Host "--- 1.8 Microsoft Edge ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" `
              -Name "AllowTabPreloading" -Value 0 -Type DWord `
              -Description "Pre-carregamento de Guias do Edge desativado (AllowTabPreloading = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" `
              -Name "AllowPrelaunch" -Value 0 -Type DWord `
              -Description "Pre-inicializacao do Edge com o Windows desativada (AllowPrelaunch = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
              -Name "StartupBoostEnabled" -Value 0 -Type DWord `
              -Description "Startup Boost do Edge Chromium desativado (StartupBoostEnabled = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
              -Name "BackgroundModeEnabled" -Value 0 -Type DWord `
              -Description "Modo de segundo plano do Edge desativado (BackgroundModeEnabled = 0)"

# --- Pesquisar (Windows Search) ---
# Bloquear Cortana, busca na nuvem/Bing, destaques e permitir economia na bateria
Write-Host "--- 1.9 Pesquisar (Windows Search) ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
              -Name "AllowCortana" -Value 0 -Type DWord `
              -Description "Cortana desativada (AllowCortana = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
              -Name "AllowCloudSearch" -Value 0 -Type DWord `
              -Description "Pesquisa na nuvem desabilitada (AllowCloudSearch = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
              -Name "EnableDynamicContentInWSB" -Value 0 -Type DWord `
              -Description "Destaques dinamicos de pesquisa desativados (EnableDynamicContentInWSB = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
              -Name "AllowSearchToUseLocation" -Value 0 -Type DWord `
              -Description "Uso de localizacao na pesquisa desativado (AllowSearchToUseLocation = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
              -Name "AlwaysUseAutoLangDetection" -Value 0 -Type DWord `
              -Description "Deteccao automatica de idioma ao indexar desativada (AlwaysUseAutoLangDetection = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
              -Name "PreventIndexingOnBattery" -Value 1 -Type DWord `
              -Description "Indexacao suspensa ao usar bateria ativada (PreventIndexingOnBattery = 1)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
              -Name "DisableWebSearch" -Value 1 -Type DWord `
              -Description "Busca do Bing na barra de pesquisa desativada (DisableWebSearch = 1)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
              -Name "ConnectedSearchUseWeb" -Value 0 -Type DWord `
              -Description "Pesquisa conectada na web desativada (ConnectedSearchUseWeb = 0)"

# --- Privacidade de Aplicativos ---
# Bloquear execucao de aplicativos da Store em segundo plano (2 = Forcar Negacao / Force Deny)
Write-Host "--- 1.10 Privacidade de Aplicativos ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" `
              -Name "LetAppsRunInBackground" -Value 2 -Type DWord `
              -Description "Execucao de apps em segundo plano: Forcar Negacao (LetAppsRunInBackground = 2)"

# --- Relatorio de Erros do Windows ---
# Desabilitar Relatorios de Erro e Logs
Write-Host "--- 1.11 Relatorio de Erros do Windows (WER) ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" `
              -Name "Disabled" -Value 1 -Type DWord `
              -Description "Relatorio de Erros do Windows desativado (Disabled = 1)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" `
              -Name "LoggingDisabled" -Value 1 -Type DWord `
              -Description "Registro de logs de erros desativado (LoggingDisabled = 1)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" `
              -Name "DoReport" -Value 0 -Type DWord `
              -Description "Envio de relatorios de erros desativado (DoReport = 0)"

# --- Sincronizar Suas Configuracoes ---
# Nao sincronizar configuracoes com conta online
Write-Host "--- 1.12 Sincronizacao de Configuracoes ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync" `
              -Name "DisableSettingSync" -Value 2 -Type DWord `
              -Description "Sincronizacao de configuracoes desativada (DisableSettingSync = 2)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SettingSync" `
              -Name "DisableSettingSyncUserOverride" -Value 1 -Type DWord `
              -Description "Sobrescrita de usuario para sincronizacao desativada (DisableSettingSyncUserOverride = 1)"

# --- Windows Update ---
# Configurar atualizacoes para avisar antes de baixar, sem notificacoes intrusivas e sem substituir drivers
Write-Host "--- 1.13 Windows Update ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" `
              -Name "NoAutoUpdate" -Value 0 -Type DWord `
              -Description "Atualizacoes automaticas gerenciadas (NoAutoUpdate = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" `
              -Name "AUOptions" -Value 2 -Type DWord `
              -Description "Avisar antes de baixar e instalar atualizacoes (AUOptions = 2)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" `
              -Name "SetUpdateNotificationLevel" -Value 2 -Type DWord `
              -Description "Notificacoes intrusivas de atualizacao desativadas (SetUpdateNotificationLevel = 2)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" `
              -Name "ExcludeWUDriversInQualityUpdate" -Value 1 -Type DWord `
              -Description "Instalacao de drivers pelo Windows Update bloqueada (ExcludeWUDriversInQualityUpdate = 1)"


# ==============================================================================
# 2. MENU INICIAR E SISTEMA
# ==============================================================================

# --- Menu Iniciar e Barra de Tarefas ---
Write-Host "--- 2.1 Menu Iniciar e Barra de Tarefas ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
              -Name "NoRecentDocsHistory" -Value 1 -Type DWord `
              -Description "Nao manter historico de documentos recentes (HKCU NoRecentDocsHistory = 1)"

# --- Perfis de Usuario (ID de Anuncio) ---
Write-Host "--- 2.2 Perfis de Usuario ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" `
              -Name "DisabledByGroupPolicy" -Value 1 -Type DWord `
              -Description "ID de Anuncios publicitario desligado (DisabledByGroupPolicy = 1)"

# --- Politicas de SO (Atividade e Linha do Tempo) ---
Write-Host "--- 2.3 Politicas de SO (Feed de Atividades) ---" -ForegroundColor Yellow
Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" `
              -Name "EnableActivityFeed" -Value 0 -Type DWord `
              -Description "Feed de atividades desabilitado (EnableActivityFeed = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" `
              -Name "AllowCrossDeviceClipboard" -Value 0 -Type DWord `
              -Description "Sincronizacao de area de transferencia em dispositivos desativada (AllowCrossDeviceClipboard = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" `
              -Name "PublishUserActivities" -Value 0 -Type DWord `
              -Description "Publicacao de atividades do usuario desativada (PublishUserActivities = 0)"

Set-RegPolicy -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" `
              -Name "UploadUserActivities" -Value 0 -Type DWord `
              -Description "Upload de atividades do usuario para nuvem desativado (UploadUserActivities = 0)"


# ==============================================================================
# 3. ATUALIZACAO IMEDIATA DAS POLITICAS
# ==============================================================================
Write-Host ""
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "  Atualizando diretivas locais com gpupdate /force...                         " -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan

try {
    Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force" -Wait -NoNewWindow
    Write-Host " [+] Diretivas de grupo atualizadas com sucesso!" -ForegroundColor Green
} catch {
    Write-Host " [-] Nao foi possivel rodar gpupdate automaticamente: $_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "  TODAS AS POLITICAS DO ARQUIVO POLITICA_DE_GRUPO.MD FORAM APLICADAS!         " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "Recomendacao: Reinicie o computador para aplicar todas as mudancas." -ForegroundColor Cyan
Write-Host ""
Read-Host "Pressione [Enter] para concluir e fechar..."
