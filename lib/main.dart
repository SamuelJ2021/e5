// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Future<void> insertProduit() async {
//   final url = Uri.parse('http://localhost:3000/insert_produit'); // API endpoint

//   // Request body
//   final Map<String, dynamic> data = {
//     "nom": "Produit Test",
//     "prix": 11,
//     "stock": 50
//   };

//   try {
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"}, // Set headers
//       body: jsonEncode(data), // Convert map to JSON string
//     );

//     if (response.statusCode == 200) {
//       print("✅ Success: ${response.body}");
//     } else {
//       print("❌ Error: ${response.statusCode}, ${response.body}");
//     }
//   } catch (e) {
//     print("⚠️ Exception: $e");
//   }
// }


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Samuel',
      theme: ThemeData(
        // This is the theme of your application.
        //
        //
        colorScheme: ColorScheme.fromSeed(seedColor:const Color.fromARGB(255, 0, 0, 255)),//Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'E5 Samuel Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  
  final _couleur1 = const Color.fromARGB(255, 190, 235, 255);
  final _couleur2 = const Color.fromARGB(255, 207, 213, 33);
  var _couleur = const Color.fromARGB(255, 190, 235, 255);

  int _counter = 10;
  TextEditingController usernameController = TextEditingController(); // Il va stocker username
  TextEditingController passwordController = TextEditingController(); // Il va stocker password

  String _username = '';
  String _password = '';

  // List<Utilisateur> _utilisateurs = [];

  // String usernameEnregistree = '';
  // String passwordEnregistree = '';

  Utilisateur _getinfo(){
  _username = usernameController.text;
  _password = passwordController.text;
  print(_username);
  print(_password);
  // print([usernameController.text, passwordController.text]);
  return Utilisateur(username: _username, password: _password);
  }


  Future<void> _searchUser() async{
    final temp = _getinfo();
    // print('_searchUser(), $temp');

    final url = Uri.parse('http://10.0.2.2:3000/utilisateurs/${temp.username}');//10.0.2.2//10.51.4.100//10.52.4.1
    print(url);
    // final response = await http.get(url);
    // print(response.statusCode);
    // if (response.statusCode == 200){
    //   print('Aucune erreur : ${response.statusCode}');
    //   final List<dynamic> data = json.decode(response.body);
      // final mdp = data[0]['mdp'];
      // if (_password == mdp){
      //   print('Connecté');
      //   final idrole = data[0]['idRole'];
      //   if (idrole == 1){
      //     print('Administrateur');
      //     // changer d'écran
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return const PageAccueil(title: "Accueil");
          }));
      //   }else{
      //     print('Pas administrateur');
      //   }
      // }else{
      //   print('Connexion échouée');
      // }
    // }else{
    //   print('Erreur : ${response.statusCode}');
    // }
  }

  // void _sU(String query){
  //   await _searchUser(query);
  // }
  // Future<void> recuperer() async{
  //   String ID = idController.text;
  // }

  void _message(){
    if (_counter > 0){
      _couleur = _couleur1;
    }else{
      _couleur = _couleur2;
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  void _decrementCounter() {
    setState(() {
      _counter-=1;
    });
  }
  void _incrementCounterLimited(){
    int maximum = 100;
    if (_counter < maximum){
      _incrementCounter();
    }
    _message();
  }
  void _decrementCounterPositive(){
    if (_counter > 0){
      _decrementCounter();
    }
    _message();
  }

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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          //
          //
          //
          //
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Username'),
            TextFormField(  // Un champ de texte
              controller: usernameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your username',
              ),
              //textAlign: Center,
            ),
            const Text('Password'),
            TextFormField(  // Un champ de texte// https://stackoverflow.com/questions/49125064/how-to-show-hide-password-in-textformfield
            //keyboardType: TextInputType.text,
            controller: passwordController,
            obscureText: true,//!_passwordVisible,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your password',
              ),
              //textAlign: Center,
            ),
            //Text('Validate'),
            FloatingActionButton(
              onPressed: () async {await _searchUser();},
              tooltip: 'Validate',
              backgroundColor: Colors.green,
              child: const Icon(Icons.check),
            ),



          ],
        ),
      ),
      //
      floatingActionButton: Row(
          //
          //
          //
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _decrementCounterPositive,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            FloatingActionButton(
              onPressed: _incrementCounterLimited,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, 
      backgroundColor: _couleur,// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Utilisateur {
  String? username;
  String? password;

  Utilisateur({required this.username, required this.password});

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      username: json['username'],
      password: json['password'],
    );
  }
}

class Produit {
  String nom;
  int prix;
  int stock;

  Produit({required this.nom, required this.prix, required this.stock});

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      nom: json['nom'],
      prix: json['prix'],
      stock: json['stock']
    );
  }
  @override
  String toString(){
    return "Produit('$nom', $prix, $stock)";
  }
  Map<dynamic, dynamic> toMap(){
    return {
      'nom': nom,
      'prix': prix,
      'stock': stock
      };
  }
}

class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key, required this.title});
  final String title;

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}


class _PageAccueilState extends State<PageAccueil> {
  // var _couleur = const Color.fromARGB(255, 190, 235, 255);
  TextEditingController _productname = TextEditingController();
  List<Produit> liste_produits = [];
  dynamic data = [];
  
