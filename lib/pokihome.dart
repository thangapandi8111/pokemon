import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DetailPage.dart';
import 'Favorites_Screen.dart';

class PokiHome extends StatefulWidget {
  @override
  _PokiHomeState createState() => _PokiHomeState();
}

class _PokiHomeState extends State<PokiHome> {
  List<dynamic> _data = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _offset = 0;
  final int _limit = 20;
  final ScrollController _scrollController = ScrollController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    if (_isFetchingMore) return;

    setState(() {
      _isLoading = _data.isEmpty; // Show loading spinner only for the initial load
      _isFetchingMore = true;
    });

    final url = Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?offset=$_offset&limit=$_limit');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _data.addAll(jsonData['results']); // Append new Pokémon data
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    } finally {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _offset += _limit;
      fetchData();
    }
  }

  String getPokemonImageUrl(String url) {
    final id = url.split('/').where((e) => e.isNotEmpty).last;
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }

  String getPokemonNumber(String url) {
    return url.split('/').where((e) => e.isNotEmpty).last; // Extract the numeric ID
  }

  Future<Color> getDominantColor(String imageUrl) async {
    try {
      final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
      );
      return paletteGenerator.dominantColor?.color ?? Colors.grey;
    } catch (e) {
      return Colors.grey; // Default color if image fails to load
    }
  }

  Future<void> toggleFavoritePokemon(String pokemonId, String name, String imageUrl) async {
    if (user == null) return;

    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(pokemonId);

    final docSnapshot = await favoritesRef.get();

    if (docSnapshot.exists) {
      // Remove from favorites
      await favoritesRef.delete();
    } else {
      // Add to favorites
      await favoritesRef.set({
        'pokemonId': pokemonId,
        'name': name,
        'image': imageUrl,
      });
    }

    setState(() {}); // Update the UI after toggling the favorite
  }

  Future<bool> isPokemonFavorite(String pokemonId) async {
    if (user == null) return false;

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(pokemonId)
        .get();

    return docSnapshot.exists;
  }
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5FFF2),
      appBar: AppBar(
        title: Text('Pokémon List'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _offset = 0;
                _data.clear();
              });
              fetchData();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout_sharp),
            onPressed: signUserOut,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of items per row
          crossAxisSpacing: 8.0, // Horizontal spacing between items
          mainAxisSpacing: 8.0, // Vertical spacing between items
          childAspectRatio: 1, // Aspect ratio of the cards
        ),
        itemCount: _data.length + 1, // Add one for the loading indicator
        itemBuilder: (context, index) {
          if (index == _data.length) {
            return _isFetchingMore
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            )
                : SizedBox.shrink();
          }

          final item = _data[index];
          final imageUrl = getPokemonImageUrl(item['url']);
          final pokemonNumber = getPokemonNumber(item['url']);
          final pokemonName = item['name'];

          return FutureBuilder<Color>(
            future: getDominantColor(imageUrl),
            builder: (context, snapshot) {
              final cardColor = snapshot.data ?? Colors.white;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(url: item['url'], dominantColor: cardColor),
                    ),
                  );
                },
                child: FutureBuilder<bool>(
                  future: isPokemonFavorite(pokemonNumber),
                  builder: (context, favoriteSnapshot) {
                    final isFavorite = favoriteSnapshot.data ?? false;

                    return Container(
                      margin: EdgeInsets.all(8.0),
                      child: Card(
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.white,
                              ),
                              onPressed: () {
                                toggleFavoritePokemon(
                                    pokemonNumber, pokemonName, imageUrl);
                              },
                            ),
                            SizedBox(height: 8),
                            Image.network(
                              imageUrl,
                              width: 70,
                              height: 69,
                              gaplessPlayback: true,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                            ),
                            SizedBox(height: 8),
                            Text(
                              pokemonName ?? 'No Name',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'ID: $pokemonNumber',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
