import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  static const String route = "LibraryScreen";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thư viện'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Khóa học yêu thích'),
              Tab(text: 'Thư viện của tôi'),
            ],
          ),
        ),
        body: TabBarView(children: [
          Center(child: Text(route)),
          Center(child: Text("route")),
        ]),
      ),
    );
  }
}