  Future<void> _searchProduct() async{
    final url = Uri.parse('http://10.0.2.2:3000/produits/${_productname.text}');//10.0.2.2//10.51.4.100//10.52.4.1
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200){
      print('Aucune erreur : ${response.statusCode}');
      print(response);

      setState(() {
        data = json.decode(response.body);
        liste_produits = [];
        for (var element in data) {
          // print(element);
          liste_produits.add(Produit.fromJson(element));
        }
      });

    }else{
      print('Erreur : ${response.statusCode}');
    }
  }

  // Future<void> ajouterProduit(Produit pro) async {
  //   //si les champs textes ne sont pas vides alors
  //   final url = Uri.parse('http://10.0.2.2:3000/insert_produit');
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = json.encode(pro.toMap());
  //   try {
  //     final response = await http.post(
  //     url,
  //     headers: headers,
  //     body: body
  //     );
  //     if (response.statusCode == 200) {
  //       print('Produit ajouté !');
  //       print('Réponse: ${response.body}');
  //     } else {
  //       print('Échec de l\'ajout, erreur : ${response.statusCode}');
  //     }
  //   } catch (e) {
  //   print('Error: $e');
  //   }
  // }

  // Future<void> _addProduct(Produit pro) async{
  //   final url = Uri.parse('http://10.0.2.2:3000/produits/${pro.nom}');
  //   final response = await http.get(url);
  //   if (response.statusCode == 200 || response.contentLength == 0){
  //     // final url = Uri.parse('http://10.0.2.2:3000/insert_produit/${pro.nom}');
  //     // final ans = await http.post(url);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    
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
            const Text("Connecté en tant qu'administrateur"),

            TextFormField(  // Un champ de texte
              controller: _productname,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Search the product',
              ),
            ),
            FloatingActionButton(
              onPressed: () async {await _searchProduct();},// async {await _searchUser();},
              tooltip: 'Validate',
              backgroundColor: Colors.green,
              child: const Text('Chercher'),//Icon(Icons.check),
            ),
            FloatingActionButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                return AjoutProduitDetailScreen();//title: "Ajouter produit");
              })),
              //MaterialPageRoute(builder: (BuildContext context) => ProduitDetailScreen(produit:liste_produits[index])),
              tooltip: 'Ajouter',
              backgroundColor: Colors.green,
              child: const Text('Ajouter')//Icon(Icons.check),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: liste_produits.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(liste_produits[index].nom),
                    subtitle: Text('${liste_produits[index].prix}€'),//liste_produits[index].prix.toString()),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => ProduitDetailScreen(produit:liste_produits[index])))
                  );
                },
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class ProduitDetailScreen extends StatefulWidget{
  final Produit produit;
  ProduitDetailScreen({required this.produit});
  @override
  _ProduitDetailScreenState createState() => _ProduitDetailScreenState();
}


class _ProduitDetailScreenState extends State<ProduitDetailScreen>{

  @override
  void initState(){
    super.initState();
    print(widget.produit);
  }


  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produit.nom),//widget.movie.titre ?? 'Details du film'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                widget.produit.nom,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  )
                  ),
              Text('${widget.produit.prix}€'),
              Text('${widget.produit.stock} available'),
            ],
          )
        )
      )
    );
    
    }
}

class AjoutProduitDetailScreen extends StatefulWidget{
  // final String title;//Produit produit;
  AjoutProduitDetailScreen();//required this.title});//required this.produit});
  @override
  _AjoutProduitDetailScreenState createState() => _AjoutProduitDetailScreenState();
}

class _AjoutProduitDetailScreenState extends State<AjoutProduitDetailScreen>{

  Future<void> ajouterProduit(Produit pro) async {
    //si les champs textes ne sont pas vides alors
    final url = Uri.parse('http://10.0.2.2:3000/produits');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(pro.toMap());
    try {
      final response = await http.post(
      url,
      headers: headers,
      body: body
      );
      if (response.statusCode == 200) {
        print('Produit ajouté !');
        print('Réponse: ${response.body}');
      } else {
        print('Échec de l\'ajout, erreur : ${response.statusCode}');
      }
    } catch (e) {
    print('Error: $e');
    }
  }
  TextEditingController _productnom = TextEditingController();
  TextEditingController _productprix = TextEditingController();
  TextEditingController _productstock = TextEditingController();

  @override
  void initState(){
    super.initState();
  }


  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter produit'),//widget.movie.titre ?? 'Details du film'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(  // Un champ de texte
              controller: _productnom,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nom du produit',
                ),
              ),
              TextFormField(  // Un champ de texte
              controller: _productprix,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Prix du produit',
                ),
              ),
              TextFormField(  // Un champ de texte
              controller: _productstock,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Stock du produit',
                ),
              ),
              FloatingActionButton(
              onPressed: () => ajouterProduit(Produit(
                nom: _productnom.text,
                prix: int.parse(_productprix.text),
                stock: int.parse(_productstock.text))),
              //MaterialPageRoute(builder: (BuildContext context) => ProduitDetailScreen(produit:liste_produits[index])),
              tooltip: 'Ajouter',
              backgroundColor: Colors.green,
              child: const Text('Ajouter')//Icon(Icons.check),
            ),
            ],
          )
        )
      )
    );
    
    }
}