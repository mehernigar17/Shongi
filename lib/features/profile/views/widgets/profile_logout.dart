import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback onTap;

  const SignOutButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xffFFF0F3),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              size: 20,
              color: Color(0xffF06292),
            ),
            SizedBox(width: 8),
            Text(
              "Sign Out",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xffF06292),
              ),
            ),
          ],
        ),
      ),
    );
  }
}