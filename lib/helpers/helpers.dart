import 'package:url_launcher/url_launcher.dart';

void openURL (String url) async{
  final uri = Uri.parse(url.isEmpty ? 'https://google.com' : url);
  if(await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw "Không thể mở liên kết";
  }
}