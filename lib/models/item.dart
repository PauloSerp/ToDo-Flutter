class Item {
  String titulo;
  bool done;

  Item({this.titulo, this.done});

  Item.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titulo'] = this.titulo;
    data['done'] = this.done;
    return data;
  }
}
