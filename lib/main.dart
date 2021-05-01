import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const favoritesBox = 'favorite_books';

const List<String> books = [
  // book name, index
  'Harry Potter', // 0
  'To Kill a Mockingbird', // 1
  'The Hunger Games', // 2
  'The Giver', // 3
  'Brave New World', // 4
  'Unwind', // 5
  'World War Z', // 6
  'The Lord of the Rings', // etc...
  'The Hobbit',
  'Moby Dick',
  'War and Peace',
  'Crime and Punishment',
  'The Adventures of Huckleberry Finn',
  'Catch-22',
  'The Sound and the Fury',
  'The Grapes of Wrath',
  'Heart of Darkness',
];
void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>(favoritesBox);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Favorite Books',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAppView(
        title: "Favorite Books",
      ),
    );
  }
}

class MyAppView extends StatefulWidget {
  MyAppView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyAppViewState createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  Box<String> favoriteBooksBox;
  @override
  void initState() {
    super.initState();
    favoriteBooksBox = Hive.box(favoritesBox);
  }

  Widget getIcon(int index) {
    if (favoriteBooksBox.containsKey(index)) {
      return Icon(Icons.favorite, color: Colors.red);
    }
    return Icon(Icons.favorite_border);
  }

  void onFavoritePress(int index) {
    if (favoriteBooksBox.containsKey(index)) {
      favoriteBooksBox.delete(index);
      return;
    }
    favoriteBooksBox.put(index, books[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ValueListenableBuilder(
        valueListenable: favoriteBooksBox.listenable(),
        builder: (context, Box<String> box, _) {
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, listIndex) {
              return ListTile(
                title: Text(books[listIndex]),
                trailing: IconButton(
                  icon: getIcon(listIndex),
                  onPressed: () => onFavoritePress(listIndex),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
