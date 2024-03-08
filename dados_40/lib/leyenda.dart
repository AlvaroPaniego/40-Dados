import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaginaLeyenda extends StatelessWidget {
  const PaginaLeyenda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(96, 110, 140, 1.0),
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text("Como funcionan las tiradas",
            style: TextStyle(
              fontSize: 25.0,
              ),
            textAlign: TextAlign.end,
            ),
            Table(
              children: const [
                TableRow(
                  children: [
                    Text("Si la fuerza es el DOBLE a la resistencia"),
                    Image(image: AssetImage("img/1.png"))
                  ]
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
