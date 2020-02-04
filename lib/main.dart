import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TODOs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var item = new List<Item>();
  HomePage() {
    item = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCOntroller = TextEditingController();


//functions

  void add() {
    //validação de uma linha se o texto estiver vazio ele retorna sem mudanças
    if (newTaskCOntroller.text.isEmpty) return;

    setState(() {
      widget.item.add(
        Item(
          titulo: newTaskCOntroller.text,
          done: false,
        ),
      );
      newTaskCOntroller.clear();
      save();

    });
    print('add');
  }

  void remove(int index) {
    setState(() {
      widget.item.removeAt(index);
      save();
      print('remove');
    });
  }

  save()async{
    var pref = await SharedPreferences.getInstance();
    await pref.setString('data', jsonEncode(widget.item));
    print('save');
  }

  Future load() async{
    var pref = await SharedPreferences.getInstance();
    var data = pref.getString('data');

    if(data != null){
      Iterable decode = jsonDecode(data);
      List<Item> result = decode.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.item = result;
        print('Carrega principal');
      });
    }
    print('carrega');
  }

  _HomePageState(){
    print("Load Home");
    load();
  }

  @override
  Widget build(BuildContext context) {
    print('principal');
    print(widget.item.length);
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCOntroller,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            labelText: "Adicionar Item",
            labelStyle: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.item.length,
        itemBuilder: (context, index) {
          final item = widget.item[index];
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.titulo),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
            key: Key(item.titulo), //chave unica
            background: Container(
              color: Colors.red.withOpacity(0.2),
            ),
            onDismissed: (direction) {
              //if(direction== DismissDirection.endToStart){}
              remove(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

//end functions

}
