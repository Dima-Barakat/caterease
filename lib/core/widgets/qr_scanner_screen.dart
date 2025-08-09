import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  bool _isScanned = false;

  void _onDetect(BarcodeCapture capture) async {
    if (_isScanned) return; // prevent multiple triggers
    final List<Barcode> barcodes = capture.barcodes;
    final String? code = barcodes.firstOrNull?.rawValue;

    if (code != null) {
      _isScanned = true;

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('تم مسح الرمز'),
          content: Text(code),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('موافق', style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ],
        ),
      );
      if (mounted) {
        Navigator.pop(context, code); // return to previous screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مسح رمز QR')),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: _onDetect,
      ),
    );
  }
}
