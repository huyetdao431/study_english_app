import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechButton extends StatefulWidget {
  final String text;

  const TextToSpeechButton({super.key, required this.text});

  @override
  State<TextToSpeechButton> createState() => _TextToSpeechButtonState();
}

class _TextToSpeechButtonState extends State<TextToSpeechButton> {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> _speak() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _speak,
      icon: const Icon(Icons.volume_up_outlined),
      tooltip: "Phát âm",
    );
  }
}
