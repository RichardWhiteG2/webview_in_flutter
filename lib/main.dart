import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';  // ADD

import 'src/menu.dart';                                 // ADD
import 'src/navigation_controls.dart';                  // ADD
import 'src/web_view_stack.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://rabbit-mx.atlassian.net/servicedesk/customer/portal/6'),
      );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de Servicios IT'),
        backgroundColor: Color.fromRGBO(2, 119, 217, 1),
        actions: [
          NavigationControls(controller: controller),
          Menu(controller: controller), 
        ],
      ),
      body: WebViewStack(controller: controller),       // MODIFY
    );

  }
}