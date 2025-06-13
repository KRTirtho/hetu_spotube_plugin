import 'package:hetu_script/external/external_class.dart';
import 'package:hetu_script/hetu_script.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class TimezoneClassBinding extends HTExternalClass {
  TimezoneClassBinding() : super("Timezone");

  @override
  memberGet(String varName, {String? from}) {
    return switch (varName) {
      "Timezone.getLocalTimeZone" => (
        HTEntity entity, {
        positionalArgs,
        namedArgs,
        typeArgs,
      }) {
        return FlutterTimezone.getLocalTimezone();
      },
      "Timezone.getAvailableTimezones" => (
        HTEntity entity, {
        positionalArgs,
        namedArgs,
        typeArgs,
      }) {
        return FlutterTimezone.getAvailableTimezones();
      },
      _ => HTError.undefined(varName),
    };
  }
}
