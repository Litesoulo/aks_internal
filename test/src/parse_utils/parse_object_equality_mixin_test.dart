import 'dart:io';

import 'package:aks_internal/aks_internal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'test_utils.dart';

/// A concrete ParseObject implementing the ParseObjectEqualityMixin
class MyParseObject extends ParseObject with ParseObjectEqualityMixin implements ParseCloneable {
  MyParseObject() : super(className);
  MyParseObject.clone() : this();

  static const String className = 'MyParseObject';

  ParseFile? get picture => get<ParseFile?>(keyPicture);
  set picture(ParseFile? value) => set<ParseFile?>(keyPicture, value);

  MyParseObject? get pointerField => get<MyParseObject?>(keyPointerField);
  set pointerField(MyParseObject? value) => set<MyParseObject?>(keyPointerField, value);

  static const String keyPicture = 'picture';
  static const String keyPointerField = 'picture';

  /// Mimic a clone since Flutter doesn’t use reflection
  @override
  MyParseObject clone(Map<String, dynamic> map) => MyParseObject.clone()..fromJson(map);
}

void main() {
  setUp(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();

      await initializeParse();
    },
  );

  group('ParseObjectEqualityMixin', () {
    test('should return true for two objects with identical properties', () {
      final obj1 = MyParseObject()
        ..objectId = '123'
        ..picture = ParseFile(File('image1.png'), url: 'image1.png');

      final obj2 = MyParseObject()
        ..objectId = '123'
        ..picture = ParseFile(File('image1.png'), url: 'image1.png');

      expect(obj1 == obj2, isTrue);
      expect(obj1.hashCode, equals(obj2.hashCode));
    });

    test('should return false for objects with different properties', () {
      final obj1 = MyParseObject()
        ..objectId = '123'
        ..picture = ParseFile(File('image1.png'), url: 'image1.png');

      final obj2 = MyParseObject()
        ..objectId = '123'
        ..picture = ParseFile(File('image1.png'), url: 'image2.png');

      expect(obj1 == obj2, isFalse);
      expect(obj1.hashCode, isNot(equals(obj2.hashCode)));
    });

    test('should return false for objects with different objectId but same properties', () {
      final obj1 = MyParseObject()
        ..objectId = '123'
        ..picture = ParseFile(File('image1.png'), url: 'image1.png');

      final obj2 = MyParseObject()
        ..objectId = '456'
        ..picture = ParseFile(File('image1.png'), url: 'image1.png');

      expect(obj1 == obj2, isFalse);
      expect(obj1.hashCode, isNot(equals(obj2.hashCode)));
    });

    test('should return true when comparing cloned objects', () {
      final original = MyParseObject()
        ..objectId = '789'
        ..picture = ParseFile(File('image3.png'), url: 'image3.png');

      final clone = original.clone(original.toJson());

      expect(original == clone, isTrue);
      expect(original.hashCode, equals(clone.hashCode));
    });

    test('should correctly handle nested ParseObjects', () {
      final nestedObject = MyParseObject()..objectId = 'nested1';

      final obj1 = MyParseObject()
        ..objectId = '001'
        ..pointerField = nestedObject;

      final obj2 = MyParseObject()
        ..objectId = '001'
        ..pointerField = nestedObject;

      expect(obj1 == obj2, isTrue);
      expect(obj1.hashCode, equals(obj2.hashCode));
    });

    test('should return false when nested ParseObjects differ', () {
      final nested1 = MyParseObject()..objectId = 'nested1';
      final nested2 = MyParseObject()..objectId = 'nested2';

      final obj1 = MyParseObject()
        ..objectId = '002'
        ..pointerField = nested1;

      final obj2 = MyParseObject()
        ..objectId = '002'
        ..pointerField = nested2;

      expect(obj1 == obj2, isFalse);
      expect(obj1.hashCode, isNot(equals(obj2.hashCode)));
    });

    test('should handle Pointer class correctly', () {
      final pointer1 = ParseObject('PointerClass')..objectId = 'pointer1';
      final pointer2 = ParseObject('PointerClass')..objectId = 'pointer1';

      final obj1 = MyParseObject()
        ..objectId = '003'
        ..set('pointerField', pointer1.toPointer());

      final obj2 = MyParseObject()
        ..objectId = '003'
        ..set('pointerField', pointer2.toPointer());

      expect(obj1 == obj2, isTrue);
      expect(obj1.hashCode, equals(obj2.hashCode));
    });
  });
}
