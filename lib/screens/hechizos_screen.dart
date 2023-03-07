import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_app/components/loader_component.dart';
import 'package:harry_potter_app/helpers/api_helper.dart';
import 'package:harry_potter_app/models/models.dart';

class HechizosScreen extends StatefulWidget {
  const HechizosScreen({Key? key}) : super(key: key);

  @override
  State<HechizosScreen> createState() => _HechizosScreenState();
}

class _HechizosScreenState extends State<HechizosScreen> {
//-----------------------------------------------------------------------------
//-------------------------- Definición de Variables --------------------------
//-----------------------------------------------------------------------------
  List<Hechizo> _hechizosAux = [];
  List<Hechizo> _hechizos = [];
  bool _showLoader = false;

//-----------------------------------------------------------------------------
//-------------------------- INIT STATE ---------------------------------------
//-----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getHechizos();
  }

//-----------------------------------------------------------------------------
//-------------------------- Pantalla -----------------------------------------
//-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff7F0909),
      appBar: AppBar(
        title: const Text('Hechizos'),
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
          child: _hechizos.isEmpty ? _noContent() : _getListView(),
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
          const Text("Cantidad de Hechizos: ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text(_hechizos.length.toString(),
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
          'No hay Hechizos registrados',
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
      onRefresh: _getHechizos,
      child: ListView(
        children: _hechizos.map((e) {
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
                                      const Text("Hechizo: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        flex: 5,
                                        child: Text(e.hechizo.toString(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      // const Text("Uso: ",
                                      //     style: TextStyle(
                                      //       fontSize: 12,
                                      //       color: Color(0xFF781f1e),
                                      //       fontWeight: FontWeight.bold,
                                      //     )),
                                      Expanded(
                                        child: Text(e.uso.toString(),
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
//-------------------------- _getHechizos -------------------------------------
//-----------------------------------------------------------------------------

  Future<void> _getHechizos() async {
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

    response = await ApiHelper.getHechizos();

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
      _hechizosAux = response.result;
      _hechizos = [];
      for (var hechizo in _hechizosAux) {
        if (hechizo.uso != null) {
          _hechizos.add(hechizo);
        }
      }

      _hechizos.sort((a, b) {
        return a.hechizo
            .toString()
            .toLowerCase()
            .compareTo(b.hechizo.toString().toLowerCase());
      });
    });
  }
}
