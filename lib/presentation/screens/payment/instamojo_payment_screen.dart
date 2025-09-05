import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../routes/route_names.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';


class InstamojoPaymentScreen extends StatefulWidget {
  const InstamojoPaymentScreen({super.key, required this.url});
  final Uri url;

  @override
  State<InstamojoPaymentScreen> createState() => _InstamojoPaymentState();
}

class _InstamojoPaymentState extends State<InstamojoPaymentScreen> {
  double value = 0.0;

  bool _canRedirect = true;

  bool _isLoading = true;

  late WebViewController controllerGlobal;

  @override
  void initState() {
    initializeController();
    super.initState();
  }

  void initializeController() {
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    controllerGlobal = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1')
      //..setBackgroundColor(redColor)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          setState(() {
            value = progress / 100;
          });
          log("WebView is loading (progress : $progress%)");
        },
        onPageStarted: (String url) {
          log('Page started loading: $url');
          setState(() {
            _isLoading = true;
          });
          log("printing urls $url");
          _redirect(url);
        },
        onPageFinished: (String url) {
          log('Page finished loading: $url');
          setState(() {
            _isLoading = false;
          });
          _redirect(url);
        },
      ))
      ..loadRequest(widget.url,
          method: LoadRequestMethod.get, headers: header);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Instamojo Payment')),
      body: Column(
        children: [
          if (_isLoading)
            Center(
              child: LinearProgressIndicator(
                value: value,
              ),
            ),
          Expanded(child: WebViewWidget(controller: controllerGlobal)),
        ],
      ),
    );
  }

  void _redirect(String url) {
    if (_canRedirect) {
      bool isSuccess = url.contains('/webview-success-payment') &&
          url.contains(RemoteUrls.rootUrl);
      bool isFailed = url.contains('fail') && url.contains(RemoteUrls.rootUrl);
      bool isCancel = url.contains('/order-fail-url-for-mobile-app') &&
          url.contains(RemoteUrls.rootUrl);
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
      }
      if (isSuccess) {
        getData();
      } else if (isFailed || isCancel) {
        Utils.errorSnackBar(context, 'Payment Failed');
        Navigator.pop(context);
        return;
      } else {
        log("Encountered problem");
        goToPage();
      }
    }
  }

  Future<void> getData() async {
    try {
      Object? result = await controllerGlobal.runJavaScriptReturningResult('''
      (function() {
        if (!document.body) return null;
        return document.body.innerText;
      })();
    ''');

      log("Raw data from WebView: $result");

      if (result.toString().trim().isEmpty) {
        throw FormatException("WebView returned no data");
      }

      String rawJson = result.toString();

      if (rawJson.startsWith('"') && rawJson.endsWith('"')) {
        rawJson = rawJson.substring(1, rawJson.length - 1);
        rawJson = rawJson.replaceAll(r'\"', '"');
      }

      dynamic decoded = jsonDecode(rawJson);

      if (decoded is! Map<String, dynamic>) {
        throw FormatException("Decoded response is not a valid JSON object");
      }

      final responseJSON = decoded;
      log("Decoded JSON: $responseJSON", name: 'InstamojoPaymentScreen');

      final status = responseJSON['status'];
      final message = responseJSON['message'] ?? "No message";

      if (status == 'success') {
        getMessage(message);
      } else {
        getMessage(message, false);
      }
    } catch (e, t) {
      debugPrint('Caught error in getData: $e');
      debugPrintStack(stackTrace: t);
    } finally {
      debugPrint('enter-finally-block');
      goToPage();
    }
  }

  void goToPage(){

    if(widget.url.toString().contains('wallet-api-payment')){
      debugPrint('wallet-payment-success');
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.walletScreen,
              (route) {
            if (route.settings.name == RouteNames.mainScreen) {
              return true;
            } else {
              return false;
            }
          });
    }else  if(widget.url.toString().contains('subscription-api')){
      debugPrint('subscription-payment-success');
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.subsHistoryScreen,
              (route) {
            if (route.settings.name == RouteNames.mainScreen) {
              return true;
            } else {
              return false;
            }
          });
    }else{
      debugPrint('service-payment-success');
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.buyerSellerOrderScreen,
              (route) {
            if (route.settings.name == RouteNames.mainScreen) {
              return true;
            } else {
              return false;
            }
          },arguments: 'success');
    }
  }

  void getMessage(String message,[bool isSuccess = true]){
    if(isSuccess){
      Utils.showSnackBar(context, message);
    }else{
      Utils.errorSnackBar(context, message);
    }

  }
}
