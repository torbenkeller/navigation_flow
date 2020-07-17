import 'package:flutter/material.dart';
import 'package:navigation_flow/navigation_flow.dart';

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
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CustomFlow(),
              )),
            ),
          ),
        ),
      ),
    );
  }
}


class MyPage extends StatelessWidget {
  final OnFlowEvent onNext;
  final OnFlowEvent onPop;
  final int index;

  const MyPage({
    Key key,
    this.onNext,
    this.onPop,
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
                    onPop(context, EmptyFlowArguments());
                  },
                ),
                RaisedButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    onNext(context, EmptyFlowArguments());
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

class CustomFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearFlow(
      initialState: EmptyFlowState(),
      flow: <FlowElement>[
        FlowElement(
          onNext: (context, arguments, state) async {
            print('onNext' + state.pageIndex.toString());
            return state;
          },
          onPop: (context, arguments, state) async {
            print('onPop' + state.pageIndex.toString());
            return state;
          },
          builder: (onNext, onPop, state) => MyPage(
            onNext: onNext,
            onPop: onPop,
            index: state.pageIndex,
          ),
        ),
        FlowElement(
          onNext: (context, arguments, state) async {
            print('onNext' + state.pageIndex.toString());
            return state;
          },
          onPop: (context, arguments, state) async {
            print('onPop' + state.pageIndex.toString());
            return state;
          },
          builder: (onNext, onPop, state) => MyPage(
            onNext: onNext,
            onPop: onPop,
            index: state.pageIndex,
          ),
        ),
        FlowElement(
          onNext: (context, arguments, state) async {
            print('onNext' + state.pageIndex.toString());
            return state;
          },
          onPop: (context, arguments, state) async {
            print('onPop' + state.pageIndex.toString());
            return state;
          },
          builder: (onNext, onPop, state) => MyPage(
            onNext: onNext,
            onPop: onPop,
            index: state.pageIndex,
          ),
        ),
      ],
    );
  }
}