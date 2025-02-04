import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

/// A mixin for comparing Parse objects based on their properties and IDs.
mixin ParseObjectEqualityMixin on ParseObject {
  /// Compares the `objectId` of the current object with another ParseObject's `objectId`.
  ///
  /// Returns `true` if the IDs are the same, otherwise returns `false`.
  bool compareId(ParseObject? other) => objectId == other?.objectId;

  @override
  bool operator ==(Object other) {
    // Checks if the current object is identical to the other.
    if (identical(this, other)) return true;

    // Returns false if the types don't match.
    if (runtimeType != other.runtimeType) return false;

    // Returns false if the other object is not a ParseObject.
    if (other is! ParseObject) return false;

    // Compares the properties of both objects.
    final properties = toJson();
    for (final key in properties.keys) {
      if (get<dynamic>(key) != other.get<dynamic>(key)) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => Object.hashAll(
        toJson().keys.map(get),
      );
}
