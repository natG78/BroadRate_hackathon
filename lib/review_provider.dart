import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'review_model.dart';

class ReviewProvider extends ChangeNotifier {
  List<Review> _reviews = [];
  String _username = 'User';

  List<Review> get reviews => _reviews;
  String get username => _username;

  ReviewProvider() {
    _loadReviews();
    _loadUsername();
  }

  Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final reviewsJson = prefs.getString('reviews') ?? '[]';
    List<dynamic> reviewsList = json.decode(reviewsJson);
    _reviews = reviewsList.map((json) => Review.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> _saveReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final reviewsJson = json.encode(_reviews.map((review) => review.toJson()).toList());
    prefs.setString('reviews', reviewsJson);
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'User';
    notifyListeners();
  }

  Future<void> _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _username);
  }

  void addReview(String title, String content) {
    final review = Review(
      title: title,
      content: content,
      username: _username,
      timestamp: DateTime.now(),
    );
    _reviews.insert(0, review);
    _saveReviews();
    notifyListeners();
  }

  void addComment(Review review, String content) {
    review.addComment(_username, content);
    _saveReviews();
    notifyListeners();
  }

  void toggleLike(Review review) {
    review.isLiked = !review.isLiked;
    review.likes += review.isLiked ? 1 : -1;
    _saveReviews();
    notifyListeners();
  }

  int getTotalLikes(String username) {
    return _reviews.where((review) => review.username == username).fold(0, (sum, review) => sum + review.likes);
  }

  void updateUsername(String newUsername) {
    _username = newUsername;
    for (var review in _reviews) {
      review.updateUsername(newUsername);
      for(var comment in review.comments){
        comment.updateUsername(newUsername);
      }
    }

    _saveReviews();
    _saveUsername();
    notifyListeners();
  }

  void deleteReview(Review review) {
    _reviews.remove(review);
    _saveReviews();
    notifyListeners();
  }
}
