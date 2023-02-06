import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_google_places/l10n/l10n.dart';

const localeName = 'en';

Future<AppLocalizations> getAppLocalizations() async {
  await initializeDateFormatting();
  return AppLocalizations.delegate.load(const Locale(localeName));
}
