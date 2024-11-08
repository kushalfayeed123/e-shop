import 'package:eshop/presentation/shared/models/side_nav_item.model.dart';
import 'package:eshop/state/providers/auth/auth.provider.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:eshop/state/providers/user/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

List<SideNavItem> sideNavItems = [
  SideNavItem(
    text: 'Dashboard',
    icon: "dashboard.png",
    isActive: false,
  ),
  SideNavItem(
    text: 'Orders',
    icon: "order.png",
    isActive: false,
  ),
  SideNavItem(
    text: 'Products',
    icon: "products.png",
    isActive: false,
  ),
  // SideNavItem(
  //   text: 'Settings',
  //   icon: "settings.png",
  //   isActive: false,
  // ),
];

class AppSidenav extends ConsumerStatefulWidget {
  final Function fetchData;
  final Function closeNav;
  final StatefulNavigationShell navigationShell;
  const AppSidenav({
    super.key,
    required this.fetchData,
    required this.navigationShell,
    required this.closeNav,
  });

  @override
  ConsumerState<AppSidenav> createState() => _AppSidenavState();
}

class _AppSidenavState extends ConsumerState<AppSidenav> {
  void signOut() async {
    await ref.watch(authStateProvider.notifier).signOut();
    if (mounted) {
      context.go('/login');
    }
  }

  _goBranch(int index, WidgetRef ref) async {
    switch (index) {
      case 0:
        widget.fetchData();
      case 1:
        await ref.read(transactionStateProvider.notifier).getTransactions();
        break;
      case 2:
        await ref.read(productStateProvider.notifier).getProducts();
      default:
    }

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    widget.closeNav();

    setState(() {
      for (var element in sideNavItems) {
        if (element == sideNavItems[index]) {
          element.isActive = true;
        } else {
          element.isActive = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateProvider).value;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
          ? screenWidth * 0.24
          : screenWidth * 0.75,
      height: screenHeight,
      padding: EdgeInsets.only(
        top: 40,
        bottom: 10,
        left: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 20 : 5,
        right: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 20 : 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4), // Slightly lighter shadow
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4), // Position of the shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  'Vibes Wine',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 32, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                  children: sideNavItems
                      .map((e) => InkWell(
                            onTap: () {
                              final index = sideNavItems.indexOf(e);
                              _goBranch(index, ref);
                            },
                            child: Container(
                              width: ResponsiveBreakpoints.of(context)
                                      .largerThan(MOBILE)
                                  ? screenWidth * 0.2
                                  : screenWidth,
                              height: 55,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: (e.isActive ?? false)
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/${e.icon ?? ''}',
                                      height: 20,
                                      width: 20,
                                      color: (e.isActive ?? false)
                                          ? Colors.black
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 155,
                                    child: Text(
                                      e.text ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: (e.isActive ?? false)
                                                  ? Colors.black
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blueGrey,
                      child: Image.asset(
                        'assets/images/user.png',
                        width: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userState?.currentUser?.name ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(userState?.currentUser?.role ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 12)),
                      ],
                    )
                  ],
                ),
                InkWell(
                  onTap: () => signOut(),
                  child: SizedBox(
                    height: 80,
                    width: screenWidth * 0.5,
                    child: Center(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/sign-out.png',
                            width: 20,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Logout',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}