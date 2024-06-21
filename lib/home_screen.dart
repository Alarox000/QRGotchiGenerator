import 'package:convert/convert.dart';
import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";
import 'dart:math'; // Importa la librería para generar números aleatorios
import 'dart:convert'; // Importa la librería para codificar a base64
import 'package:shared_preferences/shared_preferences.dart'; // Importa la librería para almacenamiento persistente

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey globalKey = GlobalKey();
  String qrData = "";
  String uniqueIdentifier = "";

  @override
  void initState() {
    super.initState();
    _initializeIdentifier();
  }

  Future<void> _initializeIdentifier() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedIdentifier = prefs.getString('uniqueIdentifier');

    if (storedIdentifier == null) {
      storedIdentifier = _generateUniqueIdentifier();
      await prefs.setString('uniqueIdentifier', storedIdentifier);
    }

    setState(() {
      uniqueIdentifier = storedIdentifier!;
      qrData = _generateQrData();
    });
  }

  String _generateUniqueIdentifier() {
    var randomBytes = List<int>.generate(16, (i) => Random().nextInt(256));
    var hashHex = hex.encode(randomBytes);
    return hashHex.substring(0, 10);
  }

  String _generateQrData() {
    int randomNumber = _generateRandomNumber();
    return "$uniqueIdentifier$randomNumber$uniqueIdentifier";
  }

  int _generateRandomNumber() {
    Random random = Random();
    int min = 2; // Correspondiente a 10 (10 / 5 = 2)
    int max = 10; // Correspondiente a 50 (50 / 5 = 10)
    int randomMultiple = min + random.nextInt(max - min + 1);
    return randomMultiple *
        5; // Multiplica el número aleatorio por 5 para obtener el múltiplo de 5
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/Logo_Plantigotchi.png',
              height: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Generador QR Plantigotchi",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            RepaintBoundary(
              key: globalKey,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        "¡Escanea y consigue puntos!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 300,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/images/Logo_PlantigotchiOscuro.png',
                        height: 300,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
