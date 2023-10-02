import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback callback;
  final bool? isLiked;
  const ActionButton(
      {super.key, required this.icon, required this.callback, this.isLiked});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(spreadRadius: 5, blurRadius: 5, color: Colors.black38)
            ]),
        child: Material(
            borderRadius: BorderRadius.circular(100),
            shadowColor: Colors.black,
            child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: callback,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: isLiked != null
                        ? Icon(
                            !isLiked! ? Icons.favorite_outline : Icons.favorite,
                            size: 30,
                            color: !isLiked! ? Colors.black : Colors.red)
                        : Icon(icon, size: 30)))));
  }
}
