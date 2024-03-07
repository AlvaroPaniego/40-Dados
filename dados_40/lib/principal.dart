import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  List<String> damageList = ["1", "2", "3", "d6", "d3"];
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
        children: <Widget>[
          dataInputs("Ataques", 100.0),
          dataInputs("Fuerza", 25.0),
          dataInputs("Penetración", 5.0),
          dataInputDamage("Daño"),
          dataInputs("Resistencia", 20.0),
          dataInputs("Salvación", 2.0),
        ],
      ),
    );
  }

  dataInputs(text, max) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.blueGrey),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text(text), SpinBox(min: 1, max: max)],
      ),
    );
  }

  dataInputDamage(text) {
    var selectedItem = damageList.first;
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.blueGrey),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(text),
          DropdownButton<String>(
            value: selectedItem,
            items: damageList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedItem = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}
