import 'package:intl/intl.dart';

class Comment {
  String username;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.username,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    username: json['username'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
  );

  String getFormattedTimestamp() {
    final DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
    return formatter.format(timestamp);
  }

  void updateUsername(String newUsername) {
    username = newUsername;
  }
}

class Review {
  String title;
  String content;
  String username;
  final DateTime timestamp;
  bool isLiked;
  int likes;
  List<Comment> comments; // New field for comments
  bool isCommentsVisible;

  Review({
    required this.title,
    required this.content,
    required this.username,
    required this.timestamp,
    this.isLiked = false,
    this.likes = 0,
    List<Comment>? comments,
    this.isCommentsVisible = false,
  }) : comments = comments ?? [];

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'username': username,
    'timestamp': timestamp.toIso8601String(),
    'isLiked': isLiked,
    'likes': likes,
    'comments': comments.map((comment) => comment.toJson()).toList(), // Include comments
  };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    title: json['title'],
    content: json['content'],
    username: json['username'],
    timestamp: DateTime.parse(json['timestamp']),
    isLiked: json['isLiked'],
    likes: json['likes'],
    comments: (json['comments'] as List<dynamic>).map((e) => Comment.fromJson(e)).toList(), // Load comments
  );

  //updates username when it is changed
  void updateUsername(String newUsername) {
    username = newUsername;
  }

  //formats the timestamp
  String getFormattedTimestamp() {
    final DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
    return formatter.format(timestamp);
  }

  //adds comment to a review
  void addComment(String username, String content) {
    comments.add(Comment(
      username: username,
      content: content,
      timestamp: DateTime.now(),
    ));
  }

  //changes boolean value for if comment section is visible or not
  void toggleCommentsVisibility(){
    isCommentsVisible = !isCommentsVisible;
  }

}
