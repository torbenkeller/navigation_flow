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
  Widget build(BuildContext oldcontext) {
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
                  child: Text('POP'),
                  onPressed: () {
                    NavigationFlow.of<EmptyFlowState, FlowArguments, FlowArguments>(context)
                        .previous(context, EmptyFlowArguments());
                  },
                ),
                RaisedButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    NavigationFlow.of<EmptyFlowState, FlowArguments, FlowArguments>(context)
                        .next(context, EmptyFlowArguments());
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

class ActivePageFlowState extends FlowState {
  int _index = 0;

  int get index => _index;

  void increment() => _index++;

  void decrement() => _index--;
}

class CustomFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearFlow<EmptyFlowState>(
      initialState: EmptyFlowState(),
      flow: [
        FlowElement<EmptyFlowArguments, EmptyFlowArguments>(
          onNext: (BuildContext context, EmptyFlowArguments arguments) async {
            print('Next: Current Page 0');
          },
          onPop: (context, arguments) async {
            print('Pop: Current Page 0');
          },
          child: MyPage(
            index: 0,
          ),
        ),
        FlowElement(
          onNext: (context, arguments) async {
            print('Next: Current Page 1');
          },
          onPop: (context, arguments) async {
            print('Pop: Current Page 1');
          },
          child: MyPage(
            index: 1,
          ),
        ),
        FlowElement(
          onNext: (context, arguments) async {
            print('Next: Current Page 2');
          },
          onPop: (context, arguments) async {
            print('Pop: Current Page 2');
          },
          child: MyPage(
            index: 2,
          ),
        ),
        FlowElement(
          onNext: (context, arguments) async {
            print('Next: Current Page 3');
          },
          onPop: (context, arguments) async {
            print('Pop: Current Page 3');
          },
          child: MyPage(
            index: 3,
          ),
        ),
        FlowElement(
          onNext: (context, arguments) async {
            print('Next: Current Page 4');
          },
          onPop: (context, arguments) async {
            print('Pop: Current Page 4');
          },
          child: MyPage(
            index: 4,
          ),
        ),
      ],
    );
  }
}
