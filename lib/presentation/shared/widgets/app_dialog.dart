import 'package:eshop/presentation/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppDialog {
  // static Future<void> showLoading(BuildContext context,
  //     [String message = '']) async {
  //   await Navigator.of(context).push(Loader(message));
  // }

  static Future showLoading(BuildContext context, [String message = '']) async {
    showDialog(
        barrierDismissible: false,
        useRootNavigator: true,
        context: context,
        builder: (_) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitDoubleBounce(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50.0,
                  ),
                ],
              ),
            ));
  }

  static hideLoading(BuildContext context) {
    context.pop();
  }

  static Future showErrorDialog(BuildContext context, String error,
      {String? title}) async {
    showDialog(
        barrierDismissible: false,
        useRootNavigator: true,
        context: context,
        builder: (_) => SizedBox(
              width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                  ? MediaQuery.of(context).size.width * 0.4
                  : MediaQuery.of(context).size.width,
              child: AlertDialog(
                icon: Image.asset(
                  'assets/images/danger.png',
                  width: 74,
                  height: 74,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title ?? 'Error',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 30),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.width,
                  child: Text(error,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          height: 1.3,
                          fontSize: 24)),
                ),
                actions: [
                  SizedBox(
                    width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                        ? MediaQuery.of(context).size.width * 0.5
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                            isActive: true,
                            background: Theme.of(context).colorScheme.primary,
                            action: () {
                              context.pop();
                            },
                            textColor: Colors.black,
                            text: 'OK',
                            hasBorder: false,
                            elevation: 0)
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  static Future showSuccessDialog(BuildContext context, String message,
      {Function? action, String? title}) async {
    showDialog(
        barrierDismissible: false,
        useRootNavigator: true,
        context: context,
        builder: (_) => AlertDialog(
              icon: Image.asset(
                'assets/images/verified.png',
                width: 74,
                height: 74,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title ?? 'Success!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
              content: SizedBox(
                width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width,
                child: Text(message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        height: 1.3,
                        fontSize: 24)),
              ),
              actions: [
                SizedBox(
                  width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                          isActive: true,
                          background: Theme.of(context).colorScheme.primary,
                          action: () {
                            if (action != null) {
                              action();
                            } else {
                              context.pop();
                            }
                          },
                          textColor: Colors.black,
                          text: 'OK',
                          hasBorder: false,
                          elevation: 0)
                    ],
                  ),
                )
              ],
            ));
  }

  static Future customDialog(
    BuildContext context, {
    Function? confirmAction,
    Function? cancelAction,
    String? confirmText,
    String? cancelText,
    required String imagePath,
    required String title,
    String? message,
  }) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
              icon: Image.asset(
                imagePath,
                width: 74,
                height: 74,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
              content: Text(message ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      height: 1.3)),
              actions: [
                if (cancelText != null)
                  AppButton(
                      isActive: true,
                      background: Colors.transparent,
                      action: () {
                        cancelAction != null && cancelAction();
                        context.pop();
                      },
                      textColor: Theme.of(context).colorScheme.primary,
                      text: cancelText,
                      hasBorder: true,
                      elevation: 10),
                if (confirmText != null)
                  AppButton(
                      isActive: true,
                      background: Theme.of(context).colorScheme.primary,
                      action: () {
                        confirmAction != null && confirmAction();
                        context.pop();
                      },
                      textColor: Colors.black,
                      text: confirmText,
                      hasBorder: false,
                      elevation: 0),
              ]
                  .expand((element) => [
                        const SizedBox(
                          height: 10,
                        ),
                        element
                      ])
                  .toList(),
            ));
  }

  static Future showInfoDialog(BuildContext context, String info, String title,
      Function dialogAction, String dialogActionText) async {
    showDialog(
        barrierDismissible: false,
        useRootNavigator: true,
        context: context,
        builder: (_) => SizedBox(
              width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                  ? MediaQuery.of(context).size.width * 0.4
                  : MediaQuery.of(context).size.width,
              child: AlertDialog(
                backgroundColor: Colors.black,
                insetPadding: EdgeInsets.symmetric(
                    horizontal:
                        ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                            ? 100
                            : 20),
                icon: Image.asset(
                  'assets/images/warning.png',
                  width: 74,
                  height: 74,
                ),
                title: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30,
                      height: 1.3),
                ),
                content: SizedBox(
                  width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                      ? MediaQuery.of(context).size.width * 0.4
                      : MediaQuery.of(context).size.width,
                  child: Text(info,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          height: 1.3,
                          wordSpacing: 0.1,
                          fontSize: 24)),
                ),
                actions: [
                  SizedBox(
                    width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                            isActive: true,
                            background: Colors.black,
                            action: () {
                              context.pop();
                            },
                            textColor: Theme.of(context).colorScheme.primary,
                            text: 'Close',
                            hasBorder: true,
                            isFullWidth: false,
                            elevation: 10),
                        const SizedBox(
                          width: 10,
                        ),
                        dialogActionText.isNotEmpty
                            ? AppButton(
                                isActive: true,
                                background:
                                    Theme.of(context).colorScheme.primary,
                                isFullWidth: false,
                                action: () {
                                  dialogAction();
                                },
                                textColor: Colors.black,
                                text: dialogActionText,
                                hasBorder: false,
                                elevation: 0)
                            : const SizedBox.shrink()
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
}

class Loader extends ModalRoute<void> {
  final String message;

  Loader(this.message);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitDoubleBounce(
            color: Theme.of(context).colorScheme.primary,
            size: 50.0,
          ),
        ],
      ),
    );
  }
}
