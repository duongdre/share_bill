import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../services/app_services/ad_service.dart';

class DebugAdWidget extends StatefulWidget {
  const DebugAdWidget({super.key});

  @override
  State<DebugAdWidget> createState() => _DebugAdWidgetState();
}

class _DebugAdWidgetState extends State<DebugAdWidget> {
  String _adStatus = '';

  @override
  void initState() {
    super.initState();
    _updateAdStatus();

    // Update status every 2 seconds
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        _updateAdStatus();
      } else {
        timer.cancel();
      }
    });
  }

  void _updateAdStatus() {
    setState(() {
      _adStatus = AdService().adStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode
    if (!kDebugMode) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🧪 AD DEBUG PANEL',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // Ad Status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _adStatus,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Test Buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTestButton(
                'Test Interstitial',
                Colors.blue,
                    () => AdService().triggerTestAd(),
              ),
              _buildTestButton(
                'Reload Ads',
                Colors.orange,
                    () => AdService().forceReloadAds(),
              ),
              _buildTestButton(
                'Add Bill',
                Colors.green,
                    () => AdService().onBillAdded(),
              ),
              _buildTestButton(
                'Navigate',
                Colors.purple,
                    () => AdService().onScreenNavigation(),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            '💡 Tip: Add 2 bills or navigate 3 times to trigger ads automatically',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          textStyle: const TextStyle(fontSize: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}