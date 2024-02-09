import 'package:flutter/material.dart';

import 'src/game.dart';

const squareSizeMin = 48.0;
const squareSizeMax = 72.0;
const numSquares = 16;
const boardSizeMin = squareSizeMin * numSquares;
const boardSizeMax = squareSizeMax * numSquares;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sovereign Chess',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade900),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sovereign Chess'),
      //home: Center(
      //  child: ConstrainedBox(
      //    constraints: const BoxConstraints(
      //      minWidth: boardSizeMin,
      //      minHeight: boardSizeMin,
      //      maxWidth: boardSizeMax,
      //      maxHeight: boardSizeMax,
      //    ),
      //    child: Board(),
      //  ),
      //),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Games> _futureGames;

  void _createGame() async {
    final newGame = await createGame();
    final currentGames = await _futureGames;
    setState(() {
      _futureGames = Future.value([...currentGames, newGame]);
    });
  }

  @override
  void initState() {
    super.initState();
    _futureGames = fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        //child: Column(
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          //mainAxisAlignment: MainAxisAlignment.center,
          child: FutureBuilder<Games>(
            future: _futureGames,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data?.map((game) => Text(game.id)).toList(growable: false) ?? [],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
            //const Text(
            //  'You have clicked the button this many times:',
            //),
            //Text(
            //  '$_counter',
            //  style: Theme.of(context).textTheme.headlineMedium,
            //),
          //],
        //),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createGame,
        tooltip: 'Start a new game',
        child: const Text('Play'),
      ),
    );
  }
}
