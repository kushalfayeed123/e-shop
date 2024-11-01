import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppButton extends StatelessWidget {
  final bool isActive;
  final Color background;
  final Function action;
  final Color textColor;
  final String text;
  final String? subText;
  final bool hasBorder;
  final double elevation;
  final bool? isLoading;
  final bool isFullWidth;
  final double height;

  const AppButton(
      {super.key,
      required this.isActive,
      required this.background,
      required this.action,
      required this.textColor,
      required this.text,
      required this.hasBorder,
      required this.elevation,
      this.isFullWidth = true,
      this.height = 48,
      this.isLoading = false,
      this.subText = ''});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive
          ? () {
              action();
            }
          : () {},
      child: Material(
          borderRadius: BorderRadius.circular(1000),
          elevation: elevation,
          child: FittedBox(
            child: Container(
              width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                  ? MediaQuery.of(context).size.width * 0.2
                  : null,
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: !isActive ? background.withOpacity(0.5) : background,
                  border: hasBorder
                      ? Border.all(color: Theme.of(context).colorScheme.primary)
                      : null),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: textColor, fontSize: 24),
                        ),
                        (subText ?? '').isNotEmpty
                            ? Text(
                                ' - ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: const Color(0xFFCCCCCC)),
                              )
                            : const SizedBox.shrink(),
                        (subText ?? '').isNotEmpty
                            ? Text(
                                subText ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: const Color(0xFFCCCCCC)),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    if (isLoading ?? false)
                      const SizedBox(
                        width: 15,
                      ),
                    isLoading ?? false
                        ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              backgroundColor: textColor,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
