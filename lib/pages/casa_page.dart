import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/item_casa.dart';

class CasaPage extends StatefulWidget {
  // ignore: deprecated_member_use
  var items = new List<ItemCasa>();
  CasaPage() {
    items = [];
    //items.add(Item(title: "Item 1", done: false));
    //items.add(Item(title: "Item 2", done: true));
    //items.add(Item(title: "Item 3", done: false));
  }
  @override
  _CasaPageState createState() => _CasaPageState();
}

class _CasaPageState extends State<CasaPage> {
  var newTaskCtrlCasa = new TextEditingController();

  void addCasa() {
    if (newTaskCtrlCasa.text.isEmpty) return;
    setState(() {
      widget.items.add(
        ItemCasa(
          title: newTaskCtrlCasa.text,
          done: false,
        ),
      );
      newTaskCtrlCasa.text = "";
      saveCasa();
    });
  }

  void removeCasa(int index) {
    setState(() {
      widget.items.removeAt(index);
      saveCasa();
    });
  }

  Future loadCasa() async {
    var prefsCasa = await SharedPreferences.getInstance();
    var dataCasa = prefsCasa.getString('dataCasa');
    if (dataCasa != null) {
      Iterable decoded = jsonDecode(dataCasa);
      List<ItemCasa> resultCasa =
          decoded.map((x) => ItemCasa.fromJson(x)).toList();
      setState(() => widget.items = resultCasa);
    }
  }

  saveCasa() async {
    var prefsCasa = await SharedPreferences.getInstance();
    await prefsCasa.setString('dataCasa', jsonEncode(widget.items));
  }

  _CasaPageState() {
    loadCasa();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addCasa,
          ),
        ],
        title: Text("Tarefas - Casa"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            child: TextFormField(
              controller: newTaskCtrlCasa,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20),
                hintText: "Nova Tarefa:",
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
                        saveCasa();
                      });
                    },
                  ),
                  key: Key(item.title),
                  onDismissed: (direction) {
                    removeCasa(index);
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
