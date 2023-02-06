import 'package:my_google_places/main/bootstrap.dart';
import 'package:my_google_places/main/configs/configs.dart';
import 'package:my_google_places/main/main_common.dart';

void main() {
  bootstrap(() async => mainCommon(appEnvironment: AppEnvironment.dev));
}
