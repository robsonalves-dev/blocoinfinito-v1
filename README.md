Bloco Infinito
Um jogo de quebra-cabeça casual para Android, desenvolvido em Flutter.
🎮 Sobre o projeto
No Bloco Infinito, o jogador deve encaixar diferentes peças em um tabuleiro 10x10, formando linhas e colunas completas para marcar pontos e tentar superar seu próprio recorde.
A V1 foi desenvolvida com foco em uma experiência simples, rápida e offline.
✨ Funcionalidades
- Tabuleiro 10x10
- Diferentes formatos de peças
- Sistema de arrastar e soltar
- Encaixe automático inteligente
- Eliminação de linhas e colunas completas
- Sistema de pontuação
- Combos
- Game Over
- Reinício da partida
- Nome do jogador salvo localmente
- Recorde e ranking local Top 5
- Configurações
- Funcionamento offline
- Google AdMob para monetização
🛠️ Tecnologias
- Flutter
- Dart
- Android
- SharedPreferences
- Google Mobile Ads
📱 Plataforma
Android
💰 Monetização
A V1 utiliza Google AdMob com anúncios intersticiais entre partidas, buscando evitar interrupções durante a jogabilidade.
📦 Estrutura principal
lib/
├── core/
│   ├── game_logic.dart
│   ├── piece_shapes.dart
│   └── score_manager.dart
├── pages/
│   ├── game_page.dart
│   ├── recorde_page.dart
│   └── settings_page.dart
├── services/
│   ├── ad_manager.dart
│   ├── player_storage.dart
│   └── score_storage.dart
├── widgets/
│   ├── board_widget.dart
│   └── piece_widget.dart
└── main.dart
🚀 Como executar
flutter pub get
flutter run
Para gerar o APK:
flutter build apk --release
Para gerar versões separadas por arquitetura:
flutter build apk --release --split-per-abi
✅ Status
V1 — Finalizada
10/10 etapas concluídas — 100%.
A V1 foi testada no Android, incluindo jogabilidade, encaixe de peças, eliminação de linhas e colunas, Game Over, reinício e exibição de anúncios.
👨‍💻 Projeto
Bloco Infinito — V1
