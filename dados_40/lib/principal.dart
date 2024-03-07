import 'package:flutter/material.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("40 Dados"),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: const <Widget>[
          Row(
            children: [
              Text("Ataques"),
            ],
          )
          // input("Fuerza"),
          // input("Penetracion"),
          // input("Daño"),
          // input("Resistencia"),
          // input("Salvacion"),
          // input("Heridas")
        ],
      ),
    );
  }

}
