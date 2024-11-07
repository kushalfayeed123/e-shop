import 'package:eshop/presentation/shared/models/side_nav_item.model.dart';
import 'package:eshop/presentation/shared/widgets/app_sidenav.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:eshop/state/providers/user/user.provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppLayout extends ConsumerStatefulWidget {
  const AppLayout({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('AppLayout'));
  final StatefulNavigationShell navigationShell;
  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  bool showNav = false;

  @override
  void initState() {
    super.initState();
    fetchData();

    sideNavItems
        .firstWhere(
          (e) => e.text == 'Dashboard',
          orElse: () => SideNavItem(text: '', icon: '', isActive: false),
        )
        .isActive = true;
  }

  void fetchData() async {
    try {
      await ref.read(userStateProvider.notifier).getCurrentUser();
      await ref.read(productStateProvider.notifier).getProducts();
      await ref.read(transactionStateProvider.notifier).getTransactions();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(userStateProvider);
    ref.watch(productStateProvider);
    ref.watch(transactionStateProvider);
  }

  void toggleSideNav() {
    showNav = !showNav;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppSidenav(
                      fetchData: () => fetchData(),
                      closeNav: () {
                        showNav = false;
                        setState(() {});
                      },
                      navigationShell: widget.navigationShell,
                    ),
                    Expanded(child: widget.navigationShell),
                  ],
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: InkWell(
                                onTap: () => toggleSideNav(),
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF363636),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Center(
                                    child: Icon(
                                      showNav
                                          ? Icons.close
                                          : Icons.menu_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(child: widget.navigationShell),
                      ],
                    ),
                    showNav
                        ? AppSidenav(
                            fetchData: () => fetchData(),
                            navigationShell: widget.navigationShell,
                            closeNav: () {
                              showNav = false;
                              setState(() {});
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
        ),
      ),
    );
  }
}
