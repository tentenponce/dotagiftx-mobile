import 'dart:async';

import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserDetailWebviewView extends StatefulWidget {
  final String url;
  final String title;

  const UserDetailWebviewView({
    required this.url,
    required this.title,
    super.key,
  });

  @override
  State<UserDetailWebviewView> createState() => _UserDetailWebviewViewState();
}

class _UserDetailWebviewViewState extends State<UserDetailWebviewView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // To balance the close button
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: WebViewWidget(
                    controller: _controller,
                    gestureRecognizers:
                        const <Factory<OneSequenceGestureRecognizer>>{
                          Factory<VerticalDragGestureRecognizer>(
                            VerticalDragGestureRecognizer.new,
                          ),
                          Factory<HorizontalDragGestureRecognizer>(
                            HorizontalDragGestureRecognizer.new,
                          ),
                          Factory<ScaleGestureRecognizer>(
                            ScaleGestureRecognizer.new,
                          ),
                        },
                  ),
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(_initWebView());
  }

  Future<void> _initWebView() async {
    _controller = WebViewController();

    await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _controller.setBackgroundColor(const Color(0x00000000));
    await _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          setState(() {
            _isLoading = true;
          });
        },
        onPageFinished: (String url) {
          setState(() {
            _isLoading = false;
          });
        },
      ),
    );

    // Enable scrolling and touch interactions
    await _controller.enableZoom(true);

    await _controller.loadRequest(Uri.parse(widget.url));
  }
}
