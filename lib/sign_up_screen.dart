import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_score/services/auth_services.dart';
import 'package:live_score/widgets/center_circular_indicator.dart';
import 'package:live_score/widgets/custo_snk.dart';
import 'package:live_score/widgets/custom_button.dart';
import 'package:live_score/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
      appBar: AppBar(title: const Text('Sign Up'), centerTitle: true),
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
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: _isLoading == false,
                replacement: CenterCircularProgressIndicator(),

                child: CustomButton(
                  buttonName: 'Sign Up',
                  onPressed: _onSignUp,
                ),
              ),
              const SizedBox(height: 20),
              // [NEW] সাইন ইন পেজে ফিরে যাওয়ার বাটন
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Already have an account? Sign In'),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSignUp() async {
    if (_formKey.currentState!.validate()) {
      // Perform sign up logic here
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      try{
        setState(() {
          _isLoading = true;
        });

        //Auth Call
        await _authServices.signUp(email, password);
        if(context.mounted){
          mySnkmsg('Sign Up Successfully', context);
          Navigator.pop(context);
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
