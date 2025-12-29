import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_score/widgets/center_circular_indicator.dart';


class CustomButton extends StatelessWidget {
  final bool isLoading;
  final String buttonName;
  final VoidCallback onPressed;
  final IconData? icon;

  final double? width;
  final double? height;
  final Color? color;


  const CustomButton({
    super.key,
    this.isLoading = false,
    required this.buttonName,
    required this.onPressed,
    this.icon,
    this.width = double.infinity,
    this.height = 50,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: isLoading
          ? CenterCircularProgressIndicator()
          : (icon != null)
          ? FilledButton
          .icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          buttonName,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      )
          : FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttonName,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}