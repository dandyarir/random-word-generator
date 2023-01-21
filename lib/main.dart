import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My Dendi App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        // home: MyOldHomePage(),
        home: MyHomePage(),
      ),
    );
  }
}

// simple ElevatedButton class builder
class MyButton extends StatelessWidget {
  final String nameTextLabel;
  final Function onPressed;

  const MyButton(
      {Key? key, required this.nameTextLabel, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      child: Text(nameTextLabel),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // text randomizer
  var current = WordPair.random();

  // function to get next random text
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // favorite list
  var favorites = <WordPair>[];
  // function to add or remove favorite
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorite'),
                ),
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) {
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: GeneratorPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    var nextButton = MyButton(
      nameTextLabel: 'Next',
      onPressed: () {
        appState.getNext();
      },
    );

    var favoriteButton = ElevatedButton.icon(
      onPressed: () {
        appState.toggleFavorite();
      },
      icon: Icon(icon),
      label: Text('Favorite'),
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              favoriteButton,
              SizedBox(width: 10),
              nextButton,
            ],
          ),
        ],
      ),
    );
  }
}

class MyOldHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    var nextButton = MyButton(
      nameTextLabel: 'Next',
      onPressed: () {
        appState.getNext();
      },
    );

    var favoriteButton = ElevatedButton.icon(
      onPressed: () {
        appState.toggleFavorite();
      },
      icon: Icon(icon),
      label: Text('Favorite'),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                favoriteButton,
                SizedBox(width: 15),
                nextButton,
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onSurface,
    );
    print(style);
    return Card(
      color: theme.colorScheme.primary,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asUpperCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}
