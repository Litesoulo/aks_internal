import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

/// A mixin for comparing `ParseObject` instances based on their properties and IDs.
///
/// This mixin provides methods to compare two `ParseObject` instances for equality
/// by excluding certain metadata keys (e.g., `ACL`, `createdAt`, `updatedAt`).
/// It also overrides the `==` operator and `hashCode` to ensure consistent behavior
/// when comparing objects.
mixin ParseObjectEqualityMixin on ParseObject {
  /// Compares the `objectId` of the current `ParseObject` with another `ParseObject`'s `objectId`.
  ///
  /// This method is useful for quickly checking if two objects represent the same entity
  /// in the Parse database.
  ///
  /// - [other]: The other `ParseObject` to compare with. Can be `null`.
  /// - Returns `true` if the `objectId` of both objects is the same, otherwise `false`.
  bool compareId(ParseObject? other) => objectId == other?.objectId;

  /// A list of keys to exclude from equality comparisons.
  ///
  /// These keys typically represent metadata (e.g., `ACL`, `createdAt`, `updatedAt`)
  /// that should not be considered when determining if two objects are equal.
  final _keysToExclude = [
    keyVarAcl,
    keyVarCreatedAt,
    keyVarUpdatedAt,
  ];

  /// Compares the current `ParseObject` with another object for equality.
  ///
  /// This method overrides the `==` operator to compare two `ParseObject` instances
  /// based on their properties, excluding the keys specified in `_keysToExclude`.
  ///
  /// - [other]: The object to compare with.
  /// - Returns `true` if the objects are considered equal, otherwise `false`.
  @override
  bool operator ==(Object other) {
    // If the objects are identical, they are equal.
    if (identical(this, other)) return true;

    // If the runtime types don't match, the objects are not equal.
    if (runtimeType != other.runtimeType) return false;

    // If the other object is not a `ParseObject`, they are not equal.
    if (other is! ParseObject) return false;

    // Compare the properties of both objects, excluding the keys in `_keysToExclude`.
    final properties = toJson();
    for (final key in properties.keys) {
      if (_keysToExclude.contains(key)) continue;

      if (get<dynamic>(key) != other.get<dynamic>(key)) {
        return false;
      }
    }

    return true;
  }

  /// Generates a hash code for the current `ParseObject`.
  ///
  /// This method overrides `hashCode` to ensure that two objects considered equal
  /// by the `==` operator also have the same hash code. The hash code is computed
  /// based on the object's properties, excluding the keys in `_keysToExclude`.
  ///
  /// - Returns an integer representing the hash code of the object.
  @override
  int get hashCode => Object.hashAll(
        toJson()
            .keys
            .where(
              (key) => !_keysToExclude.contains(key),
            )
            .map(get),
      );
}
