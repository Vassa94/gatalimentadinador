import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';




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
            borderSide: BorderSide(color: Colors.green),
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
  final TextEditingController racionController = TextEditingController();

  TimeOfDay? horario1;
  TimeOfDay? horario2;
  double racion = 0.0;
  bool isRacionValid = true;

  void validarRacion(String value) {
    final double? racion = double.tryParse(value);
    setState(() {
      isRacionValid = racion != null && racion >= 0 && racion <= 500;
    });
  }

  Future<void> seleccionarHorario1() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: horario1 ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        horario1 = selectedTime;
      });
    }
  }

  Future<void> seleccionarHorario2() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: horario2 ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        horario2 = selectedTime;
      });
    }
  }

  void enviarInformacion() {
    final hour1 = horario1?.hour ?? 0;
    final minute1 = horario1?.minute ?? 0;
    final hour2 = horario2?.hour ?? 0;
    final minute2 = horario2?.minute ?? 0;
    final ration = racion.toInt();

    final formattedHour1 = hour1.toString().padLeft(2, '0');
    final formattedMinute1 = minute1.toString().padLeft(2, '0');
    final formattedHour2 = hour2.toString().padLeft(2, '0');
    final formattedMinute2 = minute2.toString().padLeft(2, '0');

    final url = Uri.parse(
      'http://192.168.1.100/set?hour1=$formattedHour1&minute1=$formattedMinute1&hour2=$formattedHour2&minute2=$formattedMinute2&interval=$ration',
    );

    http.get(url).then((response) {
      if (response.statusCode == 200) {
        // Petición exitosa
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Éxito'),
              content: Text('La información se envió correctamente.(${formattedHour1})'),
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
              content: Text(
                  'Ocurrió un error al enviar la información (${response.statusCode}).'),
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

  void alimentar () {

    final url = Uri.parse(
        'http://192.168.1.100/feed'
    );

    http.get(url).then((response) {
      if (response.statusCode == 200) {
        // Petición exitosa
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Éxito'),
              content: Text('Alimentacion manual exitosa.'),
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
              content: Text(
                  'Ocurrió un error al enviar la información (${response.statusCode}).'),
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
        title: Text('Gatoalimentador-inador 3000'),
        backgroundColor: Colors.black45,

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'Logo.png',
                width: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: seleccionarHorario1,
                  child: Text(
                    horario1 != null
                        ? '1° Horario: ${horario1!.format(context)}'
                        : 'Seleccionar 1° Horario',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isRacionValid ? Colors.grey[300]! : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: seleccionarHorario2,
                  child: Text(
                    horario2 != null
                        ? '2° Horario: ${horario2!.format(context)}'
                        : 'Seleccionar 2° Horario',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isRacionValid ? Colors.grey[300]! : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 200,
            child:Column(
              children: [
              Slider(
              value: racion,
              min: 0.0,
              max: 500.0,
              onChanged: (newValue) {
                setState(() {
                  racion = newValue;
                });
              },
            ),
              Text(
                'Ración: ${racion.toStringAsFixed(0)}', // Muestra el valor seleccionado
                style: TextStyle(fontSize: 16),
                )
              ],
            )
            /*TextField(
              controller: racionController,
              onChanged: validarRacion,
              style: TextStyle(color: Colors.black), // Estilo de texto
              decoration: InputDecoration(
                labelText: 'Ración (gr)',
                errorText: isRacionValid ? null : 'Ingrese una ración válida (0-500)',
              ),
            ),*/
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
                  onPressed: alimentar,
                  child: Text('Alimentar'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.blue, // Color de fondo del pie de página
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cuchuflito Inc.   / Develop by Vassa',
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 16.0, // Tamaño del texto
              ),
            ),
          ],
        ),
      ),

    );
  }
}
