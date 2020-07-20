import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigation_flow/navigation_flow.dart';
import 'package:navigation_flow/arguments.dart';
import 'package:navigation_flow/states.dart';
import 'package:navigation_flow/linear_flow.dart';
import 'package:navigation_flow/element.dart';

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

class MyPage extends StatelessWidget {
  final int index;

  const MyPage({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(NavigationFlow.of<MyState>(context).state.myString);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Text(index.toString()),
          ),
          Align(
            alignment: Alignment.bottomCenter,
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
                        .next(context, MyArguments('My Argument ', index));
                  },
                ),
                RaisedButton(
                  child: Text('update'),
                  onPressed: () {
                    NavigationFlow.of<MyState>(context).updateState(MyState('asfd'));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyArguments extends FlowArguments {
  final String myArgument1;
  final int myArgument2;

  MyArguments(this.myArgument1, this.myArgument2);
}

class MyState extends FlowState {
  final String myString;

  MyState(this.myString);
}

class CustomFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearFlow<MyState>(
      initialState: MyState(''),
      flow: [
        FlowElement(
          onNext: (BuildContext context, arguments) {
            String myString = NavigationFlow.of<MyState>(context).state.myString;
            NavigationFlow.of<MyState>(context).updateState(MyState(myString + 'a '));
            print(NavigationFlow.of<MyState>(context).state.myString);
          },
          onPrevious: () {},
          page: MyPage(index: 0),
        ),
        FlowElement(
          onNext: (BuildContext context, arguments) {
            String myString = NavigationFlow.of<MyState>(context).state.myString;
            NavigationFlow.of<MyState>(context).updateState(MyState(myString + 'a '));
//            print(NavigationFlow.of<MyState>(context).state.myString);
          },
          page: MyPage(index: 1),
        ),
        FlowElement(
          onNext: (BuildContext context, arguments) {
            String myString = NavigationFlow.of<MyState>(context).state.myString;
            NavigationFlow.of<MyState>(context).updateState(MyState(myString + 'a '));
//            print(NavigationFlow.of<MyState>(context).state.myString);
          },
          page: MyPage(index: 2),
        ),
        FlowElement(
          onNext: (BuildContext context, arguments) {
            String myString = NavigationFlow.of<MyState>(context).state.myString;
            NavigationFlow.of<MyState>(context).updateState(MyState(myString + 'a '));
//            print(NavigationFlow.of<MyState>(context).state.myString);
          },
          page: MyPage(index: 3),
        ),
      ],
    );
  }
}
