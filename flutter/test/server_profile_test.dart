import 'dart:convert';

import 'package:flutter_hbb/common.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('server profile json round trip', () {
    final profile = ServerProfile('lapo.it',
        idServer: ' lapo.it ',
        relayServer: 'relay.lapo.it',
        apiServer: 'https://api.lapo.it',
        key: 'abCdR1c1E=');
    final restored =
        ServerProfile.fromJson(jsonDecode(jsonEncode(profile.toJson())));
    expect(restored.name, 'lapo.it');
    expect(restored.idServer, 'lapo.it');
    expect(restored.apiServer, 'https://api.lapo.it');
    expect(restored.key, 'abCdR1c1E=');
    expect(restored.matches(profile.toServerConfig()), isTrue);
  });

  test('server profile tolerates broken stored json', () {
    final broken = ServerProfile.fromJson({'name': 'only-name'});
    expect(broken.name, 'only-name');
    expect(broken.idServer, '');
    expect(broken.relayServer, '');
  });

  test('server profile matching is order and whitespace insensitive', () {
    final config =
        ServerConfig(idServer: 'lapo.it', relayServer: ' relay.lapo.it ');
    final profile = ServerProfile('lapo',
        idServer: 'lapo.it', relayServer: 'relay.lapo.it');
    expect(profile.matches(config), isTrue);
    expect(
        profile.matches(ServerConfig(idServer: 'other.server')), isFalse);
  });
}
