import 'package:flutter/material.dart';
import 'package:todo/pages/casa_page.dart';
import 'package:todo/pages/estudos_page.dart';
import 'package:todo/pages/listacompras_page.dart';
import 'trabalho_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('J2LD Automação'),
              accountEmail: Text('j2ldauto@gmail.com'),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              title: Text(
                'Trabalho',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TrabalhoPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              title: Text(
                'Casa',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CasaPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              title: Text(
                'Lista de Compras',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ListaComprasPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              title: Text(
                'Estudos',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EstudosPage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Tarefas'),
        centerTitle: true,
      ),
    );
  }
}
