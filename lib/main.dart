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
        title: 'Newsfeed',
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
    ReviewNewsfeedPage(), //for the reviews to be on
    SearchPage(), //to search for certain reviews
    ProfilePage(), //to update username and look at total likes
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

//main reviews page
class ReviewNewsfeedPage extends StatefulWidget {
  @override
  _ReviewNewsfeedPageState createState() => _ReviewNewsfeedPageState();
}

class _ReviewNewsfeedPageState extends State<ReviewNewsfeedPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('BroadRate')), //top header bar
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, reviewProvider, child) {
          return Column(
            children: [
              // Review List
              Expanded(
                child: ListView.builder(
                  itemCount: reviewProvider.reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviewProvider.reviews[index];

                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(review.title, //review title, which will be shown in bold
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            subtitle: Column( //review body
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review.content),
                                SizedBox(height: 8),
                                Text(
                                  'Posted by: ${review.username}', //username of person who wrote review
                                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  review.getFormattedTimestamp(), //show time and date of submitted review
                                  style: TextStyle(fontSize: 12),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        review.isLiked ? Icons.favorite : Icons.favorite_border, //shows if the like button is pressed - red if yes, grey if no
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
                                        icon: Icon(Icons.delete, color: Colors.red), //shows delete button if username matches review username
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog( //delete review pop-up
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
                          if (review.isCommentsVisible) //if user chooses 'Show Comments' option
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold)), //show any previously posted comments
                                  ...review.comments.map((comment) => ListTile(
                                    title: Text(comment.content),
                                    subtitle: Text(
                                      'Posted by: ${comment.username} on ${comment.getFormattedTimestamp()}',
                                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                    ),
                                  )),
                                  TextField( //text field to add a comment
                                    controller: _commentController,
                                    decoration: InputDecoration(
                                      hintText: 'Add a comment...',
                                    ),
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton( //submit comment button
                                    onPressed: () {
                                      final comment = _commentController.text;
                                      if (comment.isNotEmpty) {
                                        reviewProvider.addComment(review, comment);
                                        _commentController.clear();
                                      }
                                    },
                                    child: Text('Submit Comment'),
                                  ),
                                ],
                              ),
                            ),
                          TextButton( //button for showing and hiding comments
                            onPressed: () {
                              setState(() {
                                review.isCommentsVisible = !review.isCommentsVisible;
                              });
                            },
                            child: Text(review.isCommentsVisible ? 'Hide Comments' : 'Show Comments'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton( //button for adding a review
        onPressed: () => _showReviewForm(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showReviewForm(BuildContext context) { //adding a review screen
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final double sheetHeight = MediaQuery.of(context).size.height - 75; //size of writing review screen

        return Container(
          height: sheetHeight,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField( //box for user to write the title of the review
                  controller: _titleController,
                  decoration: InputDecoration( 
                    labelText: 'Title',
                  ),
                ),
                SizedBox(height: 8),
                TextField( //box for user to write the bodt of the review
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                ElevatedButton( //submit review button
                  onPressed: () {
                    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) { //only can be submitted if title and body have text in them
                      final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
                      reviewProvider.addReview(
                        _titleController.text,
                        _contentController.text,
                      );
                      Navigator.of(context).pop();
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
        );
      },
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //main header for app
        title: Center(child: Text('BroadRate')),
        backgroundColor: Colors.blue,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField( //search bar for searching key words in reviews
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

          return ListView.builder( //show matched reviews
            itemCount: filteredReviews.length,
            itemBuilder: (context, index) {
              final review = filteredReviews[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        review.title, 
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
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
                              // Button to toggle comments visibility
                              TextButton(
                                onPressed: () {
                                  review.toggleCommentsVisibility();
                                  reviewProvider.notifyListeners(); // Notify listeners to refresh UI
                                },
                                child: Text(review.isCommentsVisible ? 'Hide Comments' : 'Show Comments'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Conditional comments section
                    if (review.isCommentsVisible)
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
                              onSubmitted: (text) {
                                if (text.isNotEmpty) {
                                  reviewProvider.addComment(review, text);
                                  _commentController.clear();
                                }
                              },
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                final comment = _commentController.text;
                                if (comment.isNotEmpty) {
                                  reviewProvider.addComment(review, comment);
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


//profile page
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold( //main app bar
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
                Text('Username: ${reviewProvider.username}'), //show current username
                SizedBox(height: 8),
                Text('Total Likes: $totalLikes'), //show total number of likes user got on all reviews combined
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _showChangeUsernameDialog(context, reviewProvider); //allow users to change their username
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

  void _showChangeUsernameDialog(BuildContext context, ReviewProvider reviewProvider) { //change username pop-up
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
