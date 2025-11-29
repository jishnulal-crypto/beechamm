import 'package:flutter/material.dart';
class RoundedIconWidget extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color iconColor;
  final Color backgroundColor;
  const RoundedIconWidget({
    super.key,
    this.icon = Icons.email_outlined,  
    this.size = 50.0,
    this.iconColor = const Color(0xFF555555),  
    this.backgroundColor = Colors.white,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),  
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: size * 0.5,  
        ),
      ),
    );
  }
}
