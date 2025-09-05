import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';



class LocationTab extends StatefulWidget {
  const LocationTab({super.key, required this.link});
  final String link;

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    initController();
  }

  initController() {
    controller = WebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      width: 600.0,
      alignment: Alignment.center,
      child: WebViewWidget(
        controller: controller
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..enableZoom(true)
          ..loadHtmlString(widget.link),
      ),
    );
  }
}
