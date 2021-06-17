import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/item_trab.dart';
import 'package:todo/pages/casa_page.dart';

class TrabalhoPage extends StatefulWidget {
  // ignore: deprecated_member_use
  var items = new List<ItemTrab>();
  TrabalhoPage() {
    items = [];
    //items.add(Item(title: "Item 1", done: false));
    //items.add(Item(title: "Item 2", done: true));
    //items.add(Item(title: "Item 3", done: false));
  }

  @override
  _TrabalhoPageState createState() => _TrabalhoPageState();
}

class _TrabalhoPageState extends State<TrabalhoPage> {
  var newTaskCtrlTrab = new TextEditingController();

  void addTrab() {
    if (newTaskCtrlTrab.text.isEmpty) return;
    setState(() {
      widget.items.add(
        ItemTrab(
          title: newTaskCtrlTrab.text,
          done: false,
        ),
      );
      newTaskCtrlTrab.text = "";
      saveTrab();
    });
  }

  void removeTrab(int index) {
    setState(() {
      widget.items.removeAt(index);
      saveTrab();
    });
  }

  Future loadTrab() async {
    var prefsTrab = await SharedPreferences.getInstance();
    var dataTrab = prefsTrab.getString('dataTrab');
    if (dataTrab != null) {
      Iterable decoded = jsonDecode(dataTrab);
      List<ItemTrab> resultTrab =
          decoded.map((x) => ItemTrab.fromJson(x)).toList();
      setState(() => widget.items = resultTrab);
    }
  }

  saveTrab() async {
    var prefsTrab = await SharedPreferences.getInstance();
    await prefsTrab.setString('dataTrab', jsonEncode(widget.items));
  }

  _TrabalhoPageState() {
    loadTrab();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addTrab,
          ),
        ],
        title: Text("Tarefas - Trabalho"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            child: TextFormField(
              controller: newTaskCtrlTrab,
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
                        saveTrab();
                      });
                    },
                  ),
                  key: Key(item.title),
                  onDismissed: (direction) {
                    removeTrab(index);
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
