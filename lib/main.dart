// import 'dart:ffi';

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'consts.dart';
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
  TextEditingController usernameController = TextEditingController(text: 'mario');//'salut'); // Il va stocker username
  TextEditingController passwordController = TextEditingController(text: 'MotDePasseNonSécuris&');//'pass123'); // Il va stocker password

  String _username = '';
  String _password = '';

  // List<Utilisateur> _utilisateurs = [];

  // String usernameEnregistree = '';
  // String passwordEnregistree = '';

  Utilisateur _getinfo(){
  _username = usernameController.text;
  _password = passwordController.text;
  print(_username);
  // print(_password);
  // print([usernameController.text, passwordController.text]);
  return Utilisateur(username: _username, password: _password);
  }


  Future<void> _searchUser() async{
    final temp = _getinfo();
    // print('_searchUser(), $temp');

    final url = Uri.parse('$pat0/utilisateurs/${temp.username}');//10.0.2.2//10.51.4.100//10.52.4.1
    print(url);
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200){
      print('Aucune erreur : ${response.statusCode}');
      final List<dynamic> data = json.decode(response.body);
      final mdp = data[0]['mdp'];
      if (_password == mdp){
        print('Connecté');
        final idrole = data[0]['idRole'];
        if (idrole == 1){
          print('Administrateur');
          // changer d'écran
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return const PageAccueil_admin(title: "Accueil admin");
          }));
        }else{
          print('Pas administrateur');
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return const PageAccueil(title: "Accueil");
          }));
        }
      }else{
        print('Connexion échouée');
      }
    }else{
      print('Erreur : ${response.statusCode}');
    }
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
              // initialValue: 'salut',
              controller: usernameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your username',
              ),
              //textAlign: Center,
            ),
            const Text('Password'),
            TextFormField(
              // initialValue: 'pass123',  // Un champ de texte// https://stackoverflow.com/questions/49125064/how-to-show-hide-password-in-textformfield
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
              heroTag: "btn11",
              onPressed: () async {await _searchUser();},
              tooltip: 'Validate',
              backgroundColor: Colors.green,
              child: const Icon(Icons.check),
            ),
            FloatingActionButton(
                  heroTag: "btn4",
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                    return AjoutUserDetailScreen();//title: "Ajouter produit");
                  })),
                  //MaterialPageRoute(builder: (BuildContext context) => ProduitDetailScreen(produit:liste_produits[index])),
                  tooltip: 'Ajouter',
                  backgroundColor: Colors.green,
                  child: const Text('Ajouter')//Icon(Icons.check),
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
              heroTag: "btn1",
              onPressed: _decrementCounterPositive,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            FloatingActionButton(
              heroTag: "btn2",
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
  String? email;
  String? nom;
  String? prenom;
  int idRole;

  Utilisateur({required this.username, required this.password, 
  this.email, this.nom, this.prenom, this.idRole=2});

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<dynamic, dynamic> toMap(){
    return {
      'username': username,
      'password': password,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'idRole': idRole
      };
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

class PageAccueil_admin extends StatefulWidget {
  const PageAccueil_admin({super.key, required this.title});
  final String title;

  @override
  State<PageAccueil_admin> createState() => _PageAccueilState_admin();
}


class _PageAccueilState_admin extends State<PageAccueil_admin> {
  // var _couleur = const Color.fromARGB(255, 190, 235, 255);
  TextEditingController _productname = TextEditingController();
  List<Produit> liste_produits = [];
  dynamic data = [];
  
  Future<void> _searchProduct() async{
    final url = Uri.parse('$pat0/produits/${_productname.text}');//10.0.2.2//10.51.4.100//10.52.4.1
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
            Row(
              children: [
                FloatingActionButton(
                  heroTag: "btn3",
                  onPressed: () async {await _searchProduct();},// async {await _searchUser();},
                  tooltip: 'Validate',
                  backgroundColor: Colors.green,
                  child: const Text('Chercher'),//Icon(Icons.check),
                ),
                FloatingActionButton(
                  heroTag: "btn4",
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                    return AjoutProduitDetailScreen();//title: "Ajouter produit");
                  })),
                  //MaterialPageRoute(builder: (BuildContext context) => ProduitDetailScreen(produit:liste_produits[index])),
                  tooltip: 'Ajouter',
                  backgroundColor: Colors.green,
                  child: const Text('Ajouter')//Icon(Icons.check),
                ),
              ],
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
    final url = Uri.parse('$pat0/produits/${_productname.text}');//10.0.2.2//10.51.4.100//10.52.4.1
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
            const Text("Connecté"),

            TextFormField(  // Un champ de texte
              controller: _productname,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Search the product',
              ),
            ),
            Row(
              children: [
                FloatingActionButton(
                  heroTag: "btn3",
                  onPressed: () async {await _searchProduct();},// async {await _searchUser();},
                  tooltip: 'Validate',
                  backgroundColor: Colors.green,
                  child: const Text('Chercher'),//Icon(Icons.check),
                ),




              ],
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





class ProduitDetailScreen_admin extends StatefulWidget{
  final Produit produit;
  ProduitDetailScreen_admin({required this.produit});
  @override
  _ProduitDetailScreenState_admin createState() => _ProduitDetailScreenState_admin();
}


class _ProduitDetailScreenState_admin extends State<ProduitDetailScreen>{

  Future<void> updateProduit(
    {int? stock, String? newnom, int? newprix}
  ) async {
    //si les champs textes ne sont pas vides alors
    Uri url = Uri.parse('$pat/change_nom_produit');

    
    
    final headers = {'Content-Type': 'application/json'};
    setState(() {
      if (newnom != null){
        url = Uri.parse('$pat0/change_nom_produit/${widget.produit.nom}/${newnom}');
        widget.produit.nom = newnom;
      }
      if (stock != null){
        url = Uri.parse('$pat0/change_stock_produit');
        widget.produit.stock += stock;
      }
      // print(newnom);
      if (newprix != null){
        url = Uri.parse('$pat0/change_prix_produit/${widget.produit.nom}/$newprix');
        widget.produit.prix = newprix;
      }
      print(url);
    });
    print(widget.produit.toMap());
    final body = json.encode(widget.produit.toMap());
    try {
      final response = await http.post(
      url,
      headers: headers,
      body: body
      );
      if (response.statusCode == 200) {
        print('Produit modifié !');
        print('Réponse: ${response.body}');
      } else {
        print('Échec de la modification, erreur : ${response.statusCode}');
      }
    } catch (e) {
    print('Error: $e');
    }
  }
  TextEditingController _stock = TextEditingController();
  TextEditingController _newnom = TextEditingController();
  TextEditingController _newprix = TextEditingController();

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
              TextFormField(  // Un champ de texte
              controller: _stock,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Stock à ajouter',
                ),
              ),
              Row(
                children: [
                  FloatingActionButton(
                    heroTag: "btn5",
                    onPressed: () => setState(() {
                      int currentStock = int.tryParse(_stock.text) ?? 0;
                      _stock.text = (currentStock - 1).toString();//widget.produit.stock -= 1;
                    }),
                    tooltip: 'Decrement',
                    child: const Icon(Icons.remove),
                  ),
                  FloatingActionButton(
                    heroTag: "btn6",
                    onPressed: () => setState(() {
                      int currentStock = int.tryParse(_stock.text) ?? 0;
                      _stock.text = (currentStock + 1).toString();
                    }),
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              FloatingActionButton(
                heroTag: "btn7",
                onPressed: () => updateProduit(stock:int.parse(_stock.text)),
                //MaterialPageRoute(builder: (BuildContext context) => ProduitDetailScreen(produit:liste_produits[index])),
                tooltip: 'Valider',
                backgroundColor: const Color.fromARGB(255, 0, 255, 77),
                child: const Text('Valider')//Icon(Icons.check),
              ),
              TextFormField(  // Un champ de texte
              controller: _newnom,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nouveau nom',
                ),
              ),
              FloatingActionButton(
                heroTag: "btn8",
                onPressed: () => updateProduit(newnom: _newnom.text),
                //MaterialPageRoute(builder: (BuildContext context) => ProduitDetailScreen(produit:liste_produits[index])),
                tooltip: 'Valider',
                backgroundColor: const Color.fromARGB(255, 0, 255, 77),
                child: const Text('Valider')//Icon(Icons.check),
              ),
              TextFormField(  // Un champ de texte
              controller: _newprix,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nouveau prix',
                ),
              ),
              FloatingActionButton(
                heroTag: "btn9",
                onPressed: () => updateProduit(newprix: int.parse(_newprix.text)),
                //MaterialPageRoute(builder: (BuildContext context) => ProduitDetailScreen(produit:liste_produits[index])),
                tooltip: 'Valider',
                backgroundColor: const Color.fromARGB(255, 0, 255, 77),
                child: const Text('Valider')//Icon(Icons.check),
              ),
            ],
          )
        )
      )
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
  TextEditingController usernameController = TextEditingController(text: 'mario');//'salut'); // Il va stocker username
  TextEditingController passwordController = TextEditingController(text: 'MotDePasseNonSécuris&');//'pass123'); // Il va stocker password

  String _username = '';
  String _password = '';

  // List<Utilisateur> _utilisateurs = [];

  // String usernameEnregistree = '';
  // String passwordEnregistree = '';

  Utilisateur _getinfo(){
  _username = usernameController.text;
  _password = passwordController.text;
  print(_username);
  // print(_password);
  // print([usernameController.text, passwordController.text]);
  return Utilisateur(username: _username, password: _password);
  }

  Future<void> _addtopanier() async{
    final temp = _getinfo();
    // print('_searchUser(), $temp');

    final url = Uri.parse('$pat0/utilisateurs/${temp.username}');//10.0.2.2//10.51.4.100//10.52.4.1
    print(url);
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200){
      print('Aucune erreur : ${response.statusCode}');
      final List<dynamic> data = json.decode(response.body);
      final mdp = data[0]['mdp'];
      if (_password == mdp){
        print('Connecté');
        final idrole = data[0]['idRole'];
        if (idrole == 1){
          print('Administrateur');
          // changer d'écran
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return const PageAccueil_admin(title: "Accueil admin");
          }));
        }else{
          print('Pas administrateur');
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return const PageAccueil(title: "Accueil");
          }));
        }
      }else{
        print('Connexion échouée');
      }
    }else{
      print('Erreur : ${response.statusCode}');
    }
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
              
              FloatingActionButton(
                  heroTag: "btn14",
                  onPressed: () async {await _addtopanier();},// async {await _searchUser();},
                  tooltip: 'Ajouter au panier',
                  backgroundColor: const Color.fromARGB(255, 145, 206, 147),
                  child: const Text('Ajouter au panier'),//Icon(Icons.check),
                ),



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
    final url = Uri.parse('$pat0/insert_or_update_produit');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(pro.toMap());
    print(body);
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
                heroTag: "btn10",
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

