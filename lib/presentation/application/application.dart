import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:avtotest/data/datasource/network/dto/subscription_response.dart';
import 'package:avtotest/data/datasource/network/service/subscription_service.dart';
import 'package:avtotest/data/datasource/preference/device_preferences.dart';
import 'package:avtotest/data/datasource/preference/subscription_preferences.dart';
import 'package:avtotest/data/datasource/preference/user_preferences.dart';
import 'package:avtotest/data/datasource/storage/storage.dart';
import 'package:avtotest/data/datasource/storage/storage_keys.dart';
import 'package:avtotest/data/repository/subscription/subscription_repository.dart';
import 'package:avtotest/presentation/features/education/presentation/bloc/education_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/bottom_sheet/update_app_bottom_sheet.dart';
import 'package:avtotest/presentation/features/navigation/presentation/navigation_screen.dart';
import 'package:avtotest/presentation/utils/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(
  StorageRepository.getBool(StorageKeys.isDarkMode, defValue: false),
);

class _ApplicationState extends State<Application> {
  late SubscriptionPreferences _subscriptionPreferences;
  late SubscriptionRepository _subscriptionRepository;

  final _navigatorKey = GlobalKey<NavigatorState>();

  UpdateAppInfo? _pendingUpdateInfo;
  bool _shouldShowUpdateSheet = false;

  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _subscriptionPreferences = await SubscriptionPreferences.getInstance();
      DevicePreferences devicePreferences =
          await DevicePreferences.getInstance();
      UserPreferences userPreferences = await UserPreferences.getInstance();
      Dio dio = Dio();
      SubscriptionService subscriptionService = SubscriptionService(
        dio: dio,
        devicePreferences: devicePreferences,
      );
      _subscriptionRepository = SubscriptionRepository(
        _subscriptionPreferences,
        subscriptionService,
        userPreferences,
      );

      await _checkAndLogin();
      await _initDeepLinks();
    } catch (error) {
      log('Error initializing app: $error');
      // Handle initialization error appropriately
    }
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    final uri = await _appLinks.getInitialAppLink();
    if (uri != null) {
      debugPrint('DeepLinks -> Initial URI: $uri');
      _handleUri(uri);
    }

    // For resumed/in-background
    _appLinks.uriLinkStream.listen((uri) {
      debugPrint('DeepLinks -> Streamed URI: $uri');
      _handleUri(uri);
    });
  }

  void _handleUri(Uri uri) {
    debugPrint('DeepLinks -> Handle Received URI: $uri');
    final referrerId = uri.queryParameters['referrer_id'];
    if (referrerId != null) {
      debugPrint('DeepLinks -> Handle Referrer ID: $referrerId');
      _loginWithReferrerId(referrerId);
    }
  }

  Future<void> _checkAndLogin() async {
    log('_checkAndLogin -> called');
    await _subscriptionRepository.login().then((updateAppInfo) {
      log('_checkAndLogin -> Success: updateAppInfo: $updateAppInfo');
      _showUpdateAppInfo(updateAppInfo);
    }).catchError((error) {
      log('_checkAndLogin -> Failed: error: $error');
    });
  }

  void _loginWithReferrerId(String referrerId) {
    log('_loginWithReferrerId -> Sending referrer ID to API: $referrerId');
    _subscriptionRepository
        .loginWithReferrerId(int.parse(referrerId))
        .then((updateAppInfo) {
      log('_loginWithReferrerId -> Referrer ID sent successfully');
      _showUpdateAppInfo(updateAppInfo);
    }).catchError((error) {
      log('_loginWithReferrerId -> Sending referrer ID failed: $error');
    });
  }

  void _showUpdateAppInfo(UpdateAppInfo? updateAppInfo) {
    if (updateAppInfo == null || updateAppInfo.isUpdateNotAvailable) {
      log("_showUpdateAppInfo -> is null or app update not available");
      return;
    }

    log("_showUpdateAppInfo -> Will show UpdateAppBottomSheet");
    _pendingUpdateInfo = updateAppInfo;
    _shouldShowUpdateSheet = true;

    if (mounted) {
      setState(() {});
    }
  }

  void _showPendingUpdateSheet(BuildContext context) {
    log("_showPendingUpdateSheet -> called with _shouldShowUpdateSheet: $_shouldShowUpdateSheet, _pendingUpdateInfo: $_pendingUpdateInfo");
    if (_shouldShowUpdateSheet && _pendingUpdateInfo != null) {
      _shouldShowUpdateSheet = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = _navigatorKey.currentContext;
        if (context != null && mounted) {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            isDismissible: false,
            enableDrag: false,
            builder: (context) {
              return UpdateAppBottomSheet(updateAppInfo: _pendingUpdateInfo!);
            },
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log("build -> _shouldShowUpdateSheet: $_shouldShowUpdateSheet, _pendingUpdateInfo: $_pendingUpdateInfo");
    if (_shouldShowUpdateSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPendingUpdateSheet(context);
      });
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => QuestionsSolveBloc()),
        BlocProvider(
          create: (context) => HomeBloc()
            ..add(ParseQuestionsEvent())
            ..add(LoadFontSizeEvent()),
        ),
        BlocProvider(
          create: (context) => EducationBloc()
            ..add(ParseTermsEvent())
            ..add(ParseSignMainsEvent())
            ..add(ParseSignsEvent()),
        )
      ],
      child: ValueListenableBuilder(
        valueListenable: isDarkModeNotifier,
        builder: (BuildContext context, value, Widget? child) {
          return ScreenUtilInit(
            designSize: const Size(393, 852),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              navigatorKey: _navigatorKey,
              title: 'Auto Test',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: LightTheme.theme(),
              darkTheme: DarkTheme.theme(),
              themeMode: value ? ThemeMode.dark : ThemeMode.light,
              onGenerateRoute: (_) => MaterialPageRoute<void>(builder: (_) {
                return NavigationScreen();
              }),
            ),
          );
        },
      ),
    );
  }
}
