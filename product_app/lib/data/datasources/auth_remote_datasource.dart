import 'package:dio/dio.dart';
import '../models/auth_user.dart';

class AuthRemoteDatasource {
  final Dio dio;
  final String baseUrl = 'https://dummyjson.com/auth';

  AuthRemoteDatasource(this.dio);

  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/login',
        data: {'username': username, 'password': password, 'expiresInMins': 30},
      );

      if (response.statusCode == 200) {
        return AuthUser.fromJson(response.data);
      } else {
        throw Exception('Usuário ou senha inválidos');
      }
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Erro ao realizar login');
    }
  }
}
