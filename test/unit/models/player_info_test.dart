import 'package:flutter_test/flutter_test.dart';
import 'package:sports_for_life_academy/models/player_info.dart';

void main() {
  group('PlayerInfo.isDobValid', () {
    test('past date is valid', () {
      final past = DateTime(2010, 1, 15);
      expect(PlayerInfo.isDobValid(past), isTrue);
    });

    test('far future date is invalid', () {
      final future = DateTime(2035, 6, 1);
      expect(PlayerInfo.isDobValid(future), isFalse);
    });

    test('tomorrow is invalid', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(PlayerInfo.isDobValid(tomorrow), isFalse);
    });
  });

  group('PlayerInfo.validate', () {
    test('valid player returns no errors', () {
      final info = PlayerInfo(
        fullName: 'Omar Ali',
        dateOfBirth: DateTime(2015, 3, 10),
        gender: Gender.male,
      );
      expect(info.validate(), isEmpty);
    });

    test('empty fullName returns error', () {
      final info = PlayerInfo(
        fullName: '',
        dateOfBirth: DateTime(2015, 3, 10),
        gender: Gender.male,
      );
      expect(info.validate(), contains('player_full_name_required'));
    });

    test('future dateOfBirth returns error', () {
      final info = PlayerInfo(
        fullName: 'Omar Ali',
        dateOfBirth: DateTime.now().add(const Duration(days: 10)),
        gender: Gender.male,
      );
      expect(info.validate(), contains('dob_future_not_allowed'));
    });
  });
}
