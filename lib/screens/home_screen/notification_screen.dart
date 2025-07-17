import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const String route = 'NotificationScreen';

  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông báo')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NotificationLabel(
              title: 'Thông báo hệ thống',
              content: 'Bạn có khóa học mới được thêm',
              detail:
              'Khóa học "Tiếng Anh Giao Tiếp A1" đã được thêm vào thư viện của bạn lúc 12:00 ngày 15/07.',
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationLabel extends StatefulWidget {
  final String title;
  final String content;
  final String detail;

  const NotificationLabel({
    super.key,
    required this.title,
    required this.content,
    required this.detail,
  });

  @override
  State<NotificationLabel> createState() => _NotificationLabelState();
}

class _NotificationLabelState extends State<NotificationLabel> {
  bool _isExpanded = false;
  bool _isRead = false;

  void _toggleExpand() {
    setState(() {
      if (!_isRead) _isRead = true; // đánh dấu đã đọc
      _isExpanded = !_isExpanded;
    });

    // Tự động đóng sau khi xem xong
    if (_isExpanded) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isExpanded = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _isRead ? Colors.white : Colors.blue[50],
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: _isRead ? Colors.grey.shade300 : Colors.blue.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: _toggleExpand,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: TextStyle(
                              fontWeight: _isRead ? FontWeight.normal : FontWeight.bold,
                              fontSize: 16,
                            )),
                        const SizedBox(height: 4),
                        Text(widget.content,
                            style: TextStyle(
                              color: Colors.grey[700],
                            )),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.navigate_next,
                    color: _isRead ? Colors.grey : Colors.blue,
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(widget.detail),
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
