import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/utils/validators.dart';
import 'providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(authProvider.notifier)
        .forgotPassword(email: _emailController.text.trim());

    if (!mounted) return;

    if (success) {
      setState(() => _emailSent = true);
    } else {
      final authState = ref.read(authProvider);
      SnackbarService.showError(
        authState.errorMessage ?? 'Error al enviar el correo',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _emailSent
                  ? _EmailSentContent(
                      email: _emailController.text.trim(),
                      onResend: () => setState(() => _emailSent = false),
                      onBack: () => context.pop(),
                    )
                  : _ForgotPasswordForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      authState: authState,
                      onSubmit: _handleForgotPassword,
                      theme: theme,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ForgotPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final AuthState authState;
  final VoidCallback onSubmit;
  final ThemeData theme;

  const _ForgotPasswordForm({
    required this.formKey,
    required this.emailController,
    required this.authState,
    required this.onSubmit,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ícono
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_reset_rounded,
              size: 36,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),

          Text(
            '¿Olvidaste tu contraseña?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Ingresa el correo asociado a tu cuenta y te enviaremos instrucciones para restablecerla.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 28),

          // Correo
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmit(),
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: Validators.validateEmail,
            enabled: !authState.isLoading,
          ),
          const SizedBox(height: 24),

          // Enviar
          FilledButton(
            onPressed: authState.isLoading ? null : onSubmit,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
            child: authState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Enviar instrucciones'),
          ),
          const SizedBox(height: 12),

          // Volver
          TextButton.icon(
            onPressed: authState.isLoading ? null : () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Volver al inicio'),
          ),
        ],
      ),
    );
  }
}

class _EmailSentContent extends StatelessWidget {
  final String email;
  final VoidCallback onResend;
  final VoidCallback onBack;

  const _EmailSentContent({
    required this.email,
    required this.onResend,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ícono de éxito
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              size: 40,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Revisa tu correo',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        Text(
          'Enviamos instrucciones a:',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Sigue los pasos del correo para restablecer tu contraseña.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Reenviar
        OutlinedButton(
          onPressed: onResend,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Reenviar'),
        ),
        const SizedBox(height: 12),

        // Volver
        FilledButton(
          onPressed: onBack,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
          child: const Text('Volver al inicio'),
        ),
      ],
    );
  }
}
