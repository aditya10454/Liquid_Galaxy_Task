import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HTMLBubbleScreen extends StatelessWidget {
  final String cityName;
  final String yourName;

  HTMLBubbleScreen({required this.cityName, required this.yourName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HTML Bubble'),
      ),
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _loadHTML(webViewController);
        },
      ),
    );
  }

  void _loadHTML(WebViewController webViewController) {
    String htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body {
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-color: #f0f0f0;
          }
          .bubble {
            padding: 20px;
            background-color: #3498db;
            color: #fff;
            border-radius: 10px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
          }
        </style>
      </head>
      <body>
        <div class="bubble">
          <div>${cityName}</div>
          <div>${yourName}</div>
        </div>
      </body>
      </html>
    ''';

    webViewController.loadUrl(Uri.dataFromString(
      htmlContent,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString());
  }
}

void main() {
  runApp(MaterialApp(
    home: HTMLBubbleScreen(
      cityName: 'Kanpur', // Replace with the actual city name
      yourName: 'Aditya Ranjan', // Replace with your actual name
    ),
  ));
}
