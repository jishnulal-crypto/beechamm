import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projecy/App/screens/base_screen/view/base_screen.dart';
import 'package:projecy/App/screens/loginscreen/bloc/loginscreen_bloc.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});
  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    
    // Load remembered credentials when screen starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RememberMeBloc>().add(LoadCredentials());
    });
  }

  void _onEmailChanged() {
    context.read<LoginscreenBloc>().add(EmailChanged(_emailController.text));
  }

  void _onPasswordChanged() {
    context.read<LoginscreenBloc>().add(
      PasswordChanged(_passwordController.text),
    );
  }

  void _handleLogin(BuildContext context, LoginscreenBloc loginBloc) {
    loginBloc.add(LoginRequested(
    ));
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _passwordController.removeListener(_onPasswordChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginscreenBloc>();
    
    return MultiBlocListener(
      listeners: [
        // Listen for remembered credentials to auto-fill
        BlocListener<RememberMeBloc, RememberMeState>(
          listener: (context, rememberState) {
            if (rememberState.hasSavedCredentials && 
                _emailController.text.isEmpty) {
              _emailController.text = rememberState.savedEmail;
              _passwordController.text = rememberState.savedPassword;
              
              // Update login bloc with the filled data
              context.read<LoginscreenBloc>().add(EmailChanged(rememberState.savedEmail));
              context.read<LoginscreenBloc>().add(PasswordChanged(rememberState.savedPassword));
            }
          },
        ),
        
        // Listen for login success
        BlocListener<LoginscreenBloc, LoginscreenState>(
          listener: (context, loginState) {
            if (loginState.isLoginSuccess) {
              final rememberState = context.read<RememberMeBloc>().state;
              
              // Save credentials if remember me is enabled
              if (rememberState.isEnabled) {
                context.read<RememberMeBloc>().add(
                  SaveCredentials(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ),
                );
              }
              
              // Navigate to home screen
              Navigator.pushReplacementNamed(context, '/personeldetails');
            }
            
            // Show error message if login fails
            if (loginState.errorMessage != null && loginState.errorMessage!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loginState.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        
        // Listen for password visibility changes (optional)
        BlocListener<PasswordVisibilityBloc, PasswordVisibilityState>(
          listener: (context, visibilityState) {
            // You can add any side effects for visibility changes here
          },
        ),
      ],
      child: BaseScreen(
        padding: EdgeInsets.zero,
        body: BlocBuilder<LoginscreenBloc, LoginscreenState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Your existing header section
                  Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              'assets/images/Frame 18338.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            Image.asset(
                              'assets/images/Vector.png',
                              height: 80,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 80);
                              },
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'BEE CHEM',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Login to your account',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'Email address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        
                        // Password field with visibility toggle
                        BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
                          builder: (context, visibilityState) {
                            return _buildTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: !visibilityState.isObscured,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  visibilityState.isObscured
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  context.read<PasswordVisibilityBloc>().add(
                                    TogglePasswordVisibility(),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        
                        // Remember Me row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Remember Me Checkbox using RememberMeBloc
                            BlocBuilder<RememberMeBloc, RememberMeState>(
                              builder: (context, rememberState) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: rememberState.isEnabled,
                                        onChanged: (bool? newValue) {
                                          context.read<RememberMeBloc>().add(
                                            RememberMeToggled(newValue ?? false),
                                          );
                                        },
                                        activeColor: const Color(0xFFFDD835),
                                        side: const BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Remember me',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'FORGOT PASSWORD?',
                                style: TextStyle(
                                  color: Color(0xFFFDD835),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                  _handleLogin(context, loginBloc);
                                },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFDD835),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        _buildFooter(loginBloc),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Your existing _buildTextField method
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 70, right: 50),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
              ),
            ),
          ),
          Positioned(
            left: -15,
            top: -5,
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 28, color: Colors.black),
            ),
          ),
          if (suffixIcon != null)
            Positioned(right: 10, top: 0, bottom: 0, child: suffixIcon),
        ],
      ),
    );
  }

  Widget _buildFooter(LoginscreenBloc loginBloc) {
    return const Column(
      children: [
        // Your footer content
      ],
    );
  }
}