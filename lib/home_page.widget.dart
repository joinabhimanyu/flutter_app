import 'package:flutter/material.dart';
import 'list.widget.dart';
import 'details.widget.dart';
import 'post.model.dart';

final GlobalKey<ListWidgetState> _listWidgetKey =
    new GlobalKey<ListWidgetState>();

class ListHomePage extends StatefulWidget {
  ListHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  ListHomePageState createState() => new ListHomePageState();
}

class ListHomePageState extends State<ListHomePage> {
  navigate(Post post) async {
    var result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new DetailsWidget(
                  title: widget.title,
                  postEditingModel: new PostEditingModel(post, 'edit'),
                )));
    // send result to be saved
    if (result.post.title != null &&
        result.post.title != '' &&
        result.post.body != null &&
        result.post.body != '')
      _listWidgetKey.currentState.saveNewAndEditedPost(result);
  }

  @override
  Widget build(BuildContext context) {
    var _body = new Container(
      child: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListWidget(_listWidgetKey, navigate),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              textDirection: TextDirection.ltr,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(
                      left: 5.0, top: 0.0, right: 5.0, bottom: 0.0),
                  child: new FloatingActionButton(
                    onPressed: () {
                      _listWidgetKey.currentState.retry();
                    },
                    tooltip: 'Retry',
                    child: new Icon(Icons.refresh),
                    heroTag: null,
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(
                      left: 5.0, top: 0.0, right: 5.0, bottom: 0.0),
                  child: new FloatingActionButton(
                    onPressed: () async {
                      var maxId = _listWidgetKey.currentState.getMaxId();
                      // navigate to add page
                      PostEditingModel result = await Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new DetailsWidget(
                                    title: widget.title,
                                    postEditingModel: new PostEditingModel(
                                        new Post(
                                            id: maxId, title: '', body: ''),
                                        'add'),
                                  )));
                      // send result to be saved
                      if (result.post.title != null &&
                          result.post.title != '' &&
                          result.post.body != null &&
                          result.post.body != '')
                        _listWidgetKey.currentState
                            .saveNewAndEditedPost(result);
                    },
                    tooltip: 'Add post',
                    child: new Icon(Icons.add),
                    heroTag: null,
                  ),
                )
              ],
            )
          ],
        ),
      ),
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