class AjoutUserDetailScreen extends StatefulWidget{
  // final String title;//Produit produit;
  AjoutUserDetailScreen();//required this.title});//required this.produit});
  @override
  _AjoutUserDetailScreenState createState() => _AjoutUserDetailScreenState();
}






class _AjoutUserDetailScreenState extends State<AjoutUserDetailScreen>{

  Future<void> ajouterUser(Utilisateur user) async {
    //si les champs textes ne sont pas vides alors
    final url = Uri.parse('$pat0/utilisateurs');
    final headers = {'Content-Type': 'application/json'};
    print(user.toMap());
    final body = json.encode(user.toMap());
    print(body);
    try {
      final response = await http.post(
      url,
      headers: headers,
      body: body
      );
      if (response.statusCode == 200) {
        print('Utilisateur crééé !');
        print('Réponse: ${response.body}');
      } else {
        print('Échec de l\'ajout, erreur : ${response.statusCode}');
      }
    } catch (e) {
    print('Error: $e');
    }
  }
  TextEditingController _username = TextEditingController();
  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _mdp = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _idRole = TextEditingController();

  @override
  void initState(){
    super.initState();
  }


  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter utilisateur'),//widget.movie.titre ?? 'Details du film'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(  // Un champ de texte
              controller: _username,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'username',
                ),
              ),
              TextFormField(  // Un champ de texte
              controller: _nom,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'nom',
                ),
              ),
              TextFormField(  // Un champ de texte
              controller: _prenom,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'prenom',
                ),
              ),
              TextFormField(  // Un champ de texte
              controller: _mdp,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'mot de passe',
                ),
              ),
              TextFormField(  // Un champ de texte
              controller: _email,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'email',
                ),
              ),
              TextFormField(  // Un champ de texte
              controller: _idRole,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'idRole',
                ),
              ),
              FloatingActionButton(
                heroTag: "btn10",
                onPressed: () => ajouterUser(Utilisateur(
                  username: _username.text,
                  password: _mdp.text,
                  nom: _nom.text,
                  prenom: _prenom.text,
                  email: _email.text,
                  idRole: int.parse(_idRole.text)
                  
                //MaterialPageRoute(builder: (BuildContext context) => ProduitDetailScreen(produit:liste_produits[index])),
                // tooltip: 'Ajouter',
                // backgroundColor: Colors.green,
                // child: const Text('Ajouter')//Icon(Icons.check),
              ),))
            ],
          )
        )
      )
    );
    
    }
}