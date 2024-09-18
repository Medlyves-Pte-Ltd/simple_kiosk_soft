import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class Success {
  int? code;
  dynamic successResponse;
  Success({this.code, this.successResponse});
}

class Failure {
  int? code;
  dynamic errorResponse;
  Failure({this.code, this.errorResponse});
}

class ApiClient {
  static final dios = Dio();

  static Future<dynamic> getRequest(String url, Options? options) async {
    try {
      final response = await dios.get(url, options: options);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(url);
          print(response);
        }
        return response;
      } else {
        return response;
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          if (kDebugMode) {
            print('Server Error: ${e.response!.statusCode}');
            print('Error Data: ${e.response!.data}');
          }
          return e.response;
        } else {
          if (kDebugMode) {
            print('Network Error: ${e.message}');
          }

          return e.response;
        }
      } else {
        rethrow;
      }
    }
  }

  static Future<dynamic> getRequestWithParams(
      String url, Map<String, dynamic> queryParams) async {
    try {
      final response =
          await dios.get(url, options: Options(), queryParameters: queryParams);
      if (kDebugMode) {
        print("$url  $queryParams");
        print(response);
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response);
        }
        return response;
      } else {
        return response;
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          if (kDebugMode) {
            print('Server Error: ${e.response!.statusCode}');
            print('Error Data: ${e.response!.data}');
          }

          return e.response;
        } else {
          if (kDebugMode) {
            print('Network Error: ${e.message}');
          }

          return e.response;
        }
      } else {
        rethrow;
      }
    }
  }

  static Future<dynamic> postRequest(
      String url, Map<String, dynamic> data) async {
    final options = Options();
    try {
      print("\n$url\n");
      var response = await dios.post(url, options: options, data: data);
      if (kDebugMode) {
        print("\n$url\n");
        print(data);
        print(response);
      }
      return response;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          if (kDebugMode) {
            print('Server Error: ${e.response!.statusCode}');
            print('Error Data: ${e.response!.data}');
          }

          return e.response;
        } else {
          if (kDebugMode) {
            print('Network Error: ${e.message}');
          }

          return e.response;
        }
      } else {
        rethrow;
      }
    }
  }

  static Future<dynamic> postRequestWithParams(String url,
      Map<String, dynamic> data, Map<String, dynamic> queryParams) async {
    try {
      final response = await dios.post(url,
          data: data, options: Options(), queryParameters: queryParams);
      if (kDebugMode) {
        print(url);
        print(queryParams);
        print(response);
      }
      return response;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          if (kDebugMode) {
            print('Server Error: ${e.response!.statusCode}');
            print('Error Data: ${e.response!.data}');
          }

          return e.response;
        } else {
          if (kDebugMode) {
            print('Network Error: ${e.message}');
          }

          return e.response;
        }
      } else {
        rethrow;
      }
    }
  }

  static Future<dynamic> putRequest(String url, dynamic data) async {
    try {
      final response = await dios.put(url, data: data, options: Options());
      if (kDebugMode) {
        print(url);
        print(response);
      }
      return response;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          if (kDebugMode) {
            print('Server Error: ${e.response!.statusCode}');
            print('Error Data: ${e.response!.data}');
          }

          return e.response;
        } else {
          if (kDebugMode) {
            print('Network Error: ${e.message}');
          }

          return e.response;
        }
      } else {
        rethrow;
      }
    }
  }

  static Future<dynamic> deleteRequest(String url) async {
    try {
      final response = await dios.delete(url, options: Options());
      if (kDebugMode) {
        print(url);
        print(response);
      }
      return response;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          if (kDebugMode) {
            print('Server Error: ${e.response!.statusCode}');
            print('Error Data: ${e.response!.data}');
          }

          return e.response;
        } else {
          if (kDebugMode) {
            print('Network Error: ${e.message}');
          }

          return e.response;
        }
      } else {
        rethrow;
      }
    }
  }
}
