import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harry_potter_app/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFC500),
      appBar: AppBar(
        title: const Text('Harry Potter App'),
        centerTitle: true,
        backgroundColor: const Color(0xff7F0909),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Image(
            image: AssetImage('assets/hp.png'),
          ),
        ),
      ),
      drawer: _getMenu(context),
    );
  }

  Widget _getMenu(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFFC500),
              Color(0xff7F0909),
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff7F0909),
                    Color(0xffFFC500),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 01,
                  ),
                  const Image(
                    image: AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Harry Potter App",
                        style: (TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(
                      Icons.supervisor_account,
                      color: Colors.white,
                    ),
                    tileColor: const Color(0xff8c8c94),
                    title: const Text('Personajes',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonajesScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(
                      Icons.auto_fix_high_rounded,
                      color: Colors.white,
                    ),
                    tileColor: const Color(0xff8c8c94),
                    title: const Text('Hechizos',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HechizosScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              tileColor: const Color(0xff8c8c94),
              title: const Text('Salir',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              onTap: () {
                _logOut();
              },
            ),
          ],
        ),
      ),
    );
  }

//-------------------------------------------------------------------------
//------------------------------ _logOut ----------------------------------
//-------------------------------------------------------------------------

  void _logOut() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
