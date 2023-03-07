class Hechizo {
  // int id = 0;
  String? hechizo = '';
  String? uso = '';

  Hechizo({required this.hechizo, required this.uso});

  Hechizo.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    hechizo = json['hechizo'];
    uso = json['uso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = id;
    data['hechizo'] = hechizo ?? '';
    data['uso'] = uso ?? '';
    return data;
  }
}
