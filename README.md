# 🚀 Windows Optimization - Super Otimizador Gamer

Conjunto de scripts automatizados para **superotimização do Windows 10 e Windows 11**, focado em **máximo desempenho em jogos**, **redução de latência (input lag)**, **estabilização de ping** e **privacidade/remoção de telemetria**.

Compatível com qualquer computador desktop ou notebook (Intel, AMD, NVIDIA, Radeon).

---

## ⚡ Principais Otimizações

### 🎮 1. Jogos, Baixa Latência & Hardware
* **Desativação de Serviços Inúteis:** Desativa serviços nativos de telemetria, coleta de relatórios de falha e diagnóstico que geram picos de CPU e *stutters*.
* **Agendamento de GPU por Hardware (HAGS):** Ativa o agendamento de GPU acelerado por hardware para diminuir a fila de renderização de quadros e latência de VRAM.
* **Plano de Energia Desempenho Máximo:** Força o escalonamento do processador a manter os clocks estáveis e elimina o *Core Parking*.
* **Desativação de Power Throttling:** Impede o Windows de limitar a energia de tarefas pesadas e jogos.
* **Redução de Latência de Rede (Algoritmo Nagle):** Ativa `TCPNoDelay` e `TcpAckFrequency = 1` nas interfaces ativas, transmitindo pacotes de jogos instantaneamente.
* **Desativação do Network Throttling:** Remove a limitação padrão de pacotes do subsistema multimídia do Windows.
* **Redução de Input Lag:** Zera o atraso artificial de menus (`MenuShowDelay = 0`), otimiza a repetição de teclado e desativa as Teclas de Aderência (*Sticky Keys*).
* **Agrupamento de Processos SvcHost:** Ajusta o `SvcHostSplitThreshold` para que serviços compartilhem instâncias de `svchost.exe`, reduzindo drasticamente a contagem de processos em segundo plano.
* **Exclusão no Windows Defender:** Isenta a pasta padrão da biblioteca Steam de inspeções em tempo real para acelerar carregamento de texturas e mapas.

---

### 🛡️ 2. Diretivas de Grupo (GPEDIT) & Privacidade
* **Corte de Telemetria:** Nível de dados de diagnóstico reduzido ao mínimo (`AllowTelemetry = 0`).
* **Desativação de Bloatware da Interface:** Remove Widgets de notícias da barra de tarefas e o Windows Copilot (eliminando processos em segundo plano do Edge WebView2).
* **Microsoft Edge:** Impede o navegador de pré-inicializar com o sistema ou manter instâncias em segundo plano (*Startup Boost* desativado).
* **Windows Update Otimizado:** Configurado para notificar antes de baixar e instalar (`AUOptions = 2`) e bloqueia a substituição automática de drivers de vídeo por genéricos.
* **Pesquisa do Windows:** Desativa buscas no Bing na barra de tarefas, destaques dinâmicos e Cortana.
* **Execução em Segundo Plano:** Impõe negação de execução passiva para aplicativos da Microsoft Store (*Force Deny*).

---

### 🧹 3. Limpeza do Sistema
* **Remoção de Hibernação e Fast Startup:** Executa `powercfg -h off`, liberando gigabytes de espaço do arquivo `hiberfil.sys` e garantindo que o sistema sempre inicie com kernel e memória RAM limpos.
* **Limpeza de Temporários:** Esvaziamento de caches de `%TEMP%` e `C:\Windows\Temp`.
* **Flush de DNS:** Limpa caches de rotas de rede para resolução limpa de servidores de jogos.

---

## 🖥️ Como Utilizar

1. Baixe ou clone o repositório:
   ```bash
   git clone git@github.com:enthonyaraujo/windows_optimization.git
   ```
2. Abra a pasta e execute o script principal com **dois cliques**:
   * **`Otimizador_Gamer.bat`** *(O script solicitará privilégios de Administrador automaticamente via UAC)*.
3. Escolha a opção desejada no Menu Interativo:

```text
==============================================================================
              SUPER OTIMIZADOR DO WINDOWS - JOGOS E DESEMPENHO
==============================================================================
  [1] SUPER OTIMIZACAO COMPLETA (Recomendado - Aplica TODOS os Modulos)
  [2] Apenas Jogos e Baixa Latencia (HAGS, Nagle, Input Lag, Throttling, Servicos)
  [3] Apenas Politicas GPEDIT e Privacidade (Telemetria, Widgets, Edge, Update)
  [4] Limpeza do Sistema (Liberar Espaco em Disco, Temp e Flush DNS)
  [5] Restaurar Sistema e Servicos ao Padrao de Fabrica do Windows
  [0] Sair
==============================================================================
```

> **Dica:** Após aplicar a opção **[1]**, reinicie o computador para que todas as diretivas de hardware e rede entrem em vigor completamente.

---

## 🔄 Reversibilidade Total
Para desfazer qualquer alteração e restaurar todos os serviços, planos de energia e chaves de registro para os valores de fábrica do Windows, basta executar o `Otimizador_Gamer.bat` e escolher a **Opção [5] (Restaurar)**.

---

## 📁 Estrutura do Repositório
* `Otimizador_Gamer.bat` — Script master completo com auto-elevação e menu interativo.
* `otimizar_gpedit.ps1` — Script modular em PowerShell para aplicação estrita das políticas de grupo via registro.
* `executar_otimizar_gpedit.bat` — Inicializador rápido para o script PowerShell.
* `politica_de_grupo.md` — Documentação de referência das diretivas de grupo mapeadas.
