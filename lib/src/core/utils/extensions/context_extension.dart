import 'package:authex/src/core/localization/app_localization.dart';
import 'package:flutter/widgets.dart';

extension LocalizationX on BuildContext {
  GeneratedLocalization stringOf() => AppLocalization.stringOf<GeneratedLocalization>(this);
}
