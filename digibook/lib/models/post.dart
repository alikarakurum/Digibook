class Post {
  final String postId;
  final String postsUserID;
  final String postTopic;
  final String username;
  final String userProfilePhotoUrl;
  final String postTitle;
  final dynamic postContent;
  final dynamic postPhotoUrl;
  final String sentTimeOfPost;
  final dynamic likes;
  final dynamic dislikes;
  final comments;
  final int postPoint;
  final String typeOfPost;
  Post({
    this.postId,
    this.postsUserID,
    this.postTopic,
    this.typeOfPost,
    this.username,
    this.userProfilePhotoUrl,
    this.postTitle,
    this.postContent,
    this.postPhotoUrl,
    this.sentTimeOfPost,
    this.likes,
    this.dislikes,
    this.comments,
    this.postPoint,
  });

  factory Post.fromDocument(Map<String, dynamic> docdata) {
    return Post(
        postId: docdata["postId"],
        postsUserID: docdata["postsUserID"],
        postTopic: docdata["postTopic"],
        username: docdata["username"],
        userProfilePhotoUrl: docdata["userProfilePhotoUrl"],
        postTitle: docdata["postTitle"],
        postContent: docdata["postContent"],
        postPhotoUrl: docdata["postPhotoUrl"],
        sentTimeOfPost: docdata["sentTimeOfPost"].toString(),
        likes: docdata["likes"],
        dislikes: docdata["dislikes"],
        comments: docdata["comments"],
        postPoint: docdata["postPoint"]);
  }

  returnPostInfoFirstTime(
      String postId,
      String postsUserId,
      String username,
      String userProfilePhotoUrl,
      String postTitle,
      dynamic postContent,
      String postPhotoUrl,
      DateTime sentTimeOfPost,
      dynamic likes,
      dynamic comments,
      int postPoint) {
    return {
      "postId": postId,
      "postsUserID": postsUserId,
      "username": username,
      "userProfilePhotoUrl": userProfilePhotoUrl ?? "",
      "postTitle": postTitle,
      "postContent": postContent,
      "postPhotoUrl": postPhotoUrl,
      "sentTimeOfPost": sentTimeOfPost,
      "likes": likes,
      "comments": comments,
      "postPoint": postPoint
    };
  }
}
