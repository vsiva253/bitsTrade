import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../login/login_page.dart';
import 'register_state_modal.dart';
import 'sign_up_provider.dart';
import '../../utils/text_field_title.dart';

import '../../widgets/loading_button_widget.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerProvider);
    final registerNotifier = ref.read(registerProvider.notifier);

    ref.listen<RegisterState>(registerProvider, (previous, next) {
      if (next.isRegistered ) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Your Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 60),

                // First Name Field
                const textFieldTitle(title: 'First Name'),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'First Name',
                    errorText: registerState.error,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) =>
                      registerNotifier.setFirstName(value),
                ),
                const SizedBox(height: 5,),

                // Last Name Field
                const textFieldTitle(title: 'Last Name'),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Last Name',
                    errorText: registerState.error,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) =>
                      registerNotifier.setLastName(value),
                ),
                const SizedBox(height: 5,),

                // Email Field
                const textFieldTitle(title: 'Email'),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    errorText: registerState.error,
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) => registerNotifier.setEmail(value),
                ),
                const SizedBox(height: 5,),

                // Number Field
                const textFieldTitle(title: 'Phone Number'),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    errorText: registerState.error,
                    prefixIcon: const Icon(Icons.phone_android),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) =>
                      registerNotifier.setPhoneNumber(value),
                ),
                const SizedBox(height: 5,),

                // Password Field
                const textFieldTitle(title: 'Password'),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    errorText: registerState.error,
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) => registerNotifier.setPassword(value),
                ),
                const SizedBox(height: 5,),

                // Confirm Password Field
                const textFieldTitle(title: 'Confirm Password'),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    errorText: registerState.error,
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) =>
                      registerNotifier.setConfirmPassword(value),
                ),
                const SizedBox(height: 30),

                // Register Button
                Center(
                  child: LoadingButton(
                    isLoading: registerState.isLoading,
                    onPressed: () async {
                      await registerNotifier.register();
                    },
                    text: 'Register',
                  ),
                ),
                const SizedBox(height: 20),

                // Divider
               const Row(
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

const SizedBox(height: 20,),
                // sizedLogin Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: registerState.isLoading
                        ? null
                        : () {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
