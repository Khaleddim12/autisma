import 'package:flutter_sound/public/flutter_sound_recorder.dart';

import 'package:permission_handler/permission_handler.dart';

int counter = 0;
String audio_path = 'audio_example$counter.aac';

class SoundRecorder {
  FlutterSoundRecorder? _recorder;
  bool _isRecorderInitialized = false;
  bool get isRecording => _recorder!.isRecording;
  Future _record() async {
    if (!_isRecorderInitialized) return;
    counter++;
    audio_path = 'audio_example$counter.aac';

    await _recorder!.startRecorder(toFile: audio_path);
    print(audio_path);
  }

  Future _stop() async {
    if (!_isRecorderInitialized) return;
    await _recorder!.stopRecorder();
  }

  Future toggleRecorder() async {
    if (_recorder!.isStopped)
      await _record();
    else
      await _stop();
  }

  Future init() async {
    _recorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone Permission Required');
    }
    await _recorder!.openAudioSession();
    _isRecorderInitialized = true;
  }

  void dispose() {
    if (!_isRecorderInitialized) return;
    _recorder!.closeAudioSession();
    _recorder = null;
    _isRecorderInitialized = false;
  }
}
