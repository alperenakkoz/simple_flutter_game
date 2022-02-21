import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class ParentWidget extends StatefulWidget {
  const ParentWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ParentState();
}

class ParentState extends State<ParentWidget> {
  bool bittiMi = false;

  void durumDegisimi(bool newValue) {
    setState(() {
      bittiMi = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Zaman(bittiMi: bittiMi),
        SizedBox(
          width: 250,
          height: 250,
          child: Oyun(
            bittiMi: bittiMi,
            onChanged: durumDegisimi,
          ),
        ),
        if (bittiMi)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                durumDegisimi(false);
              },
              child: const Text(
                'Replay',
              ),
            ),
          ])
      ],
    );
  }
}

List<int> sayilar() {
  var sayilar = List.generate(25, (i) => i + 1);
  sayilar.shuffle();
  return sayilar;
}

class Zaman extends StatefulWidget {
  const Zaman({Key? key, this.bittiMi = false}) : super(key: key);

  final bool bittiMi;

  @override
  State<StatefulWidget> createState() => _StopwatchState();
}

class _StopwatchState extends State<Zaman> {
  var zaman = Stopwatch();
  Duration best = const Duration(seconds: 0);
  String saniye = '0';
  bool replay = false;

  _StopwatchState() {
    basla();
  }

  void basla() {
    zaman.reset();
    zaman.start();
    replay = false;
  }

  void bitti() {
    zaman.stop();
    if (best.inSeconds == 0 || best.inSeconds > zaman.elapsed.inSeconds) {
      best = zaman.elapsed;
    }
    replay = true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bittiMi) {
      bitti();
    } else if (replay) {
      basla();
    }
    if (zaman.isRunning) {
      Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          saniye = zaman.elapsed.inSeconds.toString();
        });
      });
    }
    return Column(children: [
      Row(
        children: [
          Text("Best Score: ${best.inSeconds.toString()}"),
        ],
      ),
      Row(
        children: [
          Text("Time Elapsed:  $saniye"),
        ],
      ),
    ]);
  }
}

class Oyun extends StatefulWidget {
  const Oyun({Key? key, this.bittiMi = false, required this.onChanged})
      : super(key: key);

  final bool bittiMi;
  final ValueChanged<bool> onChanged;

  @override
  _OyunState createState() => _OyunState();
}

class _OyunState extends State<Oyun> {
  List<bool> active = List.generate(25, (i) => false);
  List<int> numbers = sayilar();
  int now = 1;
  bool replay = false;

  void basla() {
    now = 1;
    active = List.generate(25, (i) => false);
    numbers = sayilar();
    replay = false;
  }

  @override
  Widget build(BuildContext context) {
    if (replay && !widget.bittiMi) basla();

    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemCount: 25,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (now == numbers[index] && !widget.bittiMi)
              ? () {
                  setState(() {
                    active[index] = !active[index];
                    now++;
                    if (now == 26) {
                      widget.onChanged(true);
                      replay = true;
                    }
                  });
                }
              : () {},
          child: Container(
            child: Center(
              child: Text(
                numbers[index].toString(),
              ),
            ),
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              border: Border.all(color: (Colors.grey[600])!),
              color: active[index] ? Colors.green : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}

//------------------------- MyApp ----------------------------------

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Game',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Schulte Table'),
        ),
        body: const Center(
          child: ParentWidget(),
        ),
      ),
    );
  }
}
