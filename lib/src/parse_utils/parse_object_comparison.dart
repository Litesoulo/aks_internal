import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

/// Mixin to compare ParseObject instances based on specific properties.
///
/// This mixin provides functionality for custom equality and hash code
/// generation based on the properties defined in `compareKeys`. It also
/// includes a method for directly comparing object IDs.
mixin ParseObjectComparison on ParseObject {
  /// Compares the `objectId` of this instance with another `ParseObject`.
  ///
  /// Returns `true` if the `objectId` values of both instances match,
  /// otherwise returns `false`.
  bool compareId(ParseObject other) => objectId == other.objectId;

  /// List of property names used for equality and hash code calculation.
  List<String> get compareKeys;

  /// Default properties always included in comparison.
  final List<String> _defaultProps = [keyVarObjectId];

  /// Combined list of properties for comparison and hash generation.
  List<String> get _allKeys => [...compareKeys, ..._defaultProps];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    if (other is! ParseObject) return false;

    for (final key in _allKeys) {
      if (get<dynamic>(key) != other.get<dynamic>(key)) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode {
    return Object.hashAll(
      _allKeys.map((property) => get<dynamic>(property)),
    );
  }
}
