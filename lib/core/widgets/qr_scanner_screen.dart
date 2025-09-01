import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/order/delivery_order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class QRScannerPage extends StatefulWidget {
  final int id;
  const QRScannerPage({super.key, required this.id});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  bool _isScanned = false;
  String? _scannedCode;

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;

    final String? code = capture.barcodes.firstOrNull?.rawValue;
    if (code != null) {
      _isScanned = true;
      _scannedCode = code;

      _showNoteDialog(code);
    }
  }

  void _showNoteDialog(String code) {
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: TextField(
            controller: noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter a note (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _isScanned = false); // allow rescanning
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<DeliveryOrderBloc>().add(
                      ScanCodeEvent(
                          code: code,
                          note: noteController.text.trim().isEmpty
                              ? null
                              : noteController.text.trim()),
                    );
                _showScanResultDialog();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showScanResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return BlocConsumer<DeliveryOrderBloc, DeliveryOrderState>(
          listener: (context, state) {
            if (state is SuccessScanCodeState) {
              // ✅ Do Bloc stuff immediately on success
              context
                  .read<DeliveryOrderBloc>()
                  .add(GetOrderDetailsEvent(widget.id));
              Navigator.pop(context); // Close the dialog
              Navigator.pop(
                  context, "Code Scanned successfully"); // Pop scanner page
            }
          },
          builder: (context, state) {
            if (state is LoadingScanCodeState) {
              return AlertDialog(
                title: const Text('Processing...'),
                content: LoadingAnimationWidget.flickr(
                  leftDotColor: AppTheme.darkGray,
                  rightDotColor: AppTheme.lightBlue,
                  size: 30,
                ),
              );
            } else if (state is ErrorScanCodeState) {
              return AlertDialog(
                title: const Text('Error'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 30),
                    const SizedBox(height: 10),
                    Text(state.message, textAlign: TextAlign.center),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      setState(() => _isScanned = false); // Allow rescanning
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            }
            // Show nothing if not loading or error
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: _onDetect,
      ),
    );
  }
}
