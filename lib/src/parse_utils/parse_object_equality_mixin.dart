import 'package:collection/collection.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

/// A mixin for comparing `ParseObject` instances based on their properties and IDs.
mixin ParseObjectEqualityMixin on ParseObject {
  static const _collectionEquality = DeepCollectionEquality();

  /// A list of keys to exclude from equality comparisons.
  static const Set<String> _keysToExclude = {
    keyVarAcl,
    keyVarCreatedAt,
    keyVarUpdatedAt,
  };

  /// Compares the `objectId` of the current `ParseObject` with another `ParseObject`'s `objectId`.
  bool compareId(ParseObject? other) => objectId == other?.objectId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! ParseObject || runtimeType != other.runtimeType) return false;

    assert(other is ParseObjectEqualityMixin, 'Other object is not extending `ParseObjectEqualityMixin`');

    // Filter out excluded keys from the `toJson()` output for both objects
    final properties = toJson();
    final filteredProperties = Map.fromEntries(
      properties.entries.where((entry) => !_keysToExclude.contains(entry.key)),
    );

    final otherProperties = other.toJson();
    final otherFilteredProperties = Map.fromEntries(
      otherProperties.entries.where((entry) => !_keysToExclude.contains(entry.key)),
    );

    return _collectionEquality.equals(filteredProperties, otherFilteredProperties);
  }

  @override
  int get hashCode {
    final properties = toJson();
    final filteredProperties = Map.fromEntries(
      properties.entries.where((entry) => !_keysToExclude.contains(entry.key)),
    );

    return Object.hashAll(
      filteredProperties.entries.map((e) => Object.hash(e.key, _hashValue(e.value))),
    );
  }

  /// Ensures proper hashing of collections and `ParseObject` instances.
  int _hashValue(dynamic value) {
    if (value is ParseObject) return value.hashCode;
    if (value is Iterable) return Object.hashAll(value.map(_hashValue));
    if (value is Map) {
      final sortedEntries = value.entries.toList()..sort((a, b) => a.key.toString().compareTo(b.key.toString()));
      return Object.hashAll(sortedEntries.map((e) => Object.hash(_hashValue(e.key), _hashValue(e.value))));
    }
    return value?.hashCode ?? 0;
  }
}
