import 'package:flutter/material.dart';
import 'package:keyboard_overlay/keyboard_overlay.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keyboard Overlay Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Keyboard Overlay Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, this.title});

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: Center(
        child: Text(
          'Go to next screen',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SecondPage()));
        },
        tooltip: 'next',
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  SecondPage({super.key});
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with HandleFocusNodesOverlayMixin {
  //Use Mixin HandleFocusNodesOverlayMixin

  late FocusNodeOverlay _nodeCats;
  late FocusNodeOverlay _nodeDogs;
  late FocusNodeOverlay _nodePassword;

  @override
  void initState() {
    super.initState();

    _nodeCats = getFocusNodeOverlay(
      // call method from Mixin GetFocusNodeOverlay
      child: TopKeyboardUtil(
        DoneButtonIos(
          label: 'Next',
          onSubmitted: () => _nextField(_nodeCats, _nodeDogs),
          platforms: ['android', 'ios'],
        ),
      ),
    ) as FocusNodeOverlay;

    _nodeDogs = getFocusNodeOverlay(
        child: TopKeyboardUtil(
          SliderComponent(
            controller: (double value) {
              _nodeDogs.controller.text = (value * 100).round().toString();
            },
            onSubmitted: () => _nextField(_nodeDogs, _nodePassword),
          ),
        ),
        controller: TextEditingController()) as FocusNodeOverlay;

    _nodePassword = getFocusNodeOverlay(
        child: SpecialDismissable(
          onOkButton: () => print(_nodePassword.controller.text),
          title: 'SPECIAL',
        ),
        controller: TextEditingController()) as FocusNodeOverlay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              focusNode: _nodeCats, // Adicionado focus node
              textInputAction: TextInputAction.next,
              autofocus: true,
              onFieldSubmitted: (term) async {
                _nextField(_nodeCats, _nodePassword);
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                labelText: 'How many cats?',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.orange,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              focusNode: _nodeDogs, // focus node added
              controller: _nodeDogs.controller, // controller added
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) async {
                _nextField(_nodeCats, _nodePassword);
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                labelText: 'How many dogs?',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.orange,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              focusNode: _nodePassword, // CustomFocusNode
              controller:
                  _nodePassword.controller, // use controller from focusNode
              textInputAction: TextInputAction.done,
              obscureText: true,
              onFieldSubmitted: (term) async {
                print(_nodePassword.controller.text);
              },
              style: TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                labelText: 'Enter password',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.orange,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.black87,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  _nextField(FocusNode prev, FocusNode next) {
    prev.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  @override
  void dispose() {
    // Don't need to dispose FocusNodeOverlay and TextEditingController, it will be disposed automatically
    super.dispose();
  }
}
