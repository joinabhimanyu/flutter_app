import 'package:flutter/material.dart';
import 'post.model.dart';

class DetailsWidget extends StatefulWidget {
  DetailsWidget({Key key, this.title, this.postEditingModel}) : super(key: key);

  final String title;
  final PostEditingModel postEditingModel;

  @override
  DetailsWidgetState createState() => new DetailsWidgetState();
}

class DetailsWidgetState extends State<DetailsWidget> {
  final _titleController = new TextEditingController();
  final _bodyController = new TextEditingController();
  PostEditingModel _postEditingModel;

  @override
  void initState() {
    // TODO: implement initState
    // set text controller states when mode is editing
    super.initState();
    initData();
  }

  initData() {
    _postEditingModel = new PostEditingModel(
        widget.postEditingModel.post, widget.postEditingModel.mode);
    if (_postEditingModel.mode == 'edit') {
      setState(() {
        _titleController.text = _postEditingModel.post.title;
        _bodyController.text = _postEditingModel.post.body;
      });
    }
  }

  _submitFormState() {
    var title = _titleController.text;
    var body = _bodyController.text;
    if (title == null || title == '')
      throw new Exception('title cannot be blank');
    if (body == null || body == '') throw new Exception('body cannot be blank');
    try {
      setState(() {
        _postEditingModel.post.title = title;
        _postEditingModel.post.body = body;
      });
      Navigator.pop(context, _postEditingModel);
    } catch (e) {
      throw new Exception(e.toString());
    }
  }

  resetFormState() {
    if (_postEditingModel.mode == 'add') {
      _titleController.clear();
      _bodyController.clear();
    } else if (_postEditingModel.mode == 'edit') {
      _titleController.text = _postEditingModel.post.title;
      _bodyController.text = _postEditingModel.post.body;
    }
  }

  navigateBack() {
    Navigator.pop(context, _postEditingModel);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Widget _getFormWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: new TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Enter title'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: new TextField(
            controller: _bodyController,
            decoration: InputDecoration(labelText: 'Enter body'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(2.0),
              child: new RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  _submitFormState();
                },
                child: new Text("Submit"),
              ),
            ),
            new Container(
              padding: EdgeInsets.all(2.0),
              child: new RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  resetFormState();
                },
                child: new Text("Reset"),
              ),
            ),
            new Container(
              padding: EdgeInsets.all(2.0),
              child: new RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  navigateBack();
                },
                child: new Text("Back"),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _body = Column(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.all(5.0),
          child: _getFormWidget(),
          constraints: BoxConstraints(maxHeight: 220.00),
        ),
      ],
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _body,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
