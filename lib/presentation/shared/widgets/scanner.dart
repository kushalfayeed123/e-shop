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
    WidgetsBinding.instance.addObserver(this);

    controller = MobileScannerController(
      facing: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
          ? CameraFacing.front
          : CameraFacing.back,
      returnImage: true,
    );
    _subscription?.cancel(); // Cancel any existing subscription
    _subscription = controller.barcodes.listen(_handleBarcode);
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      controller.start();
    } else if (state == AppLifecycleState.paused) {
      controller.stop();
    }
  }

  void _handleBarcode(BarcodeCapture value) {
    if (mounted) {
      widget.onScanned(value);
    }
  }

  void _switchCamera() {
    controller.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RotatedBox(
          quarterTurns:
              ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 3 : 0,
          child: MobileScanner(
            controller: controller,
            onDetect: _handleBarcode,
          ),
        ),
        Positioned.fill(
          bottom: 20,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                onPressed: () => _switchCamera(),
                icon: Icon(
                  Icons.cameraswitch_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
