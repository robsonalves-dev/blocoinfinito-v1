# 🎮 Bloco Infinito

**Jogo de quebra-cabeça casual para Android, desenvolvido em Flutter e Dart.**

**Versão atual:** V2.0.0  
**Plataforma:** Android  
**Status:** Desenvolvimento da V2 concluído

---

## 🎯 Sobre o projeto

Bloco Infinito é um jogo de quebra-cabeça no qual o jogador precisa encaixar diferentes peças em um tabuleiro 10x10, formando linhas e colunas completas para conquistar pontos e superar seus próprios recordes.

O projeto começou com uma V1 simples, funcional e offline.

Na **V2.0.0**, o jogo evoluiu com novos níveis de dificuldade, temas visuais dinâmicos, efeitos especiais e sistema de áudio.

## ✨ Funcionalidades

### 🎲 Jogabilidade
- Tabuleiro 10x10
- Diferentes formatos de peças
- Sistema de arrastar e soltar
- Encaixe automático inteligente
- Eliminação de linhas e colunas completas
- Sistema de pontuação
- Sistema de combos
- Game Over e reinício de partida
- Funcionamento offline

### 🏆 Recordes
- Nome do jogador salvo localmente
- Recorde pessoal
- Ranking local Top 5

### 🎨 Novidades da V2.0.0
- Sistema de dificuldade progressiva
- Novos formatos de peças
- Peças mais desafiadoras nos níveis avançados
- Temas neon dinâmicos conforme a pontuação
- Paletas roxo neon, azul elétrico, verde e dourado
- Efeitos de brilho
- Partículas e animações visuais
- Melhorias na aparência do tabuleiro

### 🔊 Sistema de áudio
- Efeito sonoro ao encaixar peças
- Efeito sonoro ao eliminar linhas e colunas
- Efeito sonoro para combos
- Música de fundo durante as partidas
- Controles separados para música e efeitos sonoros

### ⚙️ Configurações
- Preferências salvas localmente
- Controle de música de fundo
- Controle de efeitos sonoros

## 🛠️ Tecnologias utilizadas

- Flutter
- Dart
- Android
- SharedPreferences
- Audioplayers
- Google Mobile Ads (AdMob)

## 💰 Monetização

O Bloco Infinito possui integração com o **Google AdMob**, utilizando anúncios intersticiais entre partidas, buscando evitar interrupções durante a jogabilidade.

## 📦 Estrutura principal

```text
lib/
├── core/
│   ├── game_logic.dart
│   ├── game_theme.dart
│   ├── piece_shapes.dart
│   └── score_manager.dart
├── pages/
│   ├── game_page.dart
│   ├── recorde_page.dart
│   └── settings_page.dart
├── services/
│   ├── ad_manager.dart
│   ├── audio_service.dart
│   ├── player_storage.dart
│   └── score_storage.dart
├── widgets/
│   ├── board_widget.dart
│   └── piece_widget.dart
└── main.dart

assets/
└── sounds/
    ├── encaixe.mp3
    ├── eliminacao.mp3
    ├── combo.mp3
    └── musica_fundo.mp3
```

## 🚀 Como executar

Instale o Flutter e configure o ambiente Android.

Clone o repositório:

```bash
git clone https://github.com/robsonalves-dev/blocoinfinito-v1.git
```

Entre na pasta do projeto:

```bash
cd blocoinfinito-v1
```

Instale as dependências:

```bash
flutter pub get
```

Execute o jogo:

```bash
flutter run
```

### Gerar APK

```bash
flutter build apk --release
```

Para gerar APKs separados por arquitetura:

```bash
flutter build apk --release --split-per-abi
```

## 📜 Histórico de versões

### V1.0.0 — Primeira versão
**Status: Finalizada**

- Tabuleiro 10x10
- Sistema de peças
- Pontuação e combos
- Recordes locais
- Configurações
- Game Over
- Integração com AdMob

A V1 foi concluída com 10 de 10 etapas implementadas e testada no Android.

### V2.0.0 — Evolução visual e sonora
**Status: Finalizada**

- Dificuldade progressiva
- Novos formatos de peças
- Temas neon dinâmicos
- Efeitos visuais e animações
- Sons de encaixe, eliminação e combo
- Música de fundo
- Controles independentes de áudio

**[Acessar o código da V2.0.0](https://github.com/robsonalves-dev/blocoinfinito-v1/tree/v2.0.0)**

## 👨‍💻 Desenvolvimento

Desenvolvido por **Robson Alves**.

GitHub: [robsonalves-dev](https://github.com/robsonalves-dev)

**Bloco Infinito — V2.0.0**
