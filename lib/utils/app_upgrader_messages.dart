import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:upgrader/upgrader.dart';

class AppUpgraderMessages extends UpgraderMessages {
  @override
  String? message(UpgraderMessage messageKey) {
    switch (messageKey) {
      case UpgraderMessage.title:
        return 'Update Available';
      case UpgraderMessage.body:
        return 'A new version of ${FlavorConfig.instance.name} is available! Please update to continue.';
      case UpgraderMessage.buttonTitleUpdate:
        return 'Update Now';
      default:
        return super.message(messageKey);
    }
  }
}
