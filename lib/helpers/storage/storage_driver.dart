abstract class StorageDriver {
  Future<void> init();

  Future<void> putString(String key, String value);

  Future<void> putDouble(String key, double value);

  Future<String?> getString(String key);

  Future<double?> getDouble(String key);

  Future<void> clear();
}