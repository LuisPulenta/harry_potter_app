import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_app/components/loader_component.dart';
import 'package:harry_potter_app/helpers/api_helper.dart';
import 'package:harry_potter_app/models/models.dart';

class PersonajesScreen extends StatefulWidget {
  const PersonajesScreen({Key? key}) : super(key: key);

  @override
  State<PersonajesScreen> createState() => _PersonajesScreenState();
}

class _PersonajesScreenState extends State<PersonajesScreen> {
//-----------------------------------------------------------------------------
//-------------------------- Definición de Variables --------------------------
//-----------------------------------------------------------------------------
  List<Personaje> _personajes = [];
  bool _showLoader = false;

//-----------------------------------------------------------------------------
//-------------------------- INIT STATE ---------------------------------------
//-----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getPersonajes();
  }

//-----------------------------------------------------------------------------
//-------------------------- Pantalla -----------------------------------------
//-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff7F0909),
      appBar: AppBar(
        title: const Text('Personajes'),
        centerTitle: true,
        backgroundColor: const Color(0xff7F0909),
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ _getContent ----------------------------------
//-----------------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showPersonajesCount(),
        Expanded(
          child: _personajes.isEmpty ? _noContent() : _getListView(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ _showPersonajesCount -------------------------
//-----------------------------------------------------------------------------

  Widget _showPersonajesCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text("Cantidad de Personajes: ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text(_personajes.length.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ _noContent -----------------------------------
//-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay Personajes registrados',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ _getListView ---------------------------------
//-----------------------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getPersonajes,
      child: ListView(
        children: _personajes.map((e) {
          return Card(
            color: const Color(0xffFFC500),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                // obraSelected = e;
                // _goInfoObra(e);
              },
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    // CircleAvatar(
                    //   backgroundImage: NetworkImage(e.imagen.toString()),
                    //   maxRadius: 40,
                    // ),
                    Image.network(
                      e.imagen.toString(),
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text("Personaje: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        flex: 5,
                                        child: Text(e.personaje.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Apodo: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child: Text(e.apodo.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Casa de Hogwarts:: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child: Text(e.casaDeHogwarts.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Interpretado por: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child:
                                            Text(e.interpretadoPor.toString(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

//-----------------------------------------------------------------------------
//-------------------------- _getPersonajes -----------------------------------
//-----------------------------------------------------------------------------

  Future<void> _getPersonajes() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getPersonajes();

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _personajes = response.result;
      _personajes.sort((a, b) {
        return a.apodo
            .toString()
            .toLowerCase()
            .compareTo(b.apodo.toString().toLowerCase());
      });
    });

    var a = 1;
  }
}
