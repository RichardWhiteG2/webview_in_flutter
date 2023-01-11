import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No back history item')),
              );
              return;
            }
          },
        ),/*
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No forward history item')),
              );
              return;
            }
          },
        ),*/
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Color.fromRGBO(0,174, 239, 1)),
          onPressed: () {
            controller.loadRequest(Uri.parse('https://rabbit-mx.atlassian.net/servicedesk/customer/portal/6'));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nuevo Ticket'), // <-- Text
              SizedBox(
                width: 5,
              ),
              Icon( // <-- Icon
                Icons.add,
                size: 24.0,
              ),
            ],
          ),
        ),
        /*
        TextButton(
          onPressed: () => controller.reload() , 
          child: const Text('Ticket Nuevo', style: TextStyle( color: Colors.white )), 
        ),
        IconButton(
          icon: const Icon(Icons.add_box_outlined,),
          onPressed: () {
            controller.reload();
          },
        ),*/
      ],
    );
  }
}