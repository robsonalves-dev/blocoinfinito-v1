
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  // Efeitos sonoros.
  final AudioPlayer _encaixePlayer = AudioPlayer();
  final AudioPlayer _eliminacaoPlayer = AudioPlayer();
  final AudioPlayer _comboPlayer = AudioPlayer();

  // Música de fundo.
  final AudioPlayer _musicaPlayer = AudioPlayer();

  bool _efeitosAtivados = true;
  bool _somAtivado = true;

  bool _inicializado = false;
  Future<void>? _inicializacaoEmAndamento;

  bool _partidaAtiva = false;

  Future<void> inicializar() async {
    if (_inicializado) return;

    if (_inicializacaoEmAndamento != null) {
      return _inicializacaoEmAndamento!;
    }

    final tarefa = _prepararAudio();
    _inicializacaoEmAndamento = tarefa;

    try {
      await tarefa;
      _inicializado = true;
    } finally {
      _inicializacaoEmAndamento = null;
    }
  }

  Future<void> _prepararAudio() async {
    final prefs = await SharedPreferences.getInstance();

    _efeitosAtivados =
        prefs.getBool('efeitos_ativados') ?? true;

    _somAtivado =
        prefs.getBool('som_ativado') ?? true;

    // Permite que música e efeitos compartilhem o áudio
    // sem disputar o foco no Android.
    final contextoAudio = AudioContext(
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.none,
      ),
    );

    await Future.wait([
      _encaixePlayer.setAudioContext(contextoAudio),
      _eliminacaoPlayer.setAudioContext(contextoAudio),
      _comboPlayer.setAudioContext(contextoAudio),
      _musicaPlayer.setAudioContext(contextoAudio),
    ]);

    // Configuração dos efeitos.
    await Future.wait([
      _encaixePlayer.setReleaseMode(ReleaseMode.stop),
      _eliminacaoPlayer.setReleaseMode(ReleaseMode.stop),
      _comboPlayer.setReleaseMode(ReleaseMode.stop),
    ]);

    // Arquivos dos efeitos.
    await Future.wait([
      _encaixePlayer.setSource(
        AssetSource('sounds/encaixe.mp3'),
      ),
      _eliminacaoPlayer.setSource(
        AssetSource('sounds/eliminacao.mp3'),
      ),
      _comboPlayer.setSource(
        AssetSource('sounds/combo.mp3'),
      ),
    ]);

    // Música em loop.
    await _musicaPlayer.setReleaseMode(
      ReleaseMode.loop,
    );

    // Volume de fundo: 25%.
    await _musicaPlayer.setVolume(0.25);

    await _musicaPlayer.setSource(
      AssetSource('sounds/musica_fundo.mp3'),
    );
  }

  // Atualiza as preferências salvas.
  Future<void> atualizarPreferencia() async {
    final prefs = await SharedPreferences.getInstance();

    _efeitosAtivados =
        prefs.getBool('efeitos_ativados') ?? true;

    _somAtivado =
        prefs.getBool('som_ativado') ?? true;
  }

  // EFEITOS SONOROS

  Future<void> tocarEncaixe() async {
    await _tocarEfeito(_encaixePlayer);
  }

  Future<void> tocarEliminacao() async {
    await _tocarEfeito(_eliminacaoPlayer);
  }

  Future<void> tocarCombo() async {
    await _tocarEfeito(_comboPlayer);
  }

  Future<void> _tocarEfeito(AudioPlayer player) async {
    try {
      await inicializar();
      await atualizarPreferencia();

      if (!_efeitosAtivados) return;

      await player.stop();
      await player.resume();
    } catch (e) {
      // Falhas de áudio não interrompem a partida.
    }
  }

  // MÚSICA DE FUNDO

  Future<void> iniciarMusica() async {
    _partidaAtiva = true;

    try {
      await inicializar();
      await atualizarPreferencia();

      if (!_partidaAtiva || !_somAtivado) return;

      if (_musicaPlayer.state != PlayerState.playing) {
        await _musicaPlayer.resume();
      }
    } catch (e) {
      // Falhas de áudio não interrompem a partida.
    }
  }

  Future<void> pararMusica() async {
    _partidaAtiva = false;

    try {
      await _musicaPlayer.stop();
    } catch (e) {
      // Evita interromper a navegação.
    }
  }

  Future<void> sincronizarMusica() async {
    try {
      await inicializar();
      await atualizarPreferencia();

      if (!_partidaAtiva || !_somAtivado) {
        await _musicaPlayer.pause();
        return;
      }

      if (_musicaPlayer.state != PlayerState.playing) {
        await _musicaPlayer.resume();
      }
    } catch (e) {
      // Evita interromper a partida.
    }
  }

  // LIBERAÇÃO DOS RECURSOS

  Future<void> dispose() async {
    _partidaAtiva = false;

    await Future.wait([
      _encaixePlayer.dispose(),
      _eliminacaoPlayer.dispose(),
      _comboPlayer.dispose(),
      _musicaPlayer.dispose(),
    ]);

    _inicializado = false;
  }
}
