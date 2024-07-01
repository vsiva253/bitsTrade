
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/loading_button_widget.dart';
import 'login_provider.dart'; // Ensure this path is correct


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);

    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next.isLogin && next.token != null && next.token!.isNotEmpty) {
       context.go('/home');
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
                  await loginNotifier.login();
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
                         context.go('/register');
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
//  ElevatedButton(
//               onPressed: () async {
//                 final accessToken = await GoogleSignIn(
//                   context,
//                   clientId: '948702023927-u4bvpjr4ser10ikinvi7qcsmofg869e9.apps.googleusercontent.com', // Replace with your actual client ID
//                   clientSecret: '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', // Replace with your actual client secret
//                   redirectUri: 'https://dev.bitstrade.in/', // Replace with your custom redirect URI
//                 ).signIn();

//                 if (accessToken != null) {
//                   print('Access token: $accessToken'); 
//                 } else {
//                   print('Sign-in failed.');
//                 }
//               },
//               child: Text('Sign in with Google'),
//             ),
              
            ],
          ),
        ),
      ),
    );
  }
}
