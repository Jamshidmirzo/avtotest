import 'dart:developer';

import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/extensions/date_extensions.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/data/datasource/preference/subscription_preferences.dart';
import 'package:avtotest/data/datasource/preference/user_preferences.dart';
import 'package:avtotest/data/datasource/storage/storage.dart';
import 'package:avtotest/data/datasource/storage/storage_keys.dart';
import 'package:avtotest/domain/model/language/language.dart';
import 'package:avtotest/presentation/features/settings/bottom_sheet/premium_bottom_sheet_in_settings.dart';
import 'package:avtotest/presentation/features/settings/firestore.dart';
import 'package:avtotest/presentation/features/settings/widgets/animated_arrow_widget.dart';
import 'package:avtotest/presentation/features/settings/firestore.dart';
import 'package:avtotest/presentation/features/settings/widgets/animated_arrow_widget.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/application/application.dart';
import 'package:avtotest/presentation/widgets/w_divider.dart';
import 'package:avtotest/presentation/features/settings/bottom_sheet/font_size_bottom_sheet.dart';
import 'package:avtotest/presentation/features/settings/bottom_sheet/language_bottom_sheet.dart';
import 'package:avtotest/presentation/features/settings/widgets/settings_item_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:avtotest/core/services/notification_service.dart';
import 'package:avtotest/data/datasource/di/service_locator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SubscriptionPreferences? _subscriptionPreferences;
  UserPreferences? _userPreferences;
  bool _isLoading = true;
  Stream<DocumentSnapshot>? _userStream;

  @override
  void initState() {
    super.initState();
    _addInitialEvent();
  }

  Future<void> _addInitialEvent() async {
    _subscriptionPreferences = await SubscriptionPreferences.getInstance();
    _userPreferences = await UserPreferences.getInstance();

    _userStream =
        FirestoreService().getUserStream(_userPreferences!.userId.toString());

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Strings.settings,
          style: context.textTheme.bodySmall!.copyWith(
            color: context.themeExtension.mainBlackToWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0)
                  .copyWith(bottom: 50),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return InkWell(
                    onTap: () {
                      // log(' qwertyui');
                      final currentLocale =
                          Localizations.localeOf(context).languageCode;
                      if (currentLocale != 'ru') {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return PremiumBottomSheet(
                              userId: _userPreferences!.userId,
                              onClickOpenTelegram: () =>
                                  Navigator.of(context).pop(),
                            );
                          },
                        );
                      }
                    },
                    child: _buildPremiumCard(context),
                  );
                } else if (index == 1) {
                  return _buildGeneralSettings(context);
                } else {
                  return _buildContactSettings(context);
                }
              },
            ),
    );
  }

  Widget _buildPremiumCard(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, snapshot) {
        bool hasActiveSubscription =
            _subscriptionPreferences!.hasActiveSubscription;
        DateTime? expiryDate = _subscriptionPreferences!.subscriptionEndDate;

        // Handle stream errors (e.g., when Google Play Services is unavailable)
        if (snapshot.hasError) {
          log('❌ Firestore Stream Error: ${snapshot.error}');
          log('ℹ️ Falling back to local subscription data');
          // Continue with local data from _subscriptionPreferences
        } else if (snapshot.hasData) {
          log('Listening to document id: ${_userPreferences?.userId}');

          if (snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>?;

            // МГНОВЕННО обновляем переменную для UI
            hasActiveSubscription = data?['has_premium'] ?? false;

            // Если в Firestore есть дата (парсим из строки, судя по вашему логу)
            if (data?['updated_at'] != null) {
              try {
                expiryDate = DateTime.parse(data?['updated_at']);
              } catch (e) {
                log('Ошибка парсинга даты: $e');
              }
            }

            log('⚡ UI REBUILD: Premium set to $hasActiveSubscription');
          } else {
            // Документ удален из Firestore - сбрасываем премиум
            hasActiveSubscription = false;
            expiryDate = null;
            log('⚠️ Документ пользователя удален - премиум сброшен');
          }
        }

        final expiryString = expiryDate?.toDateString(
              inputFormat: 'dd MMMM yyyy',
              locale: context.locale,
            ) ??
            "";

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: ValueKey('premium_card_$hasActiveSubscription'),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.themeExtension.offWhiteBlueTintToGondola,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            Strings.settingsPremiumSubscription,
                            style: const TextStyle(
                              color: AppColors.vividBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (hasActiveSubscription)
                            SvgPicture.asset(
                              AppIcons.pro,
                              width: 20,
                              height: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        hasActiveSubscription
                            ? "${Strings.settingsPremiumSubscriptionActive} $expiryString"
                            : '${context.tr('faol')} (ID: ${_userPreferences!.userId})',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const BlinkingArrowInCircle(),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildGeneralSettings(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.themeExtension.offWhiteBlueTintToGondola,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SettingsItemWidget(
            title: Strings.selectLanguage,
            iconPath: AppIcons.language,
            widget: Row(
              children: [
                Text(
                  Language.valueFromLocale(context.locale).languageName,
                  style: context.textTheme.headlineSmall!.copyWith(
                    color: context.themeExtension.charcoalBlackToWhite,
                  ),
                ),
                const SizedBox(width: 7),
                SvgPicture.asset(AppIcons.arrowRight),
              ],
            ),
            onChange: (_) {},
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  return LanguageBottomSheet(
                    onChanged: (Language language) {
                      language = language;
                    },
                    selectedLanguage: Language.valueFromLocale(context.locale),
                  );
                },
              ).then((value) async {
                if (value is Language) {
                  Locale locale = value.locale;
                  EasyLocalization.of(context)?.setLocale(locale);
                }
              });
            },
          ),
          const WDivider(indent: 16, endIndent: 16),
          SettingsItemWidget(
            title: Strings.nightMode,
            iconPath: AppIcons.moon,
            onChange: (bool onchange) {
              isDarkModeNotifier.value = onchange;
              StorageRepository.putBool(
                  key: StorageKeys.isDarkMode, value: onchange);
              setState(() {});
            },
            onTap: () {},
            hasSwitch: true,
            isSwitched: StorageRepository.getBool(StorageKeys.isDarkMode,
                defValue: false),
          ),
          const WDivider(indent: 16, endIndent: 16),
          SettingsItemWidget(
            title: Strings.fontSize,
            iconPath: AppIcons.textAquare,
            onChange: (_) {},
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  return const FontSizeBottomSheet();
                },
              );
            },
          ),
          const WDivider(indent: 16, endIndent: 16),
          SettingsItemWidget(
            title: Strings.hideComment,
            iconPath: AppIcons.lightbulb,
            onChange: (bool onchange) {
              StorageRepository.putBool(
                  key: StorageKeys.isCommentHidden, value: onchange);
              setState(() {});
            },
            onTap: () {},
            hasSwitch: true,
            isSwitched: StorageRepository.getBool(StorageKeys.isCommentHidden,
                defValue: false),
          ),
          const WDivider(indent: 16, endIndent: 16),
          SettingsItemWidget(
            title: Strings.automaticallyMoveToTheNextQuestion,
            iconPath: AppIcons.autoNext,
            onChange: (bool onchange) {
              StorageRepository.putBool(
                  key: StorageKeys.isNextMode, value: onchange);
              setState(() {});
            },
            onTap: () {},
            hasSwitch: true,
            isSwitched: StorageRepository.getBool(StorageKeys.isNextMode,
                defValue: true),
          ),
          const WDivider(indent: 16, endIndent: 16),
          SettingsItemWidget(
            title: context.tr('aralash'),
            iconPath: AppIcons.aralash,
            onChange: (bool onchange) {
              StorageRepository.putBool(
                  key: StorageKeys.isStaticMode, value: onchange);
              setState(() {});
            },
            onTap: () {},
            hasSwitch: true,
            isSwitched: StorageRepository.getBool(StorageKeys.isStaticMode,
                defValue: true),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSettings(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.themeExtension.offWhiteBlueTintToGondola,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SettingsItemWidget(
            title: Strings.contactUs,
            iconPath: AppIcons.chatLine,
            onChange: (_) {},
            onTap: () => MyFunctions.launchTelegram(),
          ),
          const WDivider(indent: 16, endIndent: 16),
          SettingsItemWidget(
            title: Strings.rate,
            iconPath: AppIcons.star,
            onChange: (_) {},
            onTap: () => MyFunctions.rateApp(),
          ),
          const WDivider(indent: 16, endIndent: 16),

          // SettingsItemWidget(
          //   title: 'Check Firestore',
          //   iconPath: AppIcons.star,
          //   onChange: (_) {},
          //   onTap: () => Firestore().getUser(),
          // ),

          const WDivider(indent: 16, endIndent: 16),
          SettingsItemWidget(
            title: "FCM Token",
            iconPath: AppIcons.pro, // Using an existing icon
            onChange: (_) {},
            onTap: () async {
              final token =
                  await ' serviceLocator<NotificationService>().getToken();';
              if (token != null && context.mounted) {
                await Clipboard.setData(ClipboardData(text: token));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Token copied to clipboard",
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
