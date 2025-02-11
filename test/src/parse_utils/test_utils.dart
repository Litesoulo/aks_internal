import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

const serverUrl = 'https://example.com';

Future<void> initializeParse({String? liveQueryUrl}) async {
  await Parse().initialize(
    'appId',
    serverUrl,
    liveQueryUrl: liveQueryUrl,
    debug: true,
    // to prevent automatic detection
    fileDirectory: 'someDirectory',
    // to prevent automatic detection
    appName: 'appName',
    // to prevent automatic detection
    appPackageName: 'somePackageName',
    // to prevent automatic detection
    appVersion: 'someAppVersion',
    coreStore: CoreStoreMemoryImp(),
  );
}
