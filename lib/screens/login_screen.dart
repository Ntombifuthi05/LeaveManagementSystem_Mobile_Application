// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:leavemanagementsystem/screens/dashboard_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//   String? _error;

//   Future<void> _login() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LeaveDashboardScreen()),
//       );
//     } on FirebaseAuthException catch (e) {
//       setState(() => _error = e.message);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Employee Login'),
//         backgroundColor: Colors.blue,
//       ),
//       backgroundColor: Colors.blue,
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/Logo_LMS.png', width: 150, height: 150),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: 'Password'),
//             ),

//             const SizedBox(height: 20),
//             if (_error != null)
//               Text(_error!, style: const TextStyle(color: Colors.red)),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _login,
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//               child: _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   :  Text('Login', style: const TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leavemanagementsystem/screens/dashboard_screen.dart';
import 'package:leavemanagementsystem/viewmodels/notification_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    final notifVM = Provider.of<NotificationViewModel>(context, listen: false);
    Future.microtask(() => notifVM.init());
  }
  String? _error;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LeaveDashboardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black54),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30), // 👈 Rounded corners
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4FA8F0), // nice blue gradient tone
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Logo_LMS.png',
                  width: 150, height: 150),
              const SizedBox(height: 30),

              // Email field
              TextField(
                controller: _emailController,
                decoration: _inputDecoration('Email'),
              ),
              const SizedBox(height: 20),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration('Password'),
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Log In',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
