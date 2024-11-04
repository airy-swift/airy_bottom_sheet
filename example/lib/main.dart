import 'package:airy_bottom_sheet/airy_bottom_sheet.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _controller = AiryBottomSheetController(
    initialHeight: 100,
    magnetPoints: [
      [100, 200],
      [300, 400],
      [500],
    ],
    maxHeight: 530,
    minHeight: 80,
  );

  int _counter = 0;

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(Duration.zero).then((_) {
      AiryBottomSheet.show(
        _scaffoldKey,
        controller: _controller,
        switchChildren: [
          _firstChild(),
          _secondChild(),
          _thirdChild(),
        ],
        onDragAndAnimationEnd: (height) {
          debugPrint(height.toString());
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: const SizedBox.shrink(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'background\n$_counter',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 30),
            FloatingActionButton(
              onPressed: () {
                _controller.magnetPoints = [
                  [200],
                  [400],
                  [500],
                ];
              },
              child: const Icon(Icons.switch_access_shortcut_add),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _firstChild() {
    return Column(
      children: [
        Handle(
          controller: _controller,
          child: Container(
            color: Colors.redAccent,
            height: 40,
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.black,
          ),
        )
      ],
    );
  }

  Widget _secondChild() {
    return Handle(
      controller: _controller,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _thirdChild() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Handle(
          controller: _controller,
          child: Container(
            color: Colors.redAccent,
            height: 40,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(index.toString()),
              );
            },
          ),
        ),
      ],
    );
  }
}
