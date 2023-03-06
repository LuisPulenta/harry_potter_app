class Personaje {
  int id = 0;
  String personaje = '';
  String apodo = '';
  bool estudianteDeHogwarts = false;
  String casaDeHogwarts = '';
  String interpretadoPor = '';
  List<String>? hijos = [];
  String imagen = '';

  Personaje(
      {required this.id,
      required this.personaje,
      required this.apodo,
      required this.estudianteDeHogwarts,
      required this.casaDeHogwarts,
      required this.interpretadoPor,
      required this.hijos,
      required this.imagen});

  Personaje.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personaje = json['personaje'];
    apodo = json['apodo'];
    estudianteDeHogwarts = json['estudianteDeHogwarts'];
    casaDeHogwarts = json['casaDeHogwarts'];
    interpretadoPor = json['interpretado_por'];
    hijos = json['hijos'].cast<String>();
    imagen = json['imagen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['personaje'] = this.personaje;
    data['apodo'] = this.apodo;
    data['estudianteDeHogwarts'] = this.estudianteDeHogwarts;
    data['casaDeHogwarts'] = this.casaDeHogwarts;
    data['interpretado_por'] = this.interpretadoPor;
    data['hijos'] = this.hijos;
    data['imagen'] = this.imagen;
    return data;
  }
}
