import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];
  Map<String, dynamic> _removedTask = Map();

  TextEditingController _ctrlTask = TextEditingController();

  Future<File> _getFile() async {
    final folder = await getApplicationDocumentsDirectory();
    return File("${folder.path}/dados.json");
  }

  _saveFile() async {
    var file = await _getFile();

    String data = json.encode(_toDoList);
    file.writeAsString(data);
  }

  _readFile() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  _saveTask() {
    String userInput = _ctrlTask.text;
    Map<String, dynamic> task = Map();
    task["title"] = userInput;
    task["completed"] = false;
    setState(() {
      _toDoList.add(task);
    });
    _saveFile();
    _ctrlTask.text = "";
  }

  @override
  void initState() {
    super.initState();
    _readFile().then((data) {
      print(data);
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    _saveFile();

    return Scaffold(
        appBar: AppBar(title: Text("To do list 2")),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: _toDoList.length,
                  itemBuilder: (context, index) {
                    return buildItemList(context, index);
                  }),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Adicionar tarefa"),
                    content: TextField(
                      controller: _ctrlTask,
                      decoration: InputDecoration(labelText: "Digite a tarefa"),
                      onChanged: (text) {},
                    ),
                    actions: <Widget>[
                      FlatButton(
                          child: Text("Cancelar"),
                          onPressed: () => Navigator.pop(context)),
                      FlatButton(
                          child: Text("Salvar"),
                          onPressed: () {
                            _saveTask();
                            Navigator.pop(context);
                          }),
                    ],
                  );
                });
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 6,
          label: Text("Nova tarefa"),
          icon: Icon(Icons.add),
          // button shadow
//            mini: true,
//            child: Icon(Icons.add)
        ),
        bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Row(
              children: <Widget>[
                IconButton(onPressed: () {}, icon: Icon(Icons.menu))
              ],
            )));
  }

  Widget buildItemList(context, index) {
    final item = _toDoList[index]["title"];
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        // Mantém uma copia temporária do item removido caso ocorra um desfazer
        _removedTask = _toDoList[index];
        _toDoList.removeAt(index);
        _saveFile();

        final snackbar = SnackBar(
          content: Text("Tarefa removida"),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: "Desfazer",
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _toDoList.insert(index, _removedTask);
              });
              _saveFile();
            },
          ),
          backgroundColor: Colors.green,
        );

        Scaffold.of(context).showSnackBar(snackbar);
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            )
          ],
        ),
      ),
      child: CheckboxListTile(
          onChanged: (value) {
            setState(() {
              _toDoList[index]["completed"] = value;
            });
            print(value);
            _saveFile();
          },
          value: _toDoList[index]["completed"],
          title: Text(_toDoList[index]["title"])),
    );
  }
}
