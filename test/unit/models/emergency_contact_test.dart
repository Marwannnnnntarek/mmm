import 'package:flutter_test/flutter_test.dart';
import 'package:sports_for_life_academy/models/emergency_contact.dart';

void main() {
  group('EmergencyContact.validateUniqueness', () {
    test('same number as parent mobile returns error key', () {
      const contact = EmergencyContact(
        name: 'Khalid',
        phoneNumber: '01012345678',
      );
      expect(
        contact.validateUniqueness('01012345678'),
        equals('emergency_phone_same_as_parent'),
      );
    });

    test('different number returns null', () {
      const contact = EmergencyContact(
        name: 'Khalid',
        phoneNumber: '01198765432',
      );
      expect(contact.validateUniqueness('01012345678'), isNull);
    });
  });

  group('EmergencyContact.validate', () {
    test('valid contact with different phone returns no errors', () {
      const contact = EmergencyContact(
        name: 'Khalid',
        phoneNumber: '01198765432',
      );
      expect(contact.validate(parentMobile: '01012345678'), isEmpty);
    });

    test('empty name returns required error', () {
      const contact = EmergencyContact(
        name: '',
        phoneNumber: '01198765432',
      );
      expect(
        contact.validate(parentMobile: '01012345678'),
        contains('emergency_name_required'),
      );
    });

    test('phone same as parent mobile returns uniqueness error', () {
      const contact = EmergencyContact(
        name: 'Khalid',
        phoneNumber: '01012345678',
      );
      expect(
        contact.validate(parentMobile: '01012345678'),
        contains('emergency_phone_same_as_parent'),
      );
    });

    test('invalid phone format returns format error', () {
      const contact = EmergencyContact(
        name: 'Khalid',
        phoneNumber: '123',
      );
      expect(
        contact.validate(parentMobile: '01012345678'),
        contains('emergency_phone_invalid_format'),
      );
    });
  });
}
