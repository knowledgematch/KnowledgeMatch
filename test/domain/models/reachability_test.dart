import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/reachability.dart';

void main() {
  group('Reachability', () {
    test('toString returns correct strings', () {
      expect(Reachability.online.toString(), 'Online');
      expect(Reachability.inPerson.toString(), 'In Person');
      expect(Reachability.onlineOrInPerson.toString(), 'Online/In Person');
    });

    test('fromString returns correct enum values', () {
      expect(Reachability.fromString('Online'), Reachability.online);
      expect(Reachability.fromString('In Person'), Reachability.inPerson);
      expect(Reachability.fromString('Online/In Person'), Reachability.onlineOrInPerson);
      expect(Reachability.fromString('Unknown'), Reachability.onlineOrInPerson);
    });

    test('value returns correct int', () {
      expect(Reachability.online.value, 0);
      expect(Reachability.inPerson.value, 1);
      expect(Reachability.onlineOrInPerson.value, 2);
    });

    test('description returns correct string', () {
      expect(Reachability.online.description, 'Online');
      expect(Reachability.inPerson.description, 'In Person');
      expect(Reachability.onlineOrInPerson.description, 'Online/In Person');
    });

    test('fromValue returns correct enum', () {
      expect(ReachabilityValue.fromValue(0), Reachability.online);
      expect(ReachabilityValue.fromValue(1), Reachability.inPerson);
      expect(ReachabilityValue.fromValue(2), Reachability.onlineOrInPerson);
    });

    test('fromValue throws ArgumentError on invalid value', () {
      expect(() => ReachabilityValue.fromValue(99), throwsArgumentError);
    });
  });
}
