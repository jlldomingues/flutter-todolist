import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/item_estudos.dart';

// ignore: must_be_immutable
class EstudosPage extends StatefulWidget {
  // ignore: deprecated_member_use
  var items = new List<ItemEstudos>();
  EstudosPage() {
    items = [];
    //items.add(Item(title: "Item 1", done: false));
    //items.add(Item(title: "Item 2", done: true));
    //items.add(Item(title: "Item 3", done: false));
  }
  @override
  _EstudosPageState createState() => _EstudosPageState();
}

class _EstudosPageState extends State<EstudosPage> {
  var newTaskCtrlEstudos = new TextEditingController();

  void addEstudos() {
    if (newTaskCtrlEstudos.text.isEmpty) return;
    setState(() {
      widget.items.add(
        ItemEstudos(
          title: newTaskCtrlEstudos.text,
          done: false,
        ),
      );
      newTaskCtrlEstudos.text = "";
      saveEstudos();
    });
  }

  void removeEstudos(int index) {
    setState(() {
      widget.items.removeAt(index);
      saveEstudos();
    });
  }

  Future loadEstudos() async {
    var prefsEstudos = await SharedPreferences.getInstance();
    var dataEstudos = prefsEstudos.getString('dataEstudos');
    if (dataEstudos != null) {
      Iterable decoded = jsonDecode(dataEstudos);
      List<ItemEstudos> resultEstudos =
          decoded.map((x) => ItemEstudos.fromJson(x)).toList();
      setState(() => widget.items = resultEstudos);
    }
  }

  saveEstudos() async {
    var prefsEstudos = await SharedPreferences.getInstance();
    await prefsEstudos.setString('dataEstudos', jsonEncode(widget.items));
  }

  _EstudosPageState() {
    loadEstudos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addEstudos,
          ),
        ],
        title: Text("Tarefas - Estudos"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            child: TextFormField(
              controller: newTaskCtrlEstudos,
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
                        saveEstudos();
                      });
                    },
                  ),
                  key: Key(item.title),
                  onDismissed: (direction) {
                    removeEstudos(index);
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
