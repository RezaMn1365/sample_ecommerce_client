class BasicApiResponse {
  final bool success;
  final String? errorMessage;
  final List<dynamic> missingParams;
  final dynamic payload;

  BasicApiResponse.success(this.payload)
      : success = true,
        errorMessage = null,
        missingParams = const [];
  BasicApiResponse.failed(this.errorMessage)
      : success = false,
        payload = null,
        missingParams = const [];

  BasicApiResponse.missingParams(dynamic json)
      : success = false,
        errorMessage = json['message'],
        payload = null,
        missingParams = json['payload'] ?? const [];

  BasicApiResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        errorMessage = json['message'],
        payload = json['payload'],
        missingParams = const [];

  List<String> getMissingParams() {
    if (missingParams.isEmpty) return const [];

    List<String> missings = List.empty(growable: true);

    missingParams.forEach((element) {
      try {
        Map<String, dynamic> map = element;

        map.keys.forEach((key) {
          missings.add(map[key]);
        });
      } catch (e) {}
    });

    return missings;
  }
}
