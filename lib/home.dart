import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _toDoList = ["Task 1", "Task 2", "Task 3"];
  TextEditingController _ctrlTask = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("To do list 2")),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: _toDoList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: () {}, title: Text(_toDoList[index]));
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
                      FlatButton(child: Text("Salvar"), onPressed: () {
                        Navigator.pop(context);
                      }),
                    ],
                  );
                });
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 6,
          label: Text("Comprar"),
          icon: Icon(Icons.add_shopping_cart),

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
}
