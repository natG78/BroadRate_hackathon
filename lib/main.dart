import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'review_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReviewProvider(),
      child: MaterialApp(
        title: 'Review Newsfeed',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
          ),
        ),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ReviewNewsfeedPage(),
    SearchPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Newsfeed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class ReviewNewsfeedPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('BroadRate')),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Review List
          Expanded(
            child: Consumer<ReviewProvider>(
              builder: (context, reviewProvider, child) {
                return ListView.builder(
                  itemCount: reviewProvider.reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviewProvider.reviews[index];
                    
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(review.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review.content),
                                Text(
                                  'Posted by: ${review.username}',
                                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  review.getFormattedTimestamp(),
                                  style: TextStyle(fontSize: 12),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        review.isLiked ? Icons.favorite : Icons.favorite_border,
                                        color: review.isLiked ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: () {
                                        reviewProvider.toggleLike(review);
                                      },
                                    ),
                                    Text(review.likes.toString()),
                                    Spacer(),
                                    if (review.username == reviewProvider.username)
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Delete Review'),
                                                content: Text('Are you sure you want to delete this review?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      reviewProvider.deleteReview(review);
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Yes'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('No'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Comment Section
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold)),
                                ...review.comments.map((comment) => ListTile(
                                  title: Text(comment.content),
                                  subtitle: Text(
                                    'Posted by: ${comment.username} on ${comment.getFormattedTimestamp()}',
                                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                  ),
                                )),
                                TextField(
                                  controller: _commentController,
                                  decoration: InputDecoration(
                                    hintText: 'Add a comment...',
                                  ),
                                  maxLines: 2,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_commentController.text.isNotEmpty) {
                                      reviewProvider.addComment(review, _commentController.text);
                                      _commentController.clear();
                                    }
                                  },
                                  child: Text('Submit Comment'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Review Form
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter the title',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Enter your review',
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _contentController.text.isNotEmpty) {
                      final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
                       reviewProvider.addReview(
                        _titleController.text,
                        _contentController.text,
                      );
                      _titleController.clear();
                      _contentController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter both title and content.')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _commentController = TextEditingController(); // Add this line
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('BroadRate')),
        backgroundColor: Colors.blue,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search reviews...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, reviewProvider, child) {
          final filteredReviews = reviewProvider.reviews.where((review) {
            return review.title.toLowerCase().contains(_searchQuery) ||
                   review.content.toLowerCase().contains(_searchQuery);
          }).toList();

          return ListView.builder(
            itemCount: filteredReviews.length,
            itemBuilder: (context, index) {
              final review = filteredReviews[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(review.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review.content),
                          Text(
                            'Posted by: ${review.username}',
                            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                          Text(
                            review.getFormattedTimestamp(),
                            style: TextStyle(fontSize: 12),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  review.isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: review.isLiked ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  reviewProvider.toggleLike(review);
                                },
                              ),
                              Text(review.likes.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Comment Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...review.comments.map((comment) => ListTile(
                            title: Text(comment.content),
                            subtitle: Text(
                              'Posted by: ${comment.username} on ${comment.getFormattedTimestamp()}',
                              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          )),
                          TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                            ),
                            maxLines: 2,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_commentController.text.isNotEmpty) {
                                reviewProvider.addComment(review, _commentController.text);
                                _commentController.clear();
                              }
                            },
                            child: Text('Submit Comment'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('BroadRate')),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ReviewProvider>(
          builder: (context, reviewProvider, child) {
            final totalLikes = reviewProvider.getTotalLikes(reviewProvider.username);

            return Column(
              children: [
                Text('Username: ${reviewProvider.username}'),
                SizedBox(height: 8),
                Text('Total Likes: $totalLikes'),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _showChangeUsernameDialog(context, reviewProvider);
                  },
                  child: Text('Change Username'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showChangeUsernameDialog(BuildContext context, ReviewProvider reviewProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Username'),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Enter new username',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty) {
                  reviewProvider.updateUsername(_usernameController.text);
                }
                _usernameController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
