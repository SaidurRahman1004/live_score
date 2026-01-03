import 'package:flutter/material.dart';
import 'package:live_score/services/auth_services.dart';
import 'package:live_score/widgets/custo_snk.dart';
import 'package:live_score/widgets/custom_button.dart';
import 'package:live_score/widgets/custom_text_field.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _authServices = AuthServices();

  bool _isLoading = false;
  bool _isCodeSent = false; // Flag to track if OTP code has been sent
  String? _verificationId; // Variable to store the verification ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Auth'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isCodeSent) ...[
              CustomTextField(
                controller: _phoneController,
                lableText: "Phone Number (+880...)",
                keyboardType: TextInputType.phone,
                icon: Icons.phone,
              ),
            ],
            if (_isCodeSent) ...[
              CustomTextField(
                controller: _phoneController,
                lableText: "Enter 6-digit OTP",
                keyboardType: TextInputType.phone,
                icon: Icons.phone,
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: _isLoading == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: CustomButton(
                  buttonName: _isCodeSent ? "Verify & Login" : "Send OTP",
                  onPressed: _isCodeSent ? _verifyOtp : _sendOtp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  //Sent Otp Functions
  Future<void> _sendOtp() async {
    String number = _phoneController.text.trim();

    if (number.isEmpty) {
      mySnkmsg("Please enter phone number", context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await _authServices.verifyPhoneNumber(
      phoneNumber: number,
      onCodeSent: (verificationId, resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isCodeSent = true;
          _isLoading = false;
        });
      },
      onVerificationFailed: (e) {
        setState(() {
          _isLoading = false;
        });
        mySnkmsg("Error: ${e.message}", context);
      },
    );
  }

  //Verify Otp Functions
  Future<void> _verifyOtp() async {
    String otp = _otpController.text.trim();
    if (otp.isEmpty) {
      mySnkmsg("Please enter OTP", context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authServices.verifyOtp(
        otp: otp,
        verificationId: _verificationId!,
      );
      if (user != null) {
        if (mounted) {
          mySnkmsg("OTP Verified Successfully", context);
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      }
    } catch (e) {
      if (mounted) mySnkmsg("Invalid OTP or Error", context);
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }
}
