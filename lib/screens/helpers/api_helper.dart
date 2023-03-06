import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:harry_potter_app/models/models.dart';
import 'constants.dart';

class ApiHelper {
//---------------------------------------------------------------------------
  static Future<Response> getPersonajes() async {
    var url = Uri.parse(Constants.apiUrlPersonajes);
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Personaje> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Personaje.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getHechizos() async {
    var url = Uri.parse(Constants.apiUrlHechizos);
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Hechizo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Hechizo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }
}
