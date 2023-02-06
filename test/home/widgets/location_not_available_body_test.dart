import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_google_places/home/home.dart';
import 'package:my_google_places/permission/permission.dart';

import '../../helpers/helpers.dart';

class _MockPermissionBloc extends MockBloc<PermissionEvent, PermissionState>
    implements PermissionBloc {}

void main() {
  group('LocationNotAvailableBody', () {
    late PermissionBloc permissionBloc;

    setUp(() {
      permissionBloc = _MockPermissionBloc();
      when(() => permissionBloc.state).thenReturn(const PermissionState());
    });

    group('adds', () {
      testWidgets(
        'PermissionSettingsOpened on openSettingsText button tap',
        (tester) async {
          await tester.pumpLocationNotAvailableBody(
            permissionBloc: permissionBloc,
          );
          final l10n = await getAppLocalizations();
          await tester.tap(find.text(l10n.openSettingsText));
          await tester.pumpAndSettle();

          verify(
            () => permissionBloc.add(const PermissionSettingsOpened()),
          ).called(1);
        },
      );

      testWidgets(
        'PermissionLocationRequested on getLocationText button tap',
        (tester) async {
          await tester.pumpLocationNotAvailableBody(
            permissionBloc: permissionBloc,
          );
          final l10n = await getAppLocalizations();
          await tester.tap(find.text(l10n.getLocationText));
          await tester.pumpAndSettle();

          verify(
            () => permissionBloc.add(const PermissionLocationRequested()),
          ).called(1);
        },
      );
    });
  });
}

extension on WidgetTester {
  Future<void> pumpLocationNotAvailableBody({
    required PermissionBloc permissionBloc,
  }) {
    return pumpApp(
      BlocProvider.value(
        value: permissionBloc,
        child: const Scaffold(body: LocationNotAvailableBody()),
      ),
    );
  }
}
