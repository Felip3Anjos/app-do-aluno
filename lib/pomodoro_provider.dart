// importa os pacotes necessários
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

// gerencia todo o estado e a lógica do timer pomodoro
class PomodoroProvider with ChangeNotifier {
  // variáveis de configuração (podem ser alteradas pelo usuário)
  int _focusTimeInSeconds = 25 * 60;
  int _shortBreakTimeInSeconds = 5 * 60;
  int _longBreakTimeInSeconds = 15 * 60;
  bool _soundEnabled = true;
  double _volume = 1.0;

  // variáveis de estado operacional (controlam o timer em tempo real)
  int _currentTimeInSeconds = 25 * 60;
  Timer? _timer;
  bool _isRunning = false;
  String _currentSession = 'Foco';
  int _pomodoroCount = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // construtor que carrega as configurações salvas assim que o provider é criado
  PomodoroProvider() {
    _loadSettings();
  }

  // --- getters: expõem os dados de estado para a ui de forma segura (somente leitura) ---
  int get currentTimeInSeconds => _currentTimeInSeconds;
  bool get isRunning => _isRunning;
  String get currentSession => _currentSession;
  bool get soundEnabled => _soundEnabled;
  double get volume => _volume;
  // converte os tempos de segundos para minutos para os sliders de configuração
  double get focusDuration => _focusTimeInSeconds / 60;
  double get shortBreakDuration => _shortBreakTimeInSeconds / 60;
  double get longBreakDuration => _longBreakTimeInSeconds / 60;
  // calcula o progresso do timer (de 1.0 a 0.0) para a barra de progresso circular
  double get progress {
    int totalDuration = _currentSession == 'Foco'
        ? _focusTimeInSeconds
        : (_currentSession == 'Pausa Curta'
              ? _shortBreakTimeInSeconds
              : _longBreakTimeInSeconds);
    if (totalDuration == 0) return 1.0;
    return _currentTimeInSeconds > 0
        ? _currentTimeInSeconds / totalDuration
        : 0;
  }

  //funções de controle do timer
  // inicia ou pausa o timer
  void startPauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
    } else {
      _isRunning = true;
      // cria um timer que executa a cada 1 segundo
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentTimeInSeconds > 0) {
          _currentTimeInSeconds--;
        } else {
          // quando o tempo chega a zero, para o timer e troca de sessão
          _timer?.cancel();
          _isRunning = false;
          _playSoundAndSwitchSession();
        }
        // notifica os widgets que estão 'ouvindo' para se reconstruírem com o novo tempo
        notifyListeners();
      });
    }
    notifyListeners();
  }

  // reseta o timer da sessão atual para o seu valor inicial
  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    if (_currentSession == 'Foco') {
      _currentTimeInSeconds = _focusTimeInSeconds;
    } else if (_currentSession == 'Pausa Curta') {
      _currentTimeInSeconds = _shortBreakTimeInSeconds;
    } else {
      _currentTimeInSeconds = _longBreakTimeInSeconds;
    }
    notifyListeners();
  }

  // implementa a lógica de alternância entre as sessões do pomodoro
  void _switchSession() {
    if (_currentSession == 'Foco') {
      _pomodoroCount++;
      // a cada 4 pomodoros, inicia uma pausa longa
      if (_pomodoroCount % 4 == 0) {
        _currentSession = 'Pausa Longa';
      } else {
        _currentSession = 'Pausa Curta';
      }
    } else {
      // após qualquer pausa, volta para o foco
      _currentSession = 'Foco';
    }
    resetTimer();
  }

  // toca o som de notificação e então troca a sessão
  Future<void> _playSoundAndSwitchSession() async {
    if (_soundEnabled) {
      try {
        await _audioPlayer.setVolume(_volume);
        await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
      } catch (e) {
        // erros som
      }
    }
    _switchSession();
  }

  //funções de gerenciamento de configurações

  // carrega as preferências do usuário salvas localmente no dispositivo
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _focusTimeInSeconds = (prefs.getInt('focusTime') ?? 25) * 60;
    _shortBreakTimeInSeconds = (prefs.getInt('shortBreakTime') ?? 5) * 60;
    _longBreakTimeInSeconds = (prefs.getInt('longBreakTime') ?? 15) * 60;
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _volume = prefs.getDouble('volume') ?? 1.0;
    resetTimer();
  }

  // atualiza a duração do foco e salva a preferência no dispositivo
  Future<void> updateFocusDuration(double minutes) async {
    final prefs = await SharedPreferences.getInstance();
    _focusTimeInSeconds = minutes.round() * 60;
    await prefs.setInt('focusTime', minutes.round());
    // se o timer de foco estiver pausado, atualiza o tempo atual imediatamente
    if (!_isRunning && _currentSession == 'Foco') {
      _currentTimeInSeconds = _focusTimeInSeconds;
    }
    notifyListeners();
  }

  // atualiza a duração da pausa curta e salva a preferência
  Future<void> updateShortBreakDuration(double minutes) async {
    final prefs = await SharedPreferences.getInstance();
    _shortBreakTimeInSeconds = minutes.round() * 60;
    await prefs.setInt('shortBreakTime', minutes.round());
    if (!_isRunning && _currentSession == 'Pausa Curta') {
      _currentTimeInSeconds = _shortBreakTimeInSeconds;
    }
    notifyListeners();
  }

  // atualiza a duração da pausa longa e salva a preferência
  Future<void> updateLongBreakDuration(double minutes) async {
    final prefs = await SharedPreferences.getInstance();
    _longBreakTimeInSeconds = minutes.round() * 60;
    await prefs.setInt('longBreakTime', minutes.round());
    if (!_isRunning && _currentSession == 'Pausa Longa') {
      _currentTimeInSeconds = _longBreakTimeInSeconds;
    }
    notifyListeners();
  }

  // ativa/desativa o som e salva a preferência
  Future<void> toggleSound(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = isEnabled;
    await prefs.setBool('soundEnabled', isEnabled);
    notifyListeners();
  }

  // atualiza o volume e salva a preferência
  Future<void> updateVolume(double newVolume) async {
    final prefs = await SharedPreferences.getInstance();
    _volume = newVolume;
    await prefs.setDouble('volume', newVolume);
    notifyListeners();
  }

  // formata o tempo de segundos para o formato "mm:ss"
  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // reseta completamente o estado do pomodoro para os valores de fábrica
  Future<void> fullReset() async {
    _timer?.cancel();
    _isRunning = false;
    _pomodoroCount = 0;
    _currentSession = 'Foco';

    // restaura os tempos para os valores padrão
    _focusTimeInSeconds = 25 * 60;
    _shortBreakTimeInSeconds = 5 * 60;
    _longBreakTimeInSeconds = 15 * 60;
    _soundEnabled = true;
    _volume = 1.0;

    _currentTimeInSeconds = _focusTimeInSeconds;

    // apaga todas as configurações do pomodoro salvas no dispositivo
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('focusTime');
    await prefs.remove('shortBreakTime');
    await prefs.remove('longBreakTime');
    await prefs.remove('soundEnabled');
    await prefs.remove('volume');

    notifyListeners();
  }
}
