extension MapExtension on Map {
  T getValue<T>({required String key}) {
    var value = this[key];

    if (value == null) null;

    return value as T;
  }
  
  T getValueOrDefault<K, T>({
    required K key,
    required T defaultValue,
  }) {
    var value = this[key];
    return value ?? defaultValue;
  }

  T getDeepValueOrDefault<T>({
    required String keys,
    required T defaultValue,
  }) {
    return _getDeepValueOrDefault(keys: keys, defaultValue: defaultValue);
  }

  dynamic _getDeepValueOrDefault<T>({
    required String keys,
    required T defaultValue,
  }) {
    if (keys.contains("|")) {
      final splitKeys = keys.split("|");
      final value = this[splitKeys[0]];
      if (value is Map) {
        final range = splitKeys..removeAt(0);
        return value._getDeepValueOrDefault(keys: range.join("|"), defaultValue: defaultValue);
      }
    }
    return this[keys] ?? defaultValue;
  }

  DateTime? getCompleteDateTime<K, T>({required K key, required T defaultValue}) {
    final value = getValueOrDefault(key: key, defaultValue: defaultValue);
    return (value as String).isEmpty ? null : DateTime.parse(value).toLocal();
  }

  DateTime getDateTime({required String key}) {
    final value = getValue(key: key);
    return DateTime.parse(value as String).toLocal();
  }
}
