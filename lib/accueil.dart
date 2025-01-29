class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key, required this.title});
  final String title;

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}


class _PageAccueilState extends State<PageAccueil> {
  
  final _couleur1 = const Color.fromARGB(255, 190, 235, 255);
  final _couleur2 = const Color.fromARGB(255, 207, 213, 33);
  var _couleur = const Color.fromARGB(255, 190, 235, 255);

  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    //
    return Scaffold(
      appBar: AppBar(
        //
        backgroundColor: const Color.fromARGB(255, 80, 163, 219),//Theme.of(context).colorScheme.inversePrimary,
        //
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Connecté en tant qu'administrateur"),
          ],
        ),
      ),
    );
  }
}