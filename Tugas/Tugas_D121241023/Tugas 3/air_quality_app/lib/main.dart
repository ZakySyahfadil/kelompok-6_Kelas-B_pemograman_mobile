
import 'package:flutter/material.dart';
import 'services/air_quality_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const AirQualityApp());
}

class AirQualityApp extends StatelessWidget {
  const AirQualityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Air Quality App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F8F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF167D78),
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AirQualityService _service = AirQualityService();
  final TextEditingController _cityController =
      TextEditingController();

  late Future<Map<String, dynamic>> _airQualityFuture;

  @override
  void initState() {
    super.initState();
    _airQualityFuture = loadInitialAirQuality();
  }

  // Mengambil kota terakhir yang tersimpan
  Future<Map<String, dynamic>> loadInitialAirQuality() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString('last_city') ?? 'Makassar';

    return loadAirQuality(savedCity);
  }

  // Mencari kota dan menyimpan pencarian terakhir
  Future<Map<String, dynamic>> searchAndSaveCity(
    String cityName,
  ) async {
    final result = await loadAirQuality(cityName);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', result['city'] as String);

    return result;
  }

  // Mengambil data dari API
  Future<Map<String, dynamic>> loadAirQuality(
    String cityName,
  ) async {
    final cityData = await _service.searchCity(cityName);

    final latitude =
        (cityData['latitude'] as num).toDouble();
    final longitude =
        (cityData['longitude'] as num).toDouble();

    final results = await Future.wait([
      _service.getAirQuality(latitude, longitude),
      _service.getWeather(latitude, longitude),
    ]);

    final airData = results[0];
    final weatherData = results[1];

    return {
      'city': cityData['name'],
      'country': cityData['country'] ?? '',
      'aqi': airData['us_aqi'],
      'pm25': airData['pm2_5'],
      'pm10': airData['pm10'],
      'temperature': weatherData['temperature_2m'],
      'humidity': weatherData['relative_humidity_2m'],
    };
  }

  // Fungsi pencarian kota
  void searchCity() {
    final cityName = _cityController.text.trim();

    if (cityName.isEmpty) return;

    setState(() {
      _airQualityFuture = searchAndSaveCity(cityName);
    });

    _cityController.clear();
  }

  // Kategori AQI
  String getAqiCategory(int? aqi) {
    if (aqi == null) return 'Tidak tersedia';
    if (aqi <= 50) return 'Baik';
    if (aqi <= 100) return 'Sedang';
    if (aqi <= 150) {
      return 'Tidak Sehat bagi Kelompok Sensitif';
    }
    if (aqi <= 200) return 'Tidak Sehat';
    if (aqi <= 300) return 'Sangat Tidak Sehat';
    return 'Berbahaya';
  }

  // Warna berdasarkan kategori AQI
  Color getAqiColor(int? aqi) {
    if (aqi == null) return const Color(0xFF64748B);
    if (aqi <= 50) return const Color(0xFF16A34A);
    if (aqi <= 100) return const Color(0xFFEAB308);
    if (aqi <= 150) return const Color(0xFFF97316);
    if (aqi <= 200) return const Color(0xFFDC2626);
    if (aqi <= 300) return const Color(0xFF9333EA);
    return const Color(0xFF7F1D1D);
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: const Color(0xFF167D78)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.air_rounded,
                      color: Color(0xFF167D78),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AirWatch',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF183B38),
                        ),
                      ),
                      Text(
                        'Air Quality Monitoring',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                'Pantau kualitas udara,',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF183B38),
                ),
              ),
              const Text(
                'di mana pun kamu berada.',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF167D78),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Dapatkan informasi kualitas udara dan kondisi cuaca terkini.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _cityController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari nama kota...',
                    hintStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF167D78),
                    ),
                    suffixIcon: IconButton(
                      onPressed: searchCity,
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF167D78),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                  ),
                  onSubmitted: (_) => searchCity(),
                ),
              ),

              const SizedBox(height: 30),

              // DATA API
              FutureBuilder<Map<String, dynamic>>(
                future: _airQualityFuture,
                builder: (context, snapshot) {
                  // LOADING
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(55),
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xFF167D78),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Mengambil data kualitas udara...',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // ERROR
                  if (snapshot.hasError) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.cloud_off_rounded,
                            color: Colors.redAccent,
                            size: 48,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Data gagal dimuat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _airQualityFuture =
                                    loadInitialAirQuality();
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  // SUCCESS
                  if (snapshot.hasData) {
                    final data = snapshot.data!;

                    final int? aqi =
                        (data['aqi'] as num?)?.round();

                    final category = getAqiCategory(aqi);
                    final aqiColor = getAqiColor(aqi);

                    return Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // LOKASI
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Color(0xFF167D78),
                              size: 21,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '${data['city']}, ${data['country']}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF183B38),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // KARTU AQI
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: aqiColor,
                            borderRadius:
                                BorderRadius.circular(27),
                            boxShadow: [
                              BoxShadow(
                                color: aqiColor.withValues(alpha: 0.20),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.air_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: 9),
                                  Expanded(
                                    child: Text(
                                      'Air Quality Index',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 28),

                              Text(
                                aqi?.toString() ?? '-',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 76,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 14),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withValues(alpha: 0.20),
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 22),

                              const Divider(
                                color: Colors.white38,
                              ),

                              const SizedBox(height: 8),

                              const Row(
                                children: [
                                  Icon(
                                    Icons.eco_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Indeks kualitas udara saat ini',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // DETAIL POLUTAN
                        const Text(
                          'Detail Polutan',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF183B38),
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          'Konsentrasi partikel di udara',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: detailCard(
                                'PM2.5',
                                data['pm25'],
                                'µg/m³',
                                Icons.grain_rounded,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: detailCard(
                                'PM10',
                                data['pm10'],
                                'µg/m³',
                                Icons.blur_on_rounded,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // KONDISI CUACA
                        const Text(
                          'Kondisi Cuaca',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF183B38),
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          'Informasi kondisi atmosfer',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: detailCard(
                                'Suhu',
                                data['temperature'],
                                '°C',
                                Icons.thermostat_rounded,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: detailCard(
                                'Kelembapan',
                                data['humidity'],
                                '%',
                                Icons.water_drop_rounded,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // FOOTER
                        Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.air_rounded,
                                color: Color(0xFF167D78),
                                size: 25,
                              ),
                              const SizedBox(height: 7),
                              const Text(
                                'AirWatch',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF183B38),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Powered by Open-Meteo API',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return const Center(
                    child: Text('Data tidak tersedia'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET KARTU DETAIL
  Widget detailCard(
    String title,
    dynamic value,
    String unit,
    IconData icon,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 155,
      ),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF167D78)
                  .withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF167D78),
              size: 23,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 5),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value == null
                  ? '-'
                  : (value is num
                      ? value.toStringAsFixed(1)
                      : '$value'),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF183B38),
              ),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            unit,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
