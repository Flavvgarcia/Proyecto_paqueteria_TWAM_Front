import 'package:flutter/material.dart';
import 'routes/app_routes.dart'; // Importar el router

void main() {
  runApp(const PaqueteriaApp());
}

class PaqueteriaApp extends StatelessWidget {
  const PaqueteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Logística TWAM',
      routerConfig: appRouter, // Usar la configuración del router
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
    );
  }
}
