import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/item_compras.dart';

// ignore: must_be_immutable
class ListaComprasPage extends StatefulWidget {
  // ignore: deprecated_member_use
  var items = new List<ItemCompras>();
  ListaComprasPage() {
    items = [];
    //items.add(Item(title: "Item 1", done: false));
    //items.add(Item(title: "Item 2", done: true));
    //items.add(Item(title: "Item 3", done: false));
  }
  @override
  _ListaComprasPageState createState() => _ListaComprasPageState();
}

class _ListaComprasPageState extends State<ListaComprasPage> {
  var newTaskCtrlCompras = new TextEditingController();

  void addCompras() {
    if (newTaskCtrlCompras.text.isEmpty) return;
    setState(() {
      widget.items.add(
        ItemCompras(
          title: newTaskCtrlCompras.text,
          done: false,
        ),
      );
      newTaskCtrlCompras.text = "";
      saveCompras();
    });
  }

  void removeCompras(int index) {
    setState(() {
      widget.items.removeAt(index);
      saveCompras();
    });
  }

  Future loadCompras() async {
    var prefsCompras = await SharedPreferences.getInstance();
    var dataCompras = prefsCompras.getString('dataCompras');
    if (dataCompras != null) {
      Iterable decoded = jsonDecode(dataCompras);
      List<ItemCompras> resultCompras =
          decoded.map((x) => ItemCompras.fromJson(x)).toList();
      setState(() => widget.items = resultCompras);
    }
  }

  saveCompras() async {
    var prefsCompras = await SharedPreferences.getInstance();
    await prefsCompras.setString('dataCompras', jsonEncode(widget.items));
  }

  _ListaComprasPageState() {
    loadCompras();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addCompras,
          ),
        ],
        title: Text("Lista de Compras"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            child: TextFormField(
              controller: newTaskCtrlCompras,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20),
                hintText: "Novo Item:",
                labelStyle: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            height: 50,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (BuildContext ctxt, int index) {
                final item = widget.items[index];
                return Dismissible(
                  child: CheckboxListTile(
                    title: Text(item.title),
                    value: item.done,
                    onChanged: (value) {
                      setState(() {
                        item.done = value;
                        saveCompras();
                      });
                    },
                  ),
                  key: Key(item.title),
                  onDismissed: (direction) {
                    removeCompras(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
