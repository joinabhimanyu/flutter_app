import 'package:flutter/material.dart';
import 'post.model.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class PostState {
  List<Post> data;
  String errMessage;
  bool errCode;

  PostState({this.data, this.errMessage, this.errCode});
}

class ListWidget extends StatefulWidget {
  final Function navigate;

  ListWidget(Key key, this.navigate) : super(key: key);

  @override
  ListWidgetState createState() => new ListWidgetState();
}

class ListWidgetState extends State<ListWidget> {
  List<Post> _posts = const [];
  bool _showProgressIndicator = false;
  bool _errorOccurred = false;

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    super.initState();
  }

  _resetState() {
    setState(() {
      _posts = const [];
      _showProgressIndicator = false;
      _errorOccurred = false;
    });
  }

  saveNewAndEditedPost(PostEditingModel postEditingModel) {
    var post = postEditingModel.post;
    var mode = postEditingModel.mode;
    if (mode == 'edit') {
      var _epost = _posts.where((item) => item.id == post.id).first;
      if (_epost != null) {
        _epost.title = post.title;
        _epost.body = post.body;
      } else
        throw new Exception('Invalid post');
    } else {
      _posts.add(new Post(id: post.id, title: post.title, body: post.body));
    }
    setState(() {});
    var smode = mode == 'add' ? 'added' : 'edited';
    _showSuccess(smode);
  }

  retry() {
    Scaffold.of(context).removeCurrentSnackBar();
    _resetState();
    _getData();
  }

  void _showError() {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("An unknown error occurred"),
        duration: new Duration(milliseconds: 5000),
        action: new SnackBarAction(
            label: "RETRY",
            onPressed: () {
              retry();
            })));
  }

  void _showSuccess(String mode) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Posts $mode successfully"),
        duration: new Duration(milliseconds: 3000)));
  }

  _getData() async {
    if (!mounted) {
      return;
    }
    setState(() {
      _posts = const [];
      _showProgressIndicator = true;
      _errorOccurred = false;
    });
    final data = await _getPostFromApi();
    if (data.errCode) {
      // show SnackBar  with errMessage
      _showError();
      setState(() {
        _posts = const [];
        _showProgressIndicator = false;
        _errorOccurred = true;
      });
    } else {
      _showSuccess('retrieved');
      setState(() {
        this._posts = data.data;
        _showProgressIndicator = false;
        _errorOccurred = false;
      });
    }
  }

  Future<PostState> _getPostFromApi() async {
    var _result = new PostState(data: [], errMessage: '', errCode: false);
    try {
      var httpClient = new HttpClient();
      var request = await httpClient
          .getUrl(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        _result.data = this._fromJsonArray(json);
        _result.errCode = false;
      } else {
        _result.errCode = true;
        _result.errMessage = 'Error occurred while loading data';
      }
    } catch (exception) {
      _result.errCode = true;
      _result.errMessage = exception.toString();
    }
    return _result;
  }

  List<Post> _fromJsonArray(String jsonArrayString) {
    List data = json.decode(jsonArrayString);
    List<Post> result = [];
    for (var i = 0; i < data.length; i++) {
      result.add(new Post(
          id: data[i]["id"], title: data[i]["title"], body: data[i]["body"]));
    }
    return result.take(2).toList();
    /*.take(4).toList();*/
  }

  Widget _getSuccessWidget() {
    return new ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
                    var id = _posts[index].id;
                    if (widget.navigate != null && id != null)
                      widget.navigate(_posts[index]);
                  },
                  child: new Text(
                    _posts[index].title,
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                new Text(_posts[index].body),
                new Divider()
              ]);
        });
  }

  Widget _getLoadingState() {
    return new CircularProgressIndicator();
  }

  Widget _getErrorState() {
    return new Text('Error occurred while loading data');
  }

  Widget _getChild() {
    if (!_showProgressIndicator && !_errorOccurred) {
      return _getSuccessWidget();
    } else if (!_errorOccurred) {
      return _getLoadingState();
    } else {
      return _getErrorState();
    }
  }

  int getMaxId() {
    int maxId = 0;
    maxId = this
        ._posts
        .map((item) => item.id)
        .fold(0, (prev, next) => next > prev ? next : prev);
    return maxId + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.all(5.0),
          child: _getChild(),
          constraints: BoxConstraints(maxHeight: 500.00),
        )
      ],
    );
  }
}
