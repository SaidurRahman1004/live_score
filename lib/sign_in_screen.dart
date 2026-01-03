import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_score/phone_auth_screen.dart';
import 'package:live_score/services/auth_services.dart';
import 'package:live_score/sign_up_screen.dart';
import 'package:live_score/widgets/center_circular_indicator.dart';
import 'package:live_score/widgets/custo_snk.dart';
import 'package:live_score/widgets/custom_button.dart';
import 'package:live_score/widgets/custom_text_field.dart';

import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final AuthServices _authServices = AuthServices();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In'), centerTitle: true),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sign Up Screen'),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Email';
                  }
                  return null;
                },
                controller: _emailController,
                lableText: 'Email',
              ),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Password';
                  }
                  return null;
                },
                controller: _passwordController,
                lableText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: _isLoading == false,
                replacement: CenterCircularProgressIndicator(),

                child: CustomButton(
                  buttonName: 'Sign In',
                  onPressed: _onSignIn,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PhoneAuthScreen())
                    );
                  }, label: const Text("Sign in with Phone"),icon: const Icon(Icons.phone),)
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSignIn() async {
    if (_formKey.currentState!.validate()) {
      // Perform sign in logic here
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      try{
        setState(() {
          _isLoading = true;
        });

        //Auth Call
        await _authServices.signIn(email, password);
        if(mounted){
          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
          mySnkmsg('Sign In Successfully', context);
        }

      }on FirebaseException catch(e){
        setState(() {
          _isLoading = false;
        });
        if(context.mounted){
          mySnkmsg('Error: ${e.message}', context);
        }

      }
    }
  }
}
