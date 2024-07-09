# Stefanos Sotiriou iOS recruitment test task

### YBSFlickr 
is a native iOS mobile app developed using Swift and SwiftUI that interacts with the Flickr API to display a list of photos and a second View that displays more information about the Image.

### Features

- **Default Search:** On the initial load, the app searches for "Yorkshire" and sets safe search to "safe."
- **Photo List Display:** Shows a list of photos with the poster's user ID, user icon, user name and associated tags.
- **Photo Grid Display:** Shows a list of photos split into two columns with the poster's user ID and user icon and user name.(Tags are omitted here to keep the UI clean and less cluttered).
![Mockup](/PhotoListView.png)
![Mockup](/PhotoGridView.png)

- **Search by Tags:** Users can search for photos by tag or lists of tags, specifying whether a photo should contain all or some of the tags.
- **Search by Username:** Users can search for photos by a user's username.
- **Dynamic Tag Display:** Tags dynamically adjust their width based on the text and wrap to the next line when necessary.
![Mockup](/TagView.png)
![Mockup](/SearchTypeMenu.png)

- **Photo Details View:** Allows users to tap on a photo to view more details.
- **User Photos:** Users can tap on a user ID/photo to view more photos by that user.
![Mockup](/PhotoDetailView.png)


## Architecture

The project uses a Model-View-ViewModel (MVVM) architecture. This architecture was chosen because it promotes a clear separation of concerns, making the code more modular, testable, and maintainable. The `PhotoListViewModel` is responsible for handling data and business logic, while the views are responsible for displaying the data.

## Third-Party Libraries

No third-party SDKs were used in this project. The app relies solely on Swift, SwiftUI and Combine for its implementation.

## Tests

The project includes unit tests to ensure the functionality of the `PhotoListViewModel`. The tests cover initial state verification, composite search functionality, searching by text and searching by user.

## Decisions and Justifications

- **MVVM Architecture:** Chosen for its clear separation of concerns, making the app more modular and testable.
- **SwiftUI:** Used for building the user interface because of its declarative nature and seamless integration with Swift. It is also used exclusively by YBS, and I wanted to display that I am comfortable using it.
- **Combine:** Used for managing state and handling asynchronous operations in a reactive way.
- **No Third-Party Libraries:** The app relies solely on native Swift and SwiftUI components to keep the project lightweight and maintainable.

##### Future Improvements
- Add proper error handling with the use of the flickr api.
- Add a zoom animation when the user Navigates from the Photo List View to the Photo Details View.
- Add more search options like be able to search based on a range of Dates.
- Refine the tag view in the add tag section to keep standard distances between the tags.
