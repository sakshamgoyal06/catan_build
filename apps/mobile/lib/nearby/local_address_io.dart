import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';

Future<String> resolveLanIPv4() async {
  if (Platform.isAndroid || Platform.isIOS) {
    final info = NetworkInfo();
    final wifi = await info.getWifiIP();
    if (wifi != null && wifi.isNotEmpty) return wifi;
  }

  for (final interface in await NetworkInterface.list(
    type: InternetAddressType.IPv4,
    includeLinkLocal: false,
  )) {
    for (final addr in interface.addresses) {
      if (!addr.isLoopback && !addr.address.startsWith('169.254')) {
        return addr.address;
      }
    }
  }
  return '127.0.0.1';
}
