import 'basic_api_response.dart';

class ApiResponse<T> {
  final bool success;
  final String? errorMessage;
  final List<dynamic> missingParams;
  final T? data;

  ApiResponse(BasicApiResponse basicResponse, T? data1)
      : success = basicResponse.success,
        errorMessage = basicResponse.errorMessage,
        missingParams = basicResponse.missingParams,
        data = data1;

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
