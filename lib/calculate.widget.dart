import 'package:flutter/material.dart';

class CalculateWidget extends StatefulWidget {
  CalculateWidget({Key key}) : super(key: key);

  @override
  _CalculateWidgetState createState() => new _CalculateWidgetState();
}

class _CalculateWidgetState extends State<CalculateWidget> {
  final _num1Controller = new TextEditingController();
  final _num2Controller = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }

  void _calculate(String args) {
    try {
      double _result = 0.0;
      String label;
      switch (args.toLowerCase()) {
        case 'add':
          label = 'Add';
          _result = double.parse(_num1Controller.text) +
              double.parse(_num2Controller.text);
          break;
        case 'subtract':
          label = 'Subtract';
          _result = double.parse(_num1Controller.text) -
              double.parse(_num2Controller.text);
          break;
        case 'multiply':
          label = 'Multiply';
          _result = double.parse(_num1Controller.text) *
              double.parse(_num2Controller.text);
          break;
        case 'divide':
          label = 'Divide';
          _result = double.parse(_num1Controller.text) /
              double.parse(_num2Controller.text);
          break;
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("$label"),
              content: new Text("The result: $_result"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } catch (e) {
      // alert with error
      _resetState();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error"),
              content: new Text("Error: ${e.toString()}"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  void _resetState() {
    setState(() {
      setState(() {
        _num1Controller.clear();
        _num2Controller.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new TextField(
              controller: _num1Controller,
              decoration: InputDecoration(labelText: 'Enter first number'),
            ),
          ),
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new TextField(
              controller: _num2Controller,
              decoration: InputDecoration(labelText: 'Enter second number'),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(2.0),
                child: new RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    _calculate('add');
                  },
                  child: new Text("Add"),
                ),
              ),
              new Container(
                padding: EdgeInsets.all(2.0),
                child: new RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    _calculate('subtract');
                  },
                  child: new Text("Subtract"),
                ),
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(2.0),
                child: new RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    _calculate('multiply');
                  },
                  child: new Text("Multiply"),
                ),
              ),
              new Container(
                padding: EdgeInsets.all(2.0),
                child: new RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    _calculate('divide');
                  },
                  child: new Text("Divide"),
                ),
              ),
              new Container(
                padding: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: _resetState,
                  child: new Text("Reset"),
                ),
              ),
            ],
          )
          /*new Text(
              'The result: $_result',
              style: Theme.of(context).textTheme.display1,
            ),*/
        ],
      ),
    );
  }
}
