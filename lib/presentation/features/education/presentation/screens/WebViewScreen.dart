import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../core/assets/colors/app_colors.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final String title;

  const WebViewScreen({
    super.key,
    required this.url,
    this.title = "Web Page",
  });

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.black, // matn rangi
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white, // AppBar orqa fon rangi
        iconTheme: const IconThemeData(color: Colors.black), // back tugma rangi
      ),

      body: WebViewWidget(controller: controller),
    );
  }
}
