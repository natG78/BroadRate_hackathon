# BroadRate - Multi-Tabbed Application

BroadRate is a Flutter-based multi-tabbed application designed for newsfeeds, search functionality, review writing, and profile management. The app allows users to post reviews, search content, manage their profile, and see a newsfeed of reviews. This application allows the musical theatre community to discuss shows they have seen, ask questions about shows they want to see, discuss the latest Broadway news, etc.


## Features
- **Newsfeed**: View a list of all previously-written reviews and can write and submit new reviews
- **Search**: Search for content within the app
- **Profile Management**: View and edit use profile details, and see the total number of likes received from all their posts


## Project Structure
The project is structured into several pages and widgets:
- 'main.dart': Entry point of the application
- 'home_page.dart': Contains the bottom navigation bar and routes to different tabs
- 'newsfeed_page.dart': Displays the list of reviews
- 'search_page.dart': Search functionality
- 'review_page.dart': Allows users to write and submit reviews
- 'profile_page.dart': Displays user profile and total likes
- 'review_model.dart': Creates the model of a review
- 'review_provider.dart': Allows the reviews to be updated and saved
- 'utils.dart': Gives the format of the date and time for reviews


## Getting Started

### Prerequisites
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter

### Running the App
To run the app on an emulator or physical device, use the following command:
flutter run

## Local Storage
The app uses local storage to persist data, such as posts and usernames, ensuring that information remains available even after the app is closed and reopened.


## Layout and Features Descriptions

### Centered Header
All pages have the header 'BroadRate' centered at the top in blue.

### Review Tab
The review writing section is placed at the bottom of the Newsfeed screen, and a user can get to the review writing section by tapping the blue '+' button on the Review tab. The list of all previously-written reviews is shown above.

### Reviews
Reviews have a boldened title at the top and the body of the review underneath. The username of who posted the review is under the body, followed by the date and time of when the review was posted. Reviews also have a like button, like count, delete button, and comment section.

### Comments
Under every review is text that says 'Show Comments', and when clicked, if there are any comments, they are shown. Additionally, there is a text box to type a new comment and a 'Submit Comment' button. To hide the comments again, a user can click 'Hide Comments'.

### Likes
In every review, there is a like button. A user can like the button, which will increase the total likes by 1. A user can also unlike a button after liking it, which will decrease the total likes by 1. The users total amount of likes from all their posts is displayed on the profile screen.

### Delete
In every review that a certain user has written, there is a delete button. This feature allows users to delete their own reviews. Once clicking the red trash can icon, a pop-up asks the user if they are sure they want to delete their review. If a user clicks yes, the review is deleted, but if a user clicks no, the review is not deleted.

### Screen Tabs
The bottom bar shows 'Newsfeed', 'Search', and 'Profile'. A user can change tabs by clicking on the name of the screen they want to go to.

### Change Username
In the 'Profile' tab, a user can change their username. This will also change the username on any of the previous reviews or comments they have written.

### Search
In the 'Search' tab, users can look up key words, and any review that contains those key words will remain underneath the search bar.

## Contributing
Contributions are welcome! Please fork the repository and create a pull request with your changes.
1. Fork the Project
2. Create your Feature Branch (git checkout -b feature/AmazingFeature)
3. Commit your Changes (git commit -m 'Add some AmazingFeature')
4. Push to the Branch (git push origin feature/AmazingFeature)
5. Open a Pull Request

## Creator's Contact
Natale Gray - natalegray78@gmail.com
