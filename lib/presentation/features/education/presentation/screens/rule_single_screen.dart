import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:flutter/material.dart';

class RuleSingleScreen extends StatelessWidget {
  const RuleSingleScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWrapper(
        title: "Umumiy qoidalar",
        hasBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: context.mediaQuery.padding.bottom, top: 12),
        child: Text(
          '''1. Umumiy qoidalar
﻿﻿﻿Ushbu Yo'l harakati qoidalari (keyingi o'rinlarda - Qoidalar) O'zbekiston Respublikasi hududida yo'l harakatining yagona tartibini belgilaydi.
﻿﻿﻿O'zbekiston Respublikasi yo'llarida transport vositalarining o'ng tomonlama harakatlanish tartibi belgilangan.

﻿﻿﻿Yo'l harakati qatnashchilari "Yo'l harakati xavfsizligi to'g'risida"gi O'zbekiston Respublikasi Qonunini, ushbu Qoidalarni va unda keltirilgan svetofor ishoralari, yo'l belgilari (ushbu qoidalarga 1-ilova), yo'l chiziqlarining (ushbu qoidalarga

2-ilova) talablarini bilishlari, ularga amal ailishlari, shuningdek, ularga berilgan vakolat doirasida yo'llarda harakatni tartibga soluvchilarning ko'rsatmalarini so'zsiz bajarishlari shart.

4. Yo'l harakati qatnashchilari yo'ldagi boshqa harakat qatnashchilarining harakatlanishiga to'sqinlik qilmasligi va xavf tug'dirmasliklari kerak.
Tegishli vakolatga ega bo'lmagan yuridik va jismoniy shaxslarga yo'l goplamasini buzish, o'zgartirish yoki zarar yetkazish, ifloslantirish, yo'l belgilarini, svetoforlarni va harakatlanishni tashkil etishning boshqa texnik vositalarini o'zboshimchalik bilan olib tashlash, o'rnatish, to'sib qo'yish, shikastlantirish, yo'llarda harakatlanishga to'sqinlik qiluvchi narsalarni qoldirish, "sun'iy notekislik" qurilmalarini o'rnatish taqiqlanadi.

Harakatlanishga to'sqinlik yuzaga keltiradigan shaxs uni tezda bartaraf qilish uchun imkoniyati darajasida barcha choralarni ko'rishi, agar buning iloji bo'lmasa, mavjud barcha vositalar bilan xavf-xatar haqida harakat qatnashchilarini ogohlantirishi va ichki ishlar organlariga (keyingi o'rinlarda IIO) xabar berishi shart.
5. Mazkur Qoidalarni buzgan shaxslar O'zbekiston
Respublik asining gonun nuratranroa muvonrd javob beradilar.
1. Umumiy qoidalar
﻿﻿﻿Ushbu Yo'l harakati qoidalari (keyingi o'rinlarda - Qoidalar) O'zbekiston Respublikasi hududida yo'l harakatining yagona tartibini belgilaydi.
﻿﻿﻿O'zbekiston Respublikasi yo'llarida transport vositalarining o'ng tomonlama harakatlanish tartibi belgilangan.

﻿﻿﻿Yo'l harakati qatnashchilari "Yo'l harakati xavfsizligi to'g'risida"gi O'zbekiston Respublikasi Qonunini, ushbu Qoidalarni va unda keltirilgan svetofor ishoralari, yo'l belgilari (ushbu qoidalarga 1-ilova), yo'l chiziqlarining (ushbu qoidalarga

2-ilova) talablarini bilishlari, ularga amal ailishlari, shuningdek, ularga berilgan vakolat doirasida yo'llarda harakatni tartibga soluvchilarning ko'rsatmalarini so'zsiz bajarishlari shart.

4. Yo'l harakati qatnashchilari yo'ldagi boshqa harakat qatnashchilarining harakatlanishiga to'sqinlik qilmasligi va xavf tug'dirmasliklari kerak.
Tegishli vakolatga ega bo'lmagan yuridik va jismoniy shaxslarga yo'l goplamasini buzish, o'zgartirish yoki zarar yetkazish, ifloslantirish, yo'l belgilarini, svetoforlarni va harakatlanishni tashkil etishning boshqa texnik vositalarini o'zboshimchalik bilan olib tashlash, o'rnatish, to'sib qo'yish, shikastlantirish, yo'llarda harakatlanishga to'sqinlik qiluvchi narsalarni qoldirish, "sun'iy notekislik" qurilmalarini o'rnatish taqiqlanadi.

Harakatlanishga to'sqinlik yuzaga keltiradigan shaxs uni tezda bartaraf qilish uchun imkoniyati darajasida barcha choralarni ko'rishi, agar buning iloji bo'lmasa, mavjud barcha vositalar bilan xavf-xatar haqida harakat qatnashchilarini ogohlantirishi va ichki ishlar organlariga (keyingi o'rinlarda IIO) xabar berishi shart.
5. Mazkur Qoidalarni buzgan shaxslar O'zbekiston
Respublik asining gonun nuratranroa muvonrd javob beradilar.''',
          style: context.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
