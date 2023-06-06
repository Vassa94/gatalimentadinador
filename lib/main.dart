import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gatalimentadinador',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController horario1Controller = TextEditingController();
  final TextEditingController horario2Controller = TextEditingController();
  final TextEditingController racionController = TextEditingController();

  bool isHorario1Valid = true;
  bool isHorario2Valid = true;
  bool isRacionValid = true;

  void validarHorario1(String value) {
    final int? horario = int.tryParse(value);
    setState(() {
      isHorario1Valid = horario != null && horario >= 1 && horario <= 24;
    });
  }

  void validarHorario2(String value) {
    final int? horario = int.tryParse(value);
    setState(() {
      isHorario2Valid = horario != null && horario >= 1 && horario <= 24;
    });
  }

  void validarRacion(String value) {
    final double? racion = double.tryParse(value);
    setState(() {
      isRacionValid = racion != null && racion >= 0 && racion <= 500;
    });
  }

  void enviarInformacion() {
    final hour1 = horario1Controller.text.trim();
    final hour2 = horario2Controller.text.trim();
    final ration = int.tryParse(racionController.text.trim());
    final interval = ((ration! * 5000)/60);

    final url = Uri.parse('http://192.168.1.100/set?hour1=$hour1&hour2=$hour2&interval=$interval');

    http.get(url).then((response) {
      if (response.statusCode == 200) {
        // Petición exitosa
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Éxito'),
              content: Text('La información se envió correctamente.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Error en la petición
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Ocurrió un error al enviar la información (${response.statusCode}).'),
              actions: <Widget>[
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      // Error de conexión
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error de conexión: $error'),
            actions: <Widget>[
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gatalimentadinador 3000'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:Image.asset(
                'Logo.png',
                width: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 200,
                child: TextField(
                  controller: horario1Controller,
                  onChanged: validarHorario1,
                  decoration: InputDecoration(
                    labelText: '1° Horario (Hs)',
                    errorText: isHorario1Valid ? null : 'Ingrese un horario válido (1-24)',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 200,
                child: TextField(
                  controller: horario2Controller,
                  onChanged: validarHorario2,
                  decoration: InputDecoration(
                    labelText: '2° Horario (Hs)',
                    errorText: isHorario2Valid ? null : 'Ingrese un horario válido (1-24)',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 200,
                child: TextField(
                  controller: racionController,
                  onChanged: validarRacion,
                  decoration: InputDecoration(
                    labelText: 'Ración (gr)',
                    errorText: isRacionValid ? null : 'Ingrese una ración válida (0-500)',
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: enviarInformacion,
                  child: Text('Enviar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para alimentar
                  },
                  child: Text('Alimentar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
