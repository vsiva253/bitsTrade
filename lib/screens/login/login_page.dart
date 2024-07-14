import 'package:bits_trade/screens/bottombar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/loading_button_widget.dart';
import '../sign_up/sign_up_screen.dart';
import 'login_provider.dart'; // Ensure this path is correct
//import google sign in 
// import 'package:google_sign_in/google_sign_in.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);

    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next.isLogin && next.token != null && next.token!.isNotEmpty) {
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>BottomBar()));
      } 
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to TradeOne!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  loginNotifier.setEmail(value);
                  if (loginState.error != null) {
                    loginNotifier.setError(null);
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  loginNotifier.setPassword(value);
                  if (loginState.error != null) {
                    loginNotifier.setError(null);
                  }
                },
              ),
              const SizedBox(height: 30),
              LoadingButton(
                isLoading: loginState.isLoading,
                onPressed: () async {
                  await loginNotifier.login(context);
                },
                text: 'Login',
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Expanded(
                    child: Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Or'), 
                  ),
                  Expanded(
                    child: Divider(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loginState.isLoading
                      ? null
                      : () {
                     Navigator.push(context, CupertinoPageRoute(builder: (context) => const RegisterScreen()));
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // ElevatedButton(
              //   onPressed: () async {
              //     await _handleSignIn(context); // Trigger Google Sign In
              //   },
              //   child: const Text('Google Sign In'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
//   Future<void> _handleSignIn(BuildContext context) async {
//     final googleSignIn = GoogleSignIn(
//       serverClientId: '948702023927-ggahn8ctcqohh5qcateeo2c5a5j52cjo.apps.googleusercontent.com', // Replace with your Client ID
//     );

//     try {
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser != null) {
//         // Handle the Google Sign In success
//         final googleAuth = await googleUser.authentication;
//         final idToken = googleAuth.idToken;

//         // Now you have the idToken, you can send it to your backend for user authentication and authorization
//         // ...
//         print('ID Token: $idToken');

//         // You can also access user details
//         final user = googleUser;
//         print('User Name: ${user.displayName}');
//         print('User Email: ${user.email}');
//         print('User Photo: ${user.photoUrl}');
//       }
//     } catch (error) {
//       print('Error during Google Sign In: $error');
//       // Handle the error appropriately, show an error message, etc.
//     }
//   }
}