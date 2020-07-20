import 'package:flutter/material.dart';
import 'package:navigation_flow/navigation_flow.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => RaisedButton(
              child: Text('Push Flow'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CustomFlow(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyState extends FlowState {
  final String state1;

  MyState(this.state1);
}

class MyArguments extends FlowArguments {
  final String argument1;

  MyArguments(this.argument1);
}

class CustomFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearFlow<MyState>(
      initialState: MyState('initial'),
      flow: [
        FlowElement(
          onNext: (BuildContext context, arguments) {
            // access arguments
            if (arguments is MyArguments) {
              print(arguments.argument1);
            }

            NavigationFlow.of<MyState>(context).updateState(MyState('updated'));

            // your logic
          },
          onPrevious: () {
            // your logic
          },
          page: MyPage(),
        ),
        FlowElement(
          page: MyPage(),
        ),
        FlowElement(
          page: MyPage(),
        ),
      ],
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              child: Text('PREVIOUS'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('NEXT'),
              onPressed: () {
                NavigationFlow.of<MyState>(context)
                    .next(context, MyArguments('the argument content'));
              },
            ),
            Text(NavigationFlow.of<MyState>(context).state.state1),
          ],
        ),
      ),
    );
  }
}
