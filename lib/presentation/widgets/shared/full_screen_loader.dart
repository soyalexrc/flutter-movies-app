import 'package:flutter/material.dart';

class FullScreenloader extends StatelessWidget {
  const FullScreenloader({Key? key}) : super(key: key);


  Stream<String> getLoadingMessages() {
    final  messages = <String>[
      'Cargando peliculas',
      'Comprando palomitas de maiz',
      'Cargando populares',
      'Llamando a mi novia',
      'Ya mero...',
      'Esto esta tardando mas de lo debido :('
    ];
    
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Espere por favor'),
          SizedBox(height: 10,),
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(height: 10,),
          StreamBuilder(
            stream: getLoadingMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('Cargando...');

                return Text('${snapshot.data}');
              }
          )
        ],
      )
    );
  }
}
