import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/admin/dashboard_screen.dart';
import '../screens/admin/envios_screen.dart';

// Creamos una instancia global de GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: '/login', // Ruta con la que arranca la app
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/envios',
      builder: (context, state) => const EnviosScreen(),
    ),
  ],
);