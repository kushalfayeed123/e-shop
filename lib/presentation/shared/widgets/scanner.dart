import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Scanner extends StatefulWidget {
  final void Function(BarcodeCapture) onScanned;

  const Scanner({super.key, required this.onScanned});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with WidgetsBindingObserver {
  late MobileScannerController controller;

  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();

    controller = MobileScannerController(
      facing: CameraFacing.back,
      returnImage: true,
    );
    _subscription = controller.barcodes.listen(_handleBarcode);
    unawaited(controller.start());

    setState(() {});
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    controller.dispose();
    super.dispose();
  }

  _handleBarcode(value) {
    widget.onScanned(value);
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns:
          ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 3 : 0,
      child: MobileScanner(
        controller: controller,
        onDetect: (value) => _handleBarcode,
      ),
    );
  }
}
