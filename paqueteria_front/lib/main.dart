import 'package:flutter/material.dart';

void main() {
  runApp(const PaqueteriaApp());
}

class PaqueteriaApp extends StatelessWidget {
  const PaqueteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logística TWAM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Aquí conectarán su diseño de Figma después
      home: const Scaffold(
        body: Center(
          child: Text('Proyecto Paquetería TWAM - Entorno Limpio'),
        ),
      ),
    );
  }
}