class Post {
  int id;
  String title;
  String body;

  Post({this.id, this.title, this.body}) {
    if (this.id == null) {
      throw new ArgumentError('id cannot be null');
    }
    if (this.title == null) {
      throw new ArgumentError('title cannot be null');
    }
    if (this.body == null) {
      throw new ArgumentError('body cannot be null');
    }
  }
}

class PostEditingModel {
  Post post;
  String mode;

  PostEditingModel(this.post, this.mode) {
    if (this.post == null) {
      throw new ArgumentError('post cannot be null');
    }
    if (this.mode == null) {
      throw new ArgumentError('mode cannot be null');
    }
  }
}
