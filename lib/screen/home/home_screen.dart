import 'package:chat_demo/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/constants.dart';
import '../word_game/word_game_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  void _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
        (route) => false);
  }

  void addItem(String name,String lastname) async {
    await _firestore.collection('items').add({'name': name,'lastname':lastname});
    Navigator.pop(context);
    nameController.clear();
    lastNameController.clear();
  }

  void _updateItem(String id,String name,String lastname) async {
    await _firestore.collection('items').doc(id).update({'name': name,'lastname':lastname});
    Navigator.pop(context);
  }

  void _deleteItem(String id) async {
    await _firestore.collection('items').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Word Game'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WordGameScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!.docs;
          List<Widget> itemWidgets = [];
          for (var item in items) {
            final itemName = item['name'];
            final itemLastname = item['lastname'];
            final itemId = item.id;
            itemWidgets.add(
              ListTile(
                title: Text(itemName),
                subtitle:  Text(itemLastname),
                onTap: () {
                  nameController.text = itemName;
                  lastNameController.text = itemLastname;
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      content: Column(mainAxisSize: MainAxisSize.min,children: [
                        const Text(
                          "Edit Details",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                          child: TextFormField(controller: nameController,
                            textInputAction: TextInputAction.done,
                            cursorColor: kPrimaryColor,
                            decoration: const InputDecoration(
                              hintText: 'First name',
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(defaultPadding),
                                child: Icon(Icons.supervised_user_circle_sharp),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                          child: TextFormField(controller: lastNameController,
                            textInputAction: TextInputAction.done,
                            cursorColor: kPrimaryColor,
                            decoration: const InputDecoration(
                              hintText: "Last name",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(defaultPadding),
                                child: Icon(Icons.supervised_user_circle_sharp),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: () {
                            if(nameController.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter first name')),
                              );
                            }else if( lastNameController.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter last name')),
                              );
                            }else{
                              _updateItem(itemId,nameController.text, lastNameController.text);
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryLightColor,
                            elevation: 0,
                          ),
                          child: Text(
                            "Edit".toUpperCase(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],),
                    );
                  },);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteItem(itemId),
                ),
              ),
            );
          }
          return itemWidgets.isNotEmpty
              ? ListView(children: itemWidgets)
              : const Center(child: Text('No Data Found!',style: TextStyle(color: Colors.black,fontSize: 20),));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              content: Column(mainAxisSize: MainAxisSize.min,children: [
                const Text(
                  "ADD Details",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(controller: nameController,
                    textInputAction: TextInputAction.done,
                    cursorColor: kPrimaryColor,
                    decoration: const InputDecoration(
                      hintText: 'First name',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.supervised_user_circle_sharp),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(controller: lastNameController,
                    textInputAction: TextInputAction.done,
                    cursorColor: kPrimaryColor,
                    decoration: const InputDecoration(
                      hintText: "Last name",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.supervised_user_circle_sharp),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () {
                    if(nameController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter first name')),
                      );
                    }else if( lastNameController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter last name')),
                      );
                    }else{
                      addItem(nameController.text, lastNameController.text);
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryLightColor,
                    elevation: 0,
                  ),
                  child: Text(
                    "ADD".toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],),
            );
          },);

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
