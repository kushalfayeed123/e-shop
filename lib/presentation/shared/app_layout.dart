import 'package:eshop/presentation/shared/models/side_nav_item.model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    text: 'Inventory',
    icon: "products.png",
    isActive: false,
  ),
  SideNavItem(
    text: 'Settings',
    icon: "settings.png",
    isActive: false,
  ),
];

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
  @override
  void initState() {
    super.initState();
    fetchData(true);

    sideNavItems
        .firstWhere(
          (e) => e.text == 'Dashboard',
          orElse: () => SideNavItem(text: '', icon: '', isActive: false),
        )
        .isActive = true;
  }

  void fetchData(bool fetchLocation) async {
    try {
      // await ref
      //     .read<Dashboard>(dashboardProvider.notifier)
      //     .fetchDashboardData();
      // await ref.read<Dashboard>(dashboardProvider.notifier).getUserLocation();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: screenWidth * 0.24,
                height: screenHeight,
                padding: const EdgeInsets.only(
                    top: 40, bottom: 10, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
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
                                .copyWith(
                                    fontSize: 32, fontWeight: FontWeight.w800),
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
                                        width: screenWidth * 0.2,
                                        height: 55,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                            color: (e.isActive ?? false)
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Colors.transparent,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                                'assets/images/${e.icon}',
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
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: (e.isActive ??
                                                                false)
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Image.asset(
                                'assets/images/user.png',
                                width: 25,
                              ),
                              radius: 25,
                              backgroundColor: Colors.blueGrey,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jace Vibes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Admin',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 80,
                          width: screenWidth * 0.5,
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
                      ],
                    )
                  ],
                ),
              ),
              Expanded(child: widget.navigationShell),
            ],
          ),
        ),
      ),
    );
  }

  _goBranch(int index, WidgetRef ref) {
    fetchData(false);
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );

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
}
