import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  final String url;
  final Color dominantColor;

  const DetailPage({Key? key, required this.url, required this.dominantColor})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? _pokemonData;
  bool _isLoading = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  // Fetch Pokémon details from the API
  Future<void> fetchDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(widget.url));

      if (response.statusCode == 200) {
        setState(() {
          _pokemonData = json.decode(response.body);
        });
        _checkIfFavorite(); // Check favorite status after fetching details
      } else {
        print('Failed to load details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Check if Pokémon is a favorite
  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favoriteDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(_pokemonData?['id'].toString())
        .get();

    setState(() {
      _isFavorite = favoriteDoc.exists;
    });
  }

  // Toggle favorite status in Firestore
  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not logged in!");
      return;
    }

    final favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');

    if (_isFavorite) {
      // Remove from favorites
      await favoritesCollection.doc(_pokemonData?['id'].toString()).delete();
    } else {
      // Add to favorites
      await favoritesCollection.doc(_pokemonData?['id'].toString()).set({
        'pokemonId': _pokemonData?['id'],
        'name': _pokemonData?['name'],
        'image': _pokemonData?['sprites']['front_default'],
      });
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(   backgroundColor: widget.dominantColor.withOpacity(0.8),

      appBar: AppBar(
        title: Text(_pokemonData?['name']?.toUpperCase() ?? 'Details'),
        backgroundColor: widget.dominantColor,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pokemonData == null
          ? Center(child: Text('Failed to load details.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Image.network(
                _pokemonData!['sprites']['front_default'] ??
                    'https://via.placeholder.com/150',
                height: 150,
                width: 150,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.error),
              ),
              SizedBox(height: 16),
              Text(
                'Name: ${_pokemonData!['name']?.toUpperCase()}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(
                'Height: ${_pokemonData!['height']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Weight: ${_pokemonData!['weight']}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
