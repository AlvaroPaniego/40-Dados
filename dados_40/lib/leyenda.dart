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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: Text("Como funcionan las tiradas",
              style: TextStyle(
                fontSize: 25.0,
                ),
              textAlign: TextAlign.end,
              ),
            ),
            
            Flexible(
              child: SingleChildScrollView(
                child: Table(
                  children: [
                    buildTableRow("Si la fuerza es el DOBLE a la resistencia tienes que sacar mas que:", "img/5.png"),
                    buildTableRow("Si la fuerza es MAYOR a la resistencia tienes que sacar mas que:", "img/4.png"),
                    buildTableRow("Si la fuerza es IGUAL a la resistencia tienes que sacar mas que:", "img/3.png"),
                    buildTableRow("Si la fuerza es MENOR a la resistencia tienes que sacar mas que:", "img/2.png"),
                    buildTableRow("Si la fuerza es la MITAD que la resistencia tienes que sacar mas que:", "img/1.png"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TableRow buildTableRow(String texto, String img) {
    return TableRow(
                children: [
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(texto),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(image: AssetImage(img)),
                  )
                ]
              );
  }
}
