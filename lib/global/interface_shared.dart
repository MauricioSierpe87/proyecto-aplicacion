import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:leufucadeapp/global/api_public.dart';
import 'package:leufucadeapp/global/api_shared.dart';
import 'package:leufucadeapp/global/interface_private.dart';
import 'package:leufucadeapp/global/interface_shared.dart' as shared;

/// Configura Dio y agrega CookieManager según la plataforma
Dio configureDio() {
  final dio = Dio();
  
  // Solo agrega CookieManager si no es un entorno web
  if (!kIsWeb) {
    final cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
  }

  return dio;
}

/// Solicita el token CSRF al servidor.
Future<String?> Request_Token(Dio dio) async {
  String szUrl = Global_FormatURL(PUBLIC_URLS['GET_CSRF_Token']!['url']);
  String szToken = '';

  try {
    final response = await dio.get(szUrl);

    if (response.data is Map) {
      final jReturn = response.data as Map<String, dynamic>;

      if (jReturn['csrf_token'] != null) {
        szToken = jReturn['csrf_token'];
      }
    }
  } catch (error) {
    debugPrint('Error al obtener el token CSRF: $error');
  }

  return szToken;
}

/// Realiza una solicitud POST con un endpoint específico y datos opcionales.
Future<Map<dynamic, dynamic>> Request_POST(
    BuildContext context, String szEndPoint,
    {Map<String, dynamic>? jData}) async {
  final dio = configureDio(); // Configura Dio según la plataforma

  Map<dynamic, dynamic> jReturn = {'error': "Respuesta del servidor vacía"};
  String? szToken = await Request_Token(dio);

  try {
    if (szToken == null) {
      debugPrint('Token CSRF es nulo');
      return jReturn;
    }

    String szUrl = Global_FormatURL(szEndPoint);

    final response = await dio.post(
      szUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': szToken,
        },
      ),
      data: jData != null ? jsonEncode(jData) : null,
    );

    if (response.statusCode == 200) {
      jReturn = response.data as Map<dynamic, dynamic>;
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
      ),
    );
    debugPrint('Error en la solicitud POST: $error');
  }

  return jReturn;
}

/// Realiza una solicitud de inicio de sesión con los datos proporcionados.
Future<Map<dynamic, dynamic>> Request_Login(
    BuildContext context, Map<String, dynamic> jData) async {
  Map<dynamic, dynamic> fetch_data =
      await Request_POST(context, PUBLIC_URLS['POST_Login']!['url'], jData: jData);
  return fetch_data;
}
