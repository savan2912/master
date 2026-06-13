import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StoreWebview extends StatefulWidget {
  final String? url;
  final String? title;
  final bool isInsideBottomBar; // Tame screen frame navigate karo tyre aa check true muki sako

  const StoreWebview({
    super.key,
    this.url = "http://store.gotilo.net/",
    this.title = "Store",
    this.isInsideBottomBar = true, // By default true rakhyu jethi bottom bar safe offset automatic re
  });

  @override
  State<StoreWebview> createState() => _StoreWebviewState();
}

class _StoreWebviewState extends State<StoreWebview> {
  late final WebViewController _controller;
  int loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  void initWebView() {
    String finalUrl = (widget.url ?? "http://store.gotilo.net/").trim();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            log("WebView Loading Started: $url");
            if (mounted) setState(() => loadingPercentage = 0);
          },
          onProgress: (int progress) {
            if (mounted) setState(() => loadingPercentage = progress);
          },
          onPageFinished: (String url) {
            log("WebView Loading Finished!");
            if (mounted) setState(() => loadingPercentage = 100);
          },
          onWebResourceError: (WebResourceError error) {
            log("WebView Error Domain: ${error.errorType}");
            log("WebView Error Code: ${error.errorCode}");
            log("WebView Description: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(finalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFDFDFD),
        centerTitle: true,
        // Leading back arrow remove karvo hoy to tame validation check muki sako, jo bottom bar tab hoy to back button hide thai jay
        leading: widget.isInsideBottomBar
            ? null
            : IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 18),
          onPressed: () async {
            if (await _controller.canGoBack()) {
              await _controller.goBack();
            } else {
              if (context.mounted) Navigator.pop(context);
            }
          },
        ),
        title: Text(
          (widget.title ?? "Store").toUpperCase(),
          style: GoogleFonts.montserrat(
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
            fontSize: 14,
            color: const Color(0xFF0D1B1E),
          ),
        ),
        bottom: loadingPercentage < 100
            ? PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: LinearProgressIndicator(
            value: loadingPercentage / 100.0,
            backgroundColor: Colors.grey.shade200,
            color: const Color(0xFF6C63FF),
            minHeight: 3,
          ),
        )
            : null,
      ),
      // Column approach sathe dynamic spacer height buffer muki didhu boss
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (await _controller.canGoBack()) {
            await _controller.goBack();
          } else {
            if (!widget.isInsideBottomBar && context.mounted) {
              Navigator.pop(context);
            }
          }
        },
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(controller: _controller), // Main site frame loader viewport
            ),

            if (widget.isInsideBottomBar)
              SizedBox(height: MediaQuery.of(context).padding.bottom + 65), // Bottom Navigation height control match spacing
          ],
        ),
      ),
    );
  }
}