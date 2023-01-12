import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum _MenuOptions {
  navigationDelegate,
  userAgent,
  javascriptChannel,
  listCookies,
  clearCookies,
  addCookie,
  setCookie,
  removeCookie,
}

class Menu extends StatefulWidget {
  const Menu({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    const phoneNumber = "tel:5625549413";
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          case _MenuOptions.navigationDelegate:
            await widget.controller
                .loadRequest(Uri.parse('https://rabbit-mx.atlassian.net/servicedesk/customer/portal/6/group/21/create/80'));
            break;
          case _MenuOptions.userAgent:
            
            if (await canLaunch(phoneNumber)) {
              await launch(phoneNumber);
            } else {
              throw 'Could not launch $phoneNumber';
            }
          break;
/*
            await widget.controller
                .loadRequest(Uri.parse('https://wa.me/qr/V5MFBE62VXJRG1'));
            break;*/
          case _MenuOptions.javascriptChannel:
            await widget.controller.runJavaScript('''
var req = new XMLHttpRequest();
req.open('GET', "https://api.ipify.org/?format=json");
req.onload = function() {
  if (req.status == 200) {
    let response = JSON.parse(req.responseText);
    SnackBar.postMessage("IP Address: " + response.ip);
  } else {
    SnackBar.postMessage("Error: " + req.status);
  }
}
req.send();''');
            break;
          case _MenuOptions.clearCookies:
            await _onClearCookies();
            break;
          case _MenuOptions.listCookies:
            await _onListCookies(widget.controller);
            break;
          case _MenuOptions.addCookie:
            await _onAddCookie(widget.controller);
            break;
          case _MenuOptions.setCookie:
            await _onSetCookie(widget.controller);
            break;
          case _MenuOptions.removeCookie:
            await _onRemoveCookie(widget.controller);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.navigationDelegate,
          child: Text('Contacto'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.userAgent,
          child: Text('Llamar'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.javascriptChannel,
          child: Text('Lookup IP Address'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.clearCookies,
          child: Text('Clear cookies'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.listCookies,
          child: Text('List cookies'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.addCookie,
          child: Text('Add cookie'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.setCookie,
          child: Text('Set cookie'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.removeCookie,
          child: Text('Remove cookie'),
        ),
      ],
    );
  }

  Future<void> _onListCookies(WebViewController controller) async {
    final String cookies = await controller
        .runJavaScriptReturningResult('document.cookie') as String;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cookies.isNotEmpty ? cookies : 'There are no cookies.'),
      ),
    );
  }

  Future<void> _onClearCookies() async {
    final hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There were no cookies to clear.';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> _onAddCookie(WebViewController controller) async {
    await controller.runJavaScript('''var date = new Date();
    date.setTime(date.getTime()+(30*24*60*60*1000));
    document.cookie = "FirstName=John; expires=" + date.toGMTString();''');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie added.'),
      ),
    );
  }

  Future<void> _onSetCookie(WebViewController controller) async {
    await cookieManager.setCookie(
      const WebViewCookie(name: 'foo', value: 'bar', domain: 'flutter.dev'),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie is set.'),
      ),
    );
  }

  Future<void> _onRemoveCookie(WebViewController controller) async {
    await controller.runJavaScript(
        'document.cookie="FirstName=John; expires=Thu, 01 Jan 1970 00:00:00 UTC" ');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie removed.'),
      ),
    );
  }

}