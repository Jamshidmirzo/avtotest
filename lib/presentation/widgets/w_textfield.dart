import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'w_scale_animation.dart';

class WTextField extends StatefulWidget {
  final bool? hasSearch;
  final bool? hasBorderColor;
  final AutovalidateMode? autoValidateMode;
  final String? Function(String?)? validate;
  final bool? hasClearButton;
  final String title;
  final Color? disabledBorderColor;
  final double borderRadius;
  final TextStyle? titleTextStyle;
  final TextStyle? textStyle;
  final TextStyle? counterStyle;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Widget? label;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final TextStyle? prefixStyle;
  final String prefixText;
  final bool? hideCounterText;
  final Widget? prefix;
  final EdgeInsets? prefixPadding;
  final double? width;
  final double? height;
  final double? topPrefixPadding;
  final int? maxLength;
  final TextInputType? keyBoardType;
  final bool? isObscure;
  final Widget? suffix;
  final String? suffixIcon;
  final EdgeInsets? suffixPadding;
  final TextCapitalization textCapitalization;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final List<TextInputFormatter>? textInputFormatters;
  final EdgeInsets? contentPadding;
  final bool hasError;
  final double sizeBetweenFieldTitle;
  final Color? errorColor;
  final Color? fillColor;
  final EdgeInsets? margin;
  final VoidCallback? onEyeTap;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextInputAction textInputAction;
  final Function? onObscure;
  final Function? onTapSuffix;
  final Function()? onEditCompleted;
  final Function()? onTap;
  final bool autoFocus;
  final Color? disabledColor;
  final double? suffixRightPosition;
  final double? suffixSize;
  final int? maxLines;
  final Color? borderColor;
  final Color? enabledBorderColor;
  final Color? focusColor;
  final BorderRadius? detailedBorderRadius;
  final bool readOnly;
  final Widget? suffixTitleWidget;
  final String hintNextToTitle;
  final String? initial;
  final TextStyle? hintNextToTitleStyle;
  final Color? cursorColor;
  final List<BoxShadow>? boxShadow;
  final FloatingLabelAlignment floatingLabelAlignment;
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })? buildCounter;

  const WTextField({
    this.controller,
    required this.onChanged,
    this.hasBorderColor,
    this.topPrefixPadding,
    this.readOnly = false,
    this.disabledColor,
    this.validate,
    this.boxShadow,
    this.autoValidateMode,
    this.hideCounterText,
    this.autoFocus = false,
    this.borderRadius = 8,
    this.prefixStyle,
    this.disabledBorderColor,
    this.hasClearButton,
    this.textAlign = TextAlign.start,
    this.width,
    this.fillColor,
    this.title = '',
    this.titleTextStyle,
    this.label,
    this.labelText,
    this.labelTextStyle,
    this.textStyle,
    this.hintText,
    this.hintTextStyle,
    this.contentPadding = const EdgeInsets.only(top: 20, left: 16, bottom: 0),
    this.prefixText = '',
    this.prefix,
    this.prefixPadding = const EdgeInsets.all(2),
    this.suffix,
    this.suffixIcon,
    this.suffixPadding = const EdgeInsets.all(8),
    this.isObscure,
    this.onEyeTap,
    this.margin,
    this.sizeBetweenFieldTitle = 4,
    this.errorColor,
    this.hasError = false,
    this.textInputFormatters,
    this.floatingLabelAlignment = FloatingLabelAlignment.start,
    this.textCapitalization = TextCapitalization.none,
    this.keyBoardType,
    this.maxLength,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.height,
    this.onObscure,
    this.onTapSuffix,
    super.key,
    this.onEditCompleted,
    this.onTap,
    this.suffixRightPosition,
    this.suffixSize,
    this.maxLines = 1,
    this.borderColor,
    this.enabledBorderColor,
    this.detailedBorderRadius,
    this.focusColor = AppColors.white,
    this.suffixTitleWidget,
    this.hintNextToTitle = '',
    this.hasSearch,
    this.cursorColor = AppColors.mainDark,
    this.hintNextToTitleStyle,
    this.counterStyle,
    this.buildCounter,
    this.initial,
  });

  @override
  State<WTextField> createState() => _WTextFieldState();
}

class _WTextFieldState extends State<WTextField> with SingleTickerProviderStateMixin {
  late FocusNode focusNode;
  bool focused = false;
  bool hasText = false;
  bool isObscure = false;
  bool showStroke = false;
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    super.initState();
    if (widget.isObscure != null) {
      isObscure = widget.isObscure!;
    }
    focusNode = FocusNode();

