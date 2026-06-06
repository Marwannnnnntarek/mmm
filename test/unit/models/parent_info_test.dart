import 'package:flutter_test/flutter_test.dart';
import 'package:sports_for_life_academy/models/parent_info.dart';

void main() {
  group('ParentInfo.isValidEgyptianMobile', () {
    test('valid 010 prefix passes', () {
      expect(ParentInfo.isValidEgyptianMobile('01012345678'), isTrue);
    });

    test('valid 011 prefix passes', () {
      expect(ParentInfo.isValidEgyptianMobile('01112345678'), isTrue);
    });

    test('valid 012 prefix passes', () {
      expect(ParentInfo.isValidEgyptianMobile('01212345678'), isTrue);
    });

    test('valid 015 prefix passes', () {
      expect(ParentInfo.isValidEgyptianMobile('01512345678'), isTrue);
    });

    test('invalid 013 prefix fails', () {
      expect(ParentInfo.isValidEgyptianMobile('01312345678'), isFalse);
    });

    test('number too short fails', () {
      expect(ParentInfo.isValidEgyptianMobile('0101234567'), isFalse);
    });

    test('number too long fails', () {
      expect(ParentInfo.isValidEgyptianMobile('010123456789'), isFalse);
    });

    test('non-digit characters fail', () {
      expect(ParentInfo.isValidEgyptianMobile('0101234567a'), isFalse);
    });

    test('empty string fails', () {
      expect(ParentInfo.isValidEgyptianMobile(''), isFalse);
    });

    test('does not start with 01 fails', () {
      expect(ParentInfo.isValidEgyptianMobile('02012345678'), isFalse);
    });
  });

  group('ParentInfo.validate', () {
    test('valid parent returns no errors', () {
      const info = ParentInfo(
        fullName: 'Ahmed Mohamed',
        mobileNumber: '01012345678',
        alternativeMobileNumber: '01112345678',
      );
      expect(info.validate(), isEmpty);
    });

    test('empty fullName returns error', () {
      const info = ParentInfo(
        fullName: '',
        mobileNumber: '01012345678',
        alternativeMobileNumber: '01112345678',
      );
      expect(info.validate(), contains('parent_full_name_required'));
    });

    test('invalid mobile returns mobile error', () {
      const info = ParentInfo(
        fullName: 'Ahmed',
        mobileNumber: '123',
        alternativeMobileNumber: '01112345678',
      );
      expect(info.validate(), contains('mobile_invalid_format'));
    });
  });
}
