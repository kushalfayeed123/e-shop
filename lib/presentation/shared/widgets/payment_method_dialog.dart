import 'package:flutter/material.dart';

class PaymentMethodDialog {
  static Future<void> showPaymentMethodDialog(
    BuildContext context, {
    Function(String)? onConfirm,
    Function? onCancel,
  }) async {
    String? selectedPaymentMethod;

    await showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => SizedBox(
          width: MediaQuery.of(context).size.width > 600
              ? MediaQuery.of(context).size.width * 0.4
              : MediaQuery.of(context).size.width,
          child: AlertDialog(
            backgroundColor: Colors.black,
            insetPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 100 : 20),
            title: Text(
              'Select Payment Method',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    height: 1.3,
                  ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedPaymentMethod,
                  hint: Text(
                    'Choose payment method',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white70),
                  ),
                  dropdownColor: Colors.grey[850],
                  items: ['Card', 'Cash', 'Transfer'].map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(
                        method,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width > 600
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (onCancel != null) {
                          onCancel();
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: selectedPaymentMethod != null
                          ? () {
                              if (onConfirm != null) {
                                onConfirm(selectedPaymentMethod!);
                              }
                              Navigator.pop(context);
                            }
                          : null,
                      style: TextButton.styleFrom(
                        backgroundColor: selectedPaymentMethod != null
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                      child: Text(
                        'Confirm',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
