import 'dart:developer';

import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/extensions/date_extensions.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/data/datasource/preference/device_preferences.dart';
import 'package:avtotest/data/datasource/preference/settings_preferences.dart';
import 'package:avtotest/data/datasource/preference/subscription_preferences.dart';
import 'package:avtotest/data/datasource/preference/user_preferences.dart';
import 'package:avtotest/data/datasource/storage/storage.dart';
import 'package:avtotest/data/datasource/storage/storage_keys.dart';
import 'package:avtotest/domain/model/language/language.dart';
import 'package:avtotest/presentation/features/settings/bottom_sheet/premium_bottom_sheet_in_settings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/application/application.dart';
import 'package:avtotest/presentation/widgets/w_divider.dart';
import 'package:avtotest/presentation/features/settings/bottom_sheet/font_size_bottom_sheet.dart';
import 'package:avtotest/presentation/features/settings/bottom_sheet/language_bottom_sheet.dart';
import 'package:avtotest/presentation/features/settings/widgets/settings_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DevicePreferences? _devicePreferences;
  SettingsPreferences? _settingsPreferences;
  SubscriptionPreferences? _subscriptionPreferences;
  UserPreferences? _userPreferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _addInitialEvent();
  }

  Future<void> _addInitialEvent() async {
    _devicePreferences = await DevicePreferences.getInstance();
    _settingsPreferences = await SettingsPreferences.getInstance();
    _subscriptionPreferences = await SubscriptionPreferences.getInstance();
    _userPreferences = await UserPreferences.getInstance();

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
    return Container(
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
                Text(
                  Strings.settingsPremiumSubscription,
                  style: const TextStyle(
                    color: AppColors.vividBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _subscriptionPreferences!.hasActiveSubscription
                      ? "${Strings.settingsPremiumSubscriptionActive} ${_subscriptionPreferences!.subscriptionEndDate?.toDateString(inputFormat: 'dd MMMM yyyy', locale: context.locale)}"
                      : Strings.settingsPremiumSubscriptionNotActive,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          SvgPicture.asset(AppIcons.arrowRight),
          const SizedBox(width: 16),
        ],
      ),
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
                defValue: true),
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
            title: 'Static qilish',
            iconPath: AppIcons.autoNext,
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
          SettingsItemWidget(
            title: Strings.share,
            iconPath: AppIcons.share,
            onChange: (_) {},
            onTap: () => MyFunctions.shareAppLink(),
          ),
        ],
      ),
    );
  }
}
