import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _brandBlue = Color(0xFF1E355D);
const _actionBlue = Color(0xFF2F5DB3);
const _textBlue = Color(0xFF173247);
const _mutedText = Color(0xFF657782);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegistering = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_isRegistering && !_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y el aviso de privacidad.'),
        ),
      );
      return;
    }
    context.go('/dashboard');
  }

  void _setMode(bool registering) {
    if (_isRegistering == registering) {
      return;
    }
    setState(() {
      _isRegistering = registering;
      _acceptTerms = false;
    });
    _formKey.currentState?.reset();
  }

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final showBrandPanel = constraints.maxWidth >= 760;
          return Row(
            children: [
              if (showBrandPanel)
                const Expanded(flex: 11, child: _BrandPanel()),
              Expanded(
                flex: 10,
                child: _FormPanel(
                  isRegistering: _isRegistering,
                  formKey: _formKey,
                  nameController: _nameController,
                  phoneController: _phoneController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  acceptTerms: _acceptTerms,
                  onAcceptTermsChanged: (value) {
                    setState(() => _acceptTerms = value ?? false);
                  },
                  onModeChanged: _setMode,
                  onSubmit: _submit,
                  requiredValidator: _required,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _brandBlue,
      padding: const EdgeInsets.fromLTRB(36, 46, 28, 24),
      child: Stack(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Logo(),
              SizedBox(height: 60),
              Text(
                'Tus paquetes,\nsiempre a la vista',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  height: 1.02,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: 290,
                child: Text(
                  'Registra envíos, deja que llevemos el vehículo ideal\ny sigue cada entrega hasta la puerta.',
                  style: TextStyle(
                    color: Color(0xFFD5DEEC),
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 150,
            child: SizedBox(
              height: 100,
              child: CustomPaint(painter: _RoutePainter()),
            ),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 37,
          height: 37,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.turn_left, color: _actionBlue, size: 27),
        ),
        const SizedBox(width: 12),
        const Text(
          'llevo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final route = Path()
      ..moveTo(12, 72)
      ..cubicTo(size.width * .2, 72, size.width * .27, 15, size.width * .5, 27)
      ..cubicTo(size.width * .7, 39, size.width * .72, 76, size.width - 40, 38);
    final line = Paint()
      ..color = const Color(0xFFB7C4DC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    _drawDashedPath(canvas, route, line);

    canvas.drawCircle(const Offset(12, 72), 13, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(size.width - 40, 38),
      6,
      Paint()..color = const Color(0xFF6EC3FF),
    );
    canvas.drawCircle(
      Offset(size.width - 40, 38),
      3,
      Paint()..color = Colors.white,
    );
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      for (double distance = 0; distance < metric.length; distance += 8) {
        canvas.drawPath(metric.extractPath(distance, distance + 3), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({
    required this.isRegistering,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.acceptTerms,
    required this.onAcceptTermsChanged,
    required this.onModeChanged,
    required this.onSubmit,
    required this.requiredValidator,
  });

  final bool isRegistering;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool acceptTerms;
  final ValueChanged<bool?> onAcceptTermsChanged;
  final ValueChanged<bool> onModeChanged;
  final VoidCallback onSubmit;
  final String? Function(String?, String) requiredValidator;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ModeSelector(
                  isRegistering: isRegistering,
                  onModeChanged: onModeChanged,
                ),
                const SizedBox(height: 27),
                Text(
                  isRegistering ? 'Crea tu cuenta' : 'Inicia sesión',
                  style: const TextStyle(
                    color: _textBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isRegistering
                      ? 'Registra tus envíos y rastrearlos en un solo lugar.'
                      : 'Entra con tu correo y te llevamos a tu panel según tu cuenta.',
                  style: const TextStyle(
                    color: _mutedText,
                    fontSize: 10,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 17),
                if (isRegistering) ...[
                  _Field(
                    label: 'Nombre completo',
                    hint: 'Tu nombre',
                    controller: nameController,
                    validator: (value) =>
                        requiredValidator(value, 'Ingresa tu nombre'),
                  ),
                  const SizedBox(height: 13),
                  _Field(
                    label: 'Teléfono',
                    hint: '443 123 4567',
                    helper: '10 dígitos, para avisarte de tus entregas.',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        requiredValidator(value, 'Ingresa tu teléfono'),
                  ),
                  const SizedBox(height: 13),
                ],
                _Field(
                  label: 'Correo electrónico',
                  hint: 'nombre@correo.com',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      requiredValidator(value, 'Ingresa tu correo'),
                ),
                const SizedBox(height: 13),
                _Field(
                  label: 'Contraseña',
                  hint: isRegistering ? 'Crea una contraseña' : 'Tu contraseña',
                  controller: passwordController,
                  obscureText: true,
                  helper: isRegistering ? 'Mínimo 8 caracteres.' : null,
                  validator: (value) =>
                      requiredValidator(value, 'Ingresa tu contraseña'),
                ),
                if (!isRegistering) ...[
                  const SizedBox(height: 10),
                  const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: _textBlue,
                      fontSize: 10,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
                if (isRegistering) ...[
                  const SizedBox(height: 13),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: acceptTerms,
                        onChanged: onAcceptTermsChanged,
                        visualDensity: VisualDensity.compact,
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 9),
                          child: Text(
                            'Acepto los términos de servicio y el aviso de privacidad.',
                            style: TextStyle(color: _textBlue, fontSize: 9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  height: 41,
                  child: FilledButton(
                    onPressed: onSubmit,
                    style: FilledButton.styleFrom(
                      backgroundColor: _actionBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      isRegistering ? 'Crear mi cuenta' : 'Iniciar sesión',
                    ),
                  ),
                ),
                if (!isRegistering) const _AccountRoles(),
                if (isRegistering) const _RegistrationNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({
    required this.isRegistering,
    required this.onModeChanged,
  });

  final bool isRegistering;
  final ValueChanged<bool> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF9BAEB8)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              label: 'Iniciar sesión',
              selected: !isRegistering,
              onPressed: () => onModeChanged(false),
            ),
          ),
          Expanded(
            child: _ModeButton(
              label: 'Crear una cuenta',
              selected: isRegistering,
              onPressed: () => onModeChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: selected ? _actionBlue : Colors.transparent,
        foregroundColor: selected ? Colors.white : _textBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.zero,
        textStyle: const TextStyle(fontSize: 10),
      ),
      child: Text(label),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    required this.validator,
    this.helper,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final String hint;
  final String? helper;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _textBlue,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 31,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            style: const TextStyle(fontSize: 10, color: _textBlue),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: _mutedText, fontSize: 10),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFFE8ECEE)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFFE8ECEE)),
              ),
              errorStyle: const TextStyle(fontSize: 9, height: .8),
            ),
          ),
        ),
        if (helper != null)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              helper!,
              style: const TextStyle(color: _mutedText, fontSize: 9),
            ),
          ),
      ],
    );
  }
}

class _AccountRoles extends StatelessWidget {
  const _AccountRoles();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 45),
      child: Column(
        children: [
          Divider(color: Color(0xFFF0F1F2)),
          SizedBox(height: 10),
          Text(
            'Según tu cuenta, entrarás a:',
            style: TextStyle(color: _mutedText, fontSize: 8),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Role(
                icon: Icons.grid_view_rounded,
                label: 'Panel de\nadministración',
              ),
              _Role(icon: Icons.inventory_2_outlined, label: 'Mis paquetes'),
              _Role(icon: Icons.map_outlined, label: 'Rutas del día'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Role extends StatelessWidget {
  const _Role({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: _textBlue),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _mutedText, fontSize: 8, height: 1.1),
        ),
      ],
    );
  }
}

class _RegistrationNote extends StatelessWidget {
  const _RegistrationNote();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Color(0xFFF0F1F2)),
          SizedBox(height: 10),
          Text(
            'Aquí solo se crean cuentas de cliente. Las cuentas de\nrepartidor y de administrador las da de alta tu empresa.',
            style: TextStyle(color: _textBlue, fontSize: 8, height: 1.25),
          ),
        ],
      ),
    );
  }
}
