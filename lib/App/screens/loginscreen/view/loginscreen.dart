import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projecy/App/core/utils/rounded_icon.dart';
import 'package:projecy/App/routes/app_routes.dart';
import 'package:projecy/App/screens/base_screen/view/base_screen.dart';
import 'package:projecy/App/screens/loginscreen/bloc/loginscreen_bloc.dart';
import 'package:projecy/App/screens/personeldetails/view/personeldetails.dart';
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
  }
  void _onEmailChanged() {
    context.read<LoginscreenBloc>().add(EmailChanged(_emailController.text));
  }
  void _onPasswordChanged() {
    context.read<LoginscreenBloc>().add(
      PasswordChanged(_passwordController.text),
    );
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
    return BaseScreen(
      padding: EdgeInsets.zero,
      body: BlocBuilder<LoginscreenBloc, LoginscreenState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: double.infinity,
                  color: const Color(0xFFFDD835),
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
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: !state.isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            loginBloc.add(
                              PasswordChanged(_passwordController.text.trim()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: state.rememberMe,
                                  onChanged: (bool? newValue) {
                                    loginBloc.add(ToggleRememberMe());
                                    
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
                          ),
                          TextButton(
                            onPressed: () {
                            },
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
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed:
                              state.isLoading
                                  ? null
                                  : () {
                                    loginBloc.add(LoginRequested());
                                    if (state.isLoginSuccess) {
                                      print("when it comes");
                                      Navigator.of(context).pushNamed(Routes.personeldetails);
                                    }
                                    
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFDD835),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child:
                              state.isLoading
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
    );
  }
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
      child: Row(
        children: [
          const SizedBox(width: 15),
          RoundedIconWidget(icon: icon),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade300),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          if (suffixIcon != null) suffixIcon,
          const SizedBox(width: 10),
        ],
      ),
    );
  }
  Widget _buildFooter(LoginscreenBloc loginBloc) {
    return Column(
      children: [
        if (loginBloc.state.errorMessage != null && !loginBloc.state.isLoading)
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              loginBloc.state.errorMessage!,
              style: TextStyle(color: Colors.red.shade700, fontSize: 14),
            ),
          ),
        Row(
          children: [
            const Expanded(child: Divider(color: Colors.grey)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'OR',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Expanded(child: Divider(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
            GestureDetector(
              onTap: () {
                loginBloc.add(LoginRequested());
                print('Navigating to Registration Screen...');
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PersonnelDetails()),
                );
              },
              child: const Text(
                'REGISTER',
                style: TextStyle(
                  color: Color(0xFFFDD835),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
