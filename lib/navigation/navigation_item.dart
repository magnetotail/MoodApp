import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  const NavItem({Key? key, required this.title, required this.icon, required this.widget})
      : super(key: key);
  final String title;
  final IconData icon;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacement( //TODO: find a better way to navigate between Views
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
      },
    );
  }
}
