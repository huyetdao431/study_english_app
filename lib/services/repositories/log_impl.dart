import 'package:study_english_app/services/repositories/log.dart';

class LogImplement implements Log {
  @override
  void d(String tag, String message) {
    print('[$tag] $message');
  }

  @override
  void e(String tag, String message) {
    print('[Error] [$tag] $message');
  }

  @override
  void i(String tag, String message) {
    print('[$tag] $message');
  }
  
}