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

      context.read<DeliveryOrderBloc>().add(ScanCodeEvent(code: code));

      _showScanResultDialog();
    }
  }

  void _showScanResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return BlocConsumer<DeliveryOrderBloc, DeliveryOrderState>(
          listener: (context, state) {},
          builder: (context, state) {
            Widget content;
            List<Widget> actions = [];
            if (state is LoadingScanCodeState) {
              content = LoadingAnimationWidget.flickr(
                leftDotColor: AppTheme.darkGray,
                rightDotColor: AppTheme.lightBlue,
                size: 30,
              );
            } else if (state is SuccessScanCodeState) {
              content = Text(_scannedCode ?? 'Code scanned');
              actions.add(
                TextButton(
                  onPressed: () {
                    context
                        .read<DeliveryOrderBloc>()
                        .add(GetOrderDetailsEvent(widget.id));
                    Navigator.pop(context);
                    Navigator.pop(context, "Code Scanned successfully");
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              );
            } else if (state is ErrorScanCodeState) {
              content = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 30),
                  const SizedBox(height: 10),
                  Text(state.message, textAlign: TextAlign.center),
                ],
              );
              actions.add(
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _isScanned = false);
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            } else {
              content = const Text('Code scanned');
            }
            return AlertDialog(
              title: const Text('Result'),
              content: content,
              actions: actions,
            );
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
