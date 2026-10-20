import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EnviosScreen extends StatelessWidget {
  const EnviosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envíos'),
        leading: BackButton(onPressed: () => context.go('/dashboard')),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_shipping_outlined, size: 64),
            const SizedBox(height: 16),
            Text(
              'No hay envíos registrados',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Aquí aparecerá la lista de paquetes.'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('La creación de envíos estará disponible pronto.'),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Nuevo envío'),
            ),
          ],
        ),
      ),
    );
  }
}
