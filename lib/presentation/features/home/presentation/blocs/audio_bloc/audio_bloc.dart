import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class AudioBloc extends Cubit<AudioPlayer> {
  final AudioPlayer _player = AudioPlayer();

  AudioBloc() : super(AudioPlayer());

  AudioPlayer get player => _player;

  Future<void> play(String url) async {
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
