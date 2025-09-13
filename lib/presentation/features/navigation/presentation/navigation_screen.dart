import 'dart:developer';

import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_images.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/features/navigation/domain/entities/navbar.dart';
import 'package:avtotest/presentation/features/navigation/presentation/navigator.dart';
import 'package:avtotest/presentation/features/navigation/presentation/widgets/nav_bar_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

enum NavItemEnum {
  main,
  education,
  settings,
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _controller;
  GlobalKey<RefreshIndicatorState> supportRefreshKey = GlobalKey<RefreshIndicatorState>();

  final Map<NavItemEnum, GlobalKey<NavigatorState>> _navigatorKeys = {
    NavItemEnum.main: GlobalKey<NavigatorState>(),
    NavItemEnum.education: GlobalKey<NavigatorState>(),
    NavItemEnum.settings: GlobalKey<NavigatorState>(),
  };

  int _currentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    _controller = TabController(length: 3, vsync: this, animationDuration: Duration.zero, initialIndex: _currentIndex);
    _controller.addListener(onTabChange);
  }

  Future<void> requestPermission() async {
    var status = await Permission.notification.request().then((value) {
      log('Permission in home: $value');
      return value;
    });

    if (status.isGranted) {
      // _getUserLocation();
    } else {
      await Permission.notification.request();
    }
  }

  void onTabChange() => setState(() => _currentIndex = _controller.index);

  Widget _buildPageNavigator(NavItemEnum tabItem) => TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
      );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final List<NavBar> lables = [
      NavBar(
        title: Strings.main,
        id: 0,
        iconActive: AppImages.homeActive,
        iconInactive: AppImages.homeInactive,
      ),
      NavBar(
        title: Strings.education,
        id: 1,
        iconActive: AppImages.educationActive,
        iconInactive: AppImages.educationInactive,
      ),
      NavBar(
        title: Strings.settings,
        id: 2,
        iconActive: AppImages.settingsActive,
        iconInactive: AppImages.settingsInactive,
      ),
    ];
    return HomeTabControllerProvider(
      controller: _controller,
      child: PopScope(
          canPop: NavItemEnum.values[_currentIndex] == NavItemEnum.main,
          onPopInvoked: (canPop) async {
            final isFirstRouteInCurrentTab =
                !await _navigatorKeys[NavItemEnum.values[_currentIndex]]!.currentState!.maybePop();
            if (isFirstRouteInCurrentTab && NavItemEnum.values[_currentIndex] != NavItemEnum.main) {
              _controller.animateTo(0);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: Container(
              height: 60 + MediaQuery.of(context).padding.bottom,
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(.06),
                    blurRadius: 24,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: context.theme.scaffoldBackgroundColor,
                    child: TabBar(
                      onTap: (value) {
                        HapticFeedback.lightImpact();
                      },
                      indicator: const BoxDecoration(),
                      controller: _controller,
                      labelPadding: EdgeInsets.zero,
                      tabs: List.generate(
                        lables.length,
                        (index) => NavItemWidget(
                          navBar: lables[index],
                          currentIndex: _currentIndex,
                        ),
                      ),
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPageNavigator(NavItemEnum.main),
                _buildPageNavigator(NavItemEnum.education),
                _buildPageNavigator(NavItemEnum.settings),
              ],
            ),
          )),
    );
  }
}

class HomeTabControllerProvider extends InheritedWidget {
  final TabController controller;

  const HomeTabControllerProvider({
    super.key,
    required super.child,
    required this.controller,
  });

  static HomeTabControllerProvider of(BuildContext context) {
    final HomeTabControllerProvider? result = context.dependOnInheritedWidgetOfExactType<HomeTabControllerProvider>();
    assert(result != null, 'No HomeTabControllerProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(HomeTabControllerProvider oldWidget) => false;
}