    focusNode.addListener(
      () => setState(() {
        focused = !focused;
      }),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: widget.titleTextStyle ??
                          Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: AppColors.mainDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    Text(
                      ' ${widget.hintNextToTitle}',
                      style: widget.hintNextToTitleStyle ??
                          Theme.of(context).textTheme.labelLarge!.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ],
                ),
                if (widget.suffixTitleWidget != null) widget.suffixTitleWidget!,
              ],
            )
          else
            const SizedBox(),
          SizedBox(
            height: widget.title.isNotEmpty ? widget.sizeBetweenFieldTitle : null,
          ),
          Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: widget.detailedBorderRadius ?? BorderRadius.circular(8),
              color: Colors.transparent,
              boxShadow: widget.boxShadow,
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ClipRRect(
                  borderRadius: widget.detailedBorderRadius ?? BorderRadius.circular(widget.borderRadius),
                  child: TextFormField(
                    keyboardAppearance: context.theme.brightness,
                    cursorWidth: 1,
                    buildCounter: widget.buildCounter,
                    cursorRadius: const Radius.circular(1),
                    autovalidateMode: widget.autoValidateMode,
                    validator: widget.validate,
                    maxLines: widget.maxLines,
                    onTap: widget.onTap,
                    initialValue: widget.initial,
                    readOnly: widget.readOnly,
                    textAlign: widget.textAlign,
                    inputFormatters: widget.textInputFormatters,
                    textInputAction: widget.textInputAction,
                    textCapitalization: widget.textCapitalization,
                    obscureText: isObscure,
                    keyboardType: widget.keyBoardType,
                    maxLength: widget.maxLength,
                    controller: widget.controller,
                    autofocus: widget.autoFocus,
                    cursorColor: widget.cursorColor,
                    obscuringCharacter: '●',
                    cursorHeight: 18,
                    onEditingComplete: widget.onEditCompleted,
                    onChanged: (s) {
                      if (s.length == 1 || s.isEmpty) {
                        setState(() => hasText = s.isNotEmpty);
                      }
                      widget.onChanged(s);
                    },
                    focusNode: widget.focusNode ?? focusNode,
                    style: widget.textStyle ??
                        Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      label: widget.label,
                      labelText: widget.labelText,
                      labelStyle: widget.labelTextStyle,
                      floatingLabelAlignment: widget.floatingLabelAlignment,
                      suffix: widget.suffix != null ? SizedBox(width: widget.suffixSize) : null,
                      border: OutlineInputBorder(
                        borderRadius: widget.detailedBorderRadius ?? BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          width: 1,
                          color: widget.hasError
                              ? Theme.of(context).colorScheme.error
                              : widget.enabledBorderColor ?? AppColors.white,
                        ),
                      ),
                      counterStyle: widget.counterStyle,
                      hintText: widget.hintText,
                      hintStyle: widget.hintTextStyle ??
                          Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: AppColors.grey1,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                      filled: true,
                      prefixIcon: widget.hasSearch != null && widget.hasSearch!
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: SvgPicture.asset(
                                AppIcons.search,
                              ),
                            )
                          : widget.prefix,
                      fillColor: focused
                          ? widget.focusColor
                          : widget.disabledColor != null
                              ? widget.controller != null && widget.controller!.text.isNotEmpty
                                  ? widget.fillColor ?? Colors.transparent
                                  : widget.disabledColor
                              : widget.fillColor ?? Colors.transparent,
                      contentPadding: widget.contentPadding,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: widget.detailedBorderRadius ?? BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          width: 1,
                          color: widget.hasBorderColor != null && widget.hasBorderColor!
                              ? widget.borderColor ?? Colors.transparent
                              : widget.hasError
                                  ? Theme.of(context).colorScheme.error
                                  : widget.disabledBorderColor ?? widget.borderColor ?? Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: widget.detailedBorderRadius ?? BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          width: 1,
                          color: widget.hasBorderColor != null && widget.hasBorderColor!
                              ? widget.borderColor ?? Colors.transparent
                              : widget.hasError
                                  ? AppColors.red
                                  : widget.disabledBorderColor ?? widget.enabledBorderColor ?? Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: widget.detailedBorderRadius ?? BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          width: 1,
                          color: widget.hasBorderColor != null && !widget.hasBorderColor!
                              ? widget.borderColor ?? Colors.transparent
                              : widget.hasError
                                  ? AppColors.red
                                  : widget.borderColor ?? Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.prefixText.isNotEmpty)
                  AnimatedPositioned(
                    top: focused
                        ? 7
                        : widget.controller!.text.isNotEmpty
                            ? 7
                            : widget.topPrefixPadding ?? 12,
                    left: 16,
                    duration: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: widget.prefixPadding ?? EdgeInsets.zero,
                      child: AnimatedDefaultTextStyle(
                        style: widget.prefixStyle ??
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontSize: focused
                                      ? 11
                                      : widget.controller!.text.isNotEmpty
                                          ? 11
                                          : 14,
                                ),
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          widget.prefixText,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: widget.suffixRightPosition ?? 0,
                  child: widget.hasClearButton != null && widget.hasClearButton!
                      ? widget.controller != null && widget.controller!.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {});
                                widget.controller!.clear();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SvgPicture.asset(AppIcons.search),
                              ),
                            )
                          : const SizedBox()
                      : Padding(
                          padding: widget.suffixPadding ?? const EdgeInsets.all(8.0),
                          child: widget.suffix ?? const SizedBox(),
                        ),
                ),
                Positioned(
                  // top: 0,
                  right: 8,
                  child: widget.isObscure == null
                      ? widget.suffixIcon != null
                          ? WScaleAnimation(
                              onTap: () {},
                              child: Padding(
                                padding: widget.suffixPadding!,
                                child: SvgPicture.asset(
                                  widget.suffixIcon!,
                                ),
                              ),
                            )
                          : const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                            if (showStroke) {
                              showStroke = false;
                              animationController.forward();
                            } else {
                              showStroke = true;
                              animationController.reverse();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 10),
                            width: 24,
                            height: 24,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: animationController,
                                child: SvgPicture.asset(
                                  isObscure ? AppIcons.search : AppIcons.search,
                                ),
                                builder: (context, child) => SizedBox(width: 24, height: 24, child: child),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
