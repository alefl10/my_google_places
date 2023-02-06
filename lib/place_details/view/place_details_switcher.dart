import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/place_details/place_details.dart';

class PlaceDetailsSwitcher extends StatelessWidget {
  const PlaceDetailsSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select(
      (PlaceDetailsBloc bloc) => bloc.state.status,
    );
    switch (status) {
      case PlaceDetailsStatus.initial:
      case PlaceDetailsStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case PlaceDetailsStatus.success:
        return const PlaceDetailsView();
      case PlaceDetailsStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.genericErrorMessage),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<PlaceDetailsBloc>().add(
                        const PlaceDetailsDataRequested(),
                      );
                },
                child: Text(l10n.tryAgainText),
              ),
            ],
          ),
        );
    }
  }
}
