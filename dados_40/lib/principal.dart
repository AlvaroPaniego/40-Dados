import 'dart:async';
import 'dart:convert';

import 'package:dados_40/gestor_tiradas.dart';
import 'package:dados_40/leyenda.dart';
import 'package:dados_40/sound.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:http/http.dart' as http;

List<String> damageList = ["1", "2", "3", "d6", "d3"];
const KEY = "HUSHYGjaSaAsvp1noG7rTMOT7t1aPthbhvP5j4h1";

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  late Future<Sound> futureSound;
  FlutterSoundPlayer myPlayer = FlutterSoundPlayer();
  Future<Sound> _getSound() async{
    String url = "";
    final response = await http.get(Uri(
        queryParameters: {"token" : KEY},
        scheme: "https",
        path: "/apiv2/sounds/450768/",
        host: "freesound.org"),

    );
    if (response.statusCode == 200){
      String data = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(data);
      url = jsonData["previews"]["preview-hq-mp3"];
    }else{
      throw Exception("Fallo la conexion");
    }
    return Sound(url);
  }
  Duration sensorInterval = SensorInterval.normalInterval;
  String selectedItem = damageList.first;
  String result = "", damage = damageList.first;
  int bs = 2,
      attacks = 1,
      strength = 1,
      toughness = 1,
      save = 2,
      ap = 0,
      invul = 0;
  GestorTiradas gt = GestorTiradas();

  @override
  void initState() {
    super.initState();
    myPlayer.openPlayer();
    futureSound = _getSound();
  }
    @override
    void dispose() {
      // Be careful : you must `close` the audio session when you have finished with it.
      myPlayer.closePlayer();
      super.dispose();
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(96, 110, 140, 1.0),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaginaLeyenda()));
              },
              icon: const Icon(Icons.question_mark_sharp)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
          )
        ],
        title: const Text("40 Dados"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Table(
            children: [
              TableRow(children: <Widget>[
                dataInputs("BS", 6.0, 2.0),
                dataInputs("Ataques", 100.0, 1.0),
              ]),
              TableRow(children: <Widget>[
                dataInputs("Fuerza", 25.0, 1.0),
                dataInputs("Penetración", 5.0, 0.0),
              ]),
              TableRow(children: <Widget>[
                dataInputDamage("Daño"),
                dataInputs("Resistencia", 20.0, 1.0),
              ]),
              TableRow(children: <Widget>[
                dataInputs("Salvación", 7.0, 2.0),
                dataInputs("Salvación invulnerable", 6.0, 0.0),
              ]),
            ],
          ),
          
          FutureBuilder(future: futureSound, builder: (context, snapshot) {
            if(snapshot.hasData){
              return throwDiceButton(snapshot);
            }else if(snapshot.hasError){
              return const Text("Algo salió mal :(");
            }else{
              return throwDiceButtonNoFunctionality();
            }
          },),
          Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.blueGrey),
              padding: const EdgeInsets.all(15.0),
              margin: const EdgeInsets.all(8.0),
              child: Text(result))
        ],
      ),
    );
  }

  TextButton throwDiceButton(snapshot) {
    Sound sound = snapshot.data;
    return TextButton(
          onPressed: () {
            setState(() {
              result = updateResult(
                  bs, attacks, strength, toughness, save, invul, ap, damage);
              myPlayer.startPlayer(fromURI: sound.url);
            });
          },
          child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.grey),
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                "¡Tirar dados!",
                style: TextStyle(color: Colors.black),
              )),
        );
  }

  TextButton throwDiceButtonNoFunctionality() {
    return TextButton(
      onPressed: () {
        setState(() {
          result = updateResult(
              bs, attacks, strength, toughness, save, invul, ap, damage);
        });
      },
      child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              color: Colors.grey),
          padding: const EdgeInsets.all(15.0),
          child: const Text(
            "¡Tirar dados!",
            style: TextStyle(color: Colors.black),
          )),
    );
  }

  dataInputs(String text, double max, double min) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.blueGrey),
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(text),
          SpinBox(
            min: min,
            max: max,
            value: min,
            keyboardType: TextInputType.none,
            onChanged: (value) {
              setState(() {
                switch (text) {
                  case "BS":
                    bs = value.toInt();
                    break;
                  case "Ataques":
                    attacks = value.toInt();
                    break;
                  case "Fuerza":
                    strength = value.toInt();
                    break;
                  case "Penetración":
                    ap = value.toInt();
                    break;
                  case "Resistencia":
                    toughness = value.toInt();
                    break;
                  case "Salvación":
                    save = value.toInt();
                    break;
                  case "Salvación invulnerable":
                    invul = value.toInt();
                    break;
                }
              });
            },
          )
        ],
      ),
    );
  }

  String updateResult(int bs, int attacks, int strength, int toughness,
      int save, int invul, int ap, String damage) {
    int hits = gt.calculateHits(bs, attacks);
    int wounds = gt.calculateWounds(hits, strength, toughness);
    List<int> totalDamage = gt.calculateDamage(damage, wounds, ap, invul, save);
    return "Han impactado $hits\nHan herido $wounds\nEl enemiga a salvado ${wounds-totalDamage[0]}\nLa unidad enemiga sufre ${totalDamage[0]} heridas de $damage de daño (${totalDamage[1]})";
  }

  dataInputDamage(text) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Colors.blueGrey),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(text),
            DropdownButton<String>(
              value: selectedItem,
              icon: const Icon(Icons.arrow_downward),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  selectedItem = value!;
                  damage = value;
                });
              },
              items: damageList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
