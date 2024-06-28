import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordGameScreen extends StatefulWidget {
  @override
  _WordGameScreenState createState() => _WordGameScreenState();
}

class _WordGameScreenState extends State<WordGameScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _wordController = TextEditingController();
  int _score = 0;
  String _feedback = '';
  final _auth = FirebaseAuth.instance;

  void _checkWord() async {
    final word = _wordController.text.trim();
    final snapshot = await _firestore.collection('words').where('words', isEqualTo: word).get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _score++;
        _feedback = "Correct!";
      });
      _saveScore();
    } else {
      setState(() {
        _feedback = "Incorrect. Try again.";
      });
    }
    _wordController.clear();
  }

  void _saveScore() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'score': _score,
      }, SetOptions(merge: true));
    }
  }

  void _getScore() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      if(snapshot.data() != null){
        final Map<String,dynamic> scoreData = snapshot.data() as Map<String,dynamic>;
        _score = scoreData['score'];
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getScore();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Game'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _wordController,
              decoration: InputDecoration(labelText: 'Enter a word'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkWord,
              child: Text('Check Word'),
            ),
            SizedBox(height: 20),
            Text('Score: $_score'),
            SizedBox(height: 20),
            Text(_feedback),
          ],
        ),
      ),
    );
  }
}
