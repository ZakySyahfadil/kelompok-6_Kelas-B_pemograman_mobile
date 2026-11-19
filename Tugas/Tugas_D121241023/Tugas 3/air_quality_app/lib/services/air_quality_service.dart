
import 'dart:convert';
import 'package:http/http.dart' as http;

class AirQualityService {
  // Mencari kota berdasarkan nama
  Future<Map<String, dynamic>> searchCity(
    String cityName,
  ) async {
    final url = Uri.https(
      'geocoding-api.open-meteo.com',
      '/v1/search',
      {
        'name': cityName,
        'count': '1',
        'language': 'en',
        'format': 'json',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['results'] == null ||
          (data['results'] as List).isEmpty) {
        throw Exception('Kota tidak ditemukan');
      }

      return data['results'][0];
    } else {
      throw Exception('Gagal mencari kota');
    }
  }

  // Mengambil data kualitas udara
  Future<Map<String, dynamic>> getAirQuality(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.https(
      'air-quality-api.open-meteo.com',
      '/v1/air-quality',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': 'us_aqi,pm2_5,pm10',
        'timezone': 'auto',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['current'] == null) {
        throw Exception('Data kualitas udara tidak tersedia');
      }

      return data['current'];
    } else {
      throw Exception('Gagal mengambil data kualitas udara');
    }
  }


  // Mengambil data suhu dan kelembapan
  Future<Map<String, dynamic>> getWeather(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': 'temperature_2m,relative_humidity_2m',
        'timezone': 'auto',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['current'] == null) {
        throw Exception('Data cuaca tidak tersedia');
      }

      return data['current'];
    } else {
      throw Exception('Gagal mengambil data cuaca');
    }
  }

}
