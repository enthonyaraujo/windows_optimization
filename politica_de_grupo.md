# Otimização do Windows 11 via Diretiva de Grupo Local (`gpedit.msc`)

> **Referência:** A partir dos [26:57] do vídeo tutorial sobre instalação e otimização do Windows 11.  
> **Como abrir:** Pressione `Win + R`, digite `gpedit.msc` e pressione `Enter`.  
> **Atenção:** Em diretivas que começam com o nome "Desativar...", a opção **Habilitado** ativa a restrição/bloqueio do recurso.

---

## 1. Componentes do Windows
*Caminho base:* `Configuração do Computador > Modelos Administrativos > Componentes do Windows`

### Coleta de Dados e Compilações de Visualização
* **Permitir dados de diagnóstico**: `Desativado`
  * *Objetivo:* Corta a telemetria profunda e relatórios enviados à Microsoft.

### Compatibilidade de Aplicativos
* **Desativar a Telemetria de Aplicativos**: `Habilitado`
* **Desativar o Mecanismo de Compatibilidade de Aplicativos**: `Habilitado`
* **Desativar o Assistente de Compatibilidade de Programas**: `Habilitado`
* **Desativar o Coletor de Inventário**: `Habilitado`
  * *Objetivo:* Evita monitoramento de uso de softwares locais e janelas intrusivas do assistente.

### Conteúdo da Nuvem
* **Desativar o conteúdo otimizado de nuvem**: `Habilitado`
* **Desativar experiências do consumidor da Microsoft**: `Habilitado`
  * *Objetivo:* Bloqueia propagandas, sugestões de apps e instalações automáticas de parceiros na inicialização.

### Controle por Voz / Fala
* **Permitir a Atualização Automática de Dados de Fala**: `Desativado`
  * *Objetivo:* Impede envio de dados de fala e download em segundo plano de modelos fonéticos.

### Explorador de Arquivos
* **Desativar insights baseados em conta, arquivos recentes, favoritos e recomendados no Explorador de Arquivos**: `Habilitado`
  * *Objetivo:* Limpa a tela inicial do Windows Explorer e impede telemetria de atividade de arquivos.

### Local e Sensores
* **Desativar local do Windows**: `Habilitado`
* **Desativar sensores**: `Habilitado` *(Observação: mantenha desativado caso utilize notebook 2 em 1 que dependa de giroscópio para rotação de tela)*
  * *Objetivo:* Corta serviços contínuos de geolocalização e sensores em segundo plano.

### Loja (Microsoft Store)
* **Desativar download e instalação automáticos de atualizações**: `Habilitado`
  * *Objetivo:* Permite o uso da loja, mas impede que ela baixe gigabytes de atualizações em segundo plano sem permissão.

### Microsoft Edge
* **Permitir que o Microsoft Edge inicie e carregue previamente a página Nova Guia...**: `Habilitado`  
  * *Configuração interna:* **Impedir pré-carregamento**
* **Permitir a pré-inicialização do Microsoft Edge na inicialização do Windows...**: `Habilitado`  
  * *Configuração interna:* **Impedir a pré-inicialização**
  * *Objetivo:* Impede o navegador de subir processos ocultos na inicialização do sistema, economizando memória RAM.

### Pesquisar (Windows Search)
* **Permitir Cortana**: `Desativado`
* **Permitir pesquisa na nuvem**: `Habilitado`  
  * *Configuração interna:* **Desabilitar pesquisa na nuvem**
* **Permitir destaques de pesquisa**: `Desativado`
* **Permitir que use localização na pesquisa**: `Desativado`
* **Sempre usar a detecção automática de idioma ao indexar conteúdo e propriedades**: `Desativado`
* **Impedir indexação ao utilizar bateria para conservar energia**: `Habilitado`
  * *Objetivo:* Torna o Menu Iniciar e a pesquisa mais rápidos, cortando buscas na web pelo Bing e poupando CPU/bateria.

### Privacidade de Aplicativos
* **Permitir que os aplicativos do Windows sejam executados em segundo plano**: `Habilitado`  
  * *Configuração interna:* **Forçar negação**
  * *Objetivo:* Impede que qualquer aplicativo UWP/Store consuma recursos em segundo plano silenciosamente.

### Relatório de Erros do Windows
* **Desabilitar Relatório de Erros do Windows**: `Habilitado`
* **Desabilitar log**: `Habilitado`
  * *Objetivo:* Evita o travamento do sistema aguardando criação e envio de despejos de memória para a Microsoft.

### Sincronizar suas configurações
* **Não sincronizar**: `Habilitado`
  * *Objetivo:* Impede a sincronização constante com contas Microsoft online.

### Windows Update
*Caminho:* `Componentes do Windows > Windows Update > Gerenciar a experiência do usuário final`
* **Configurar Atualizações Automáticas**: `Habilitado`  
  * *Configuração interna:* **Avisar antes de baixar e instalar automaticamente**
* **Opções de notificação de atualização**: `Habilitado`  
  * *Configuração interna:* **Desabilitar todas as notificações**
* **Não incluir drivers com as Atualizações do Windows**: `Habilitado`
  * *Objetivo:* O Windows Update não instala atualizações sem aviso nem substitui drivers de vídeo/chipset com versões genéricas.

---

## 2. Menu Iniciar e Sistema

### Menu Iniciar e Barra de Tarefas
*Caminho:* `Configuração do Computador > Modelos Administrativos > Menu Iniciar e Barra de Tarefas`
* **Não manter histórico de documentos abertos recentemente**: `Habilitado`

### Perfis de Usuário
*Caminho:* `Configuração do Computador > Modelos Administrativos > Sistema > Perfis de Usuário`
* **Desligar ID de anúncio**: `Habilitado`
  * *Objetivo:* Bloqueia o rastreador de perfil de anúncios publicitários.

### Políticas de SO
*Caminho:* `Configuração do Computador > Modelos Administrativos > Sistema > Políticas de SO`
* **Habilitar feed de atividades**: `Desativado`
* **Permitir sincronização de área de trabalho em dispositivos**: `Desativado`
* **Permitir publicação da atividade do Usuário**: `Desativado`
  * *Objetivo:* Desativa o histórico de linha do tempo e upload de ações do usuário para a nuvem.

---

## Como forçar a atualização imediata das políticas
Abra o Prompt de Comando ou PowerShell como Administrador e execute:
```cmd
gpupdate /force
```
Reinicie o computador para garantir que todos os serviços afetados sejam finalizados.