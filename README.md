# CuisineCode

### Summary

**CuisineCode** is an iOS application for discovering, viewing, and saving recipes, with support for opening external links.  
At launch, users enter their name to personalize the interface.  
The app is built on the MVVM architecture using `async/await`, dependency injection (DI), and local caching.  
The project follows clean architecture principles with a focus on modularity, testability, and user experience (UX).

---

### Features

**RecipeList/**

- Time-based greeting for the user  
- Search and filtering by cuisine  
- Banner with external link (Fetch) via `SFSafariViewController`  
- Recipe loading from local JSON (adaptive `LazyVGrid` layout)  

**RecipeDetail/**

- Displays recipe image, description, and cuisine  
- Favorite toggle  
- “Watch Recipe” and “Video” buttons using `SFSafariViewController`  
- Horizontal partner slider with external links  

**Onboarding/**

- User name entry on first launch using `@AppStorage`  

**Favorites/**

- Animated “Favorites” header  
- Separate list of favorited recipes  

---

### Focus Areas

Main development priorities:
- Clean architecture emphasizing scalability and testability  
- Clear separation of concerns with MVVM layers and DI via `EnvironmentKey`  
- Modern UI/UX with minimalist design, animations, and state adaptation (`@StateObject`, `@AppStorage`)  
- Performance: Custom `ImageLoaderService` with caching via `FileManager`  
- Modular approach: each feature is encapsulated in a separate component  

---

### Services

**NetworkService/**

Asynchronously loads recipes from a remote source using `URLSession`.  
Handles HTTP status and decoding errors (`RecipeResponse`). Used in `RecipeListViewModel`.
- Architecture: Protocol + Implementation (`NetworkServiceProtocol`)  
- Errors: `NetworkError.statusCode`, `NetworkError.decodingError`  

**FavoritesService/**

Locally saves and manages favorite recipes using `@AppStorage`.  
- Supports toggle logic  
- State published with `@Published`  
- Automatically loads/saves on initialization  

**ImageLoaderService/**

Caches images to the file system using `FileManager`.  
Loads images from the network if not cached and saves them for reuse.  
Used through `ImageLoader` and `CachedImageView` to bind with the UI.  
- Cache location: `CachesDirectory`  
- Filename format: `url.absoluteString.hashValue`  

**SafariService/**

Wraps `SFSafariViewController` to open external links.  
Uses `Binding<Bool>` and `Binding<URL?>` for controlled modal presentation.  
- Supports passing URL and visibility management via SwiftUI  

---

### Time Spent

| Stage                       | Hours  |
|-----------------------------|--------|
| Architecture + DI           | 6 h    |
| RecipeList + filtering      | 8 h    |
| RecipeDetail + Safari       | 6 h    |
| Image caching               | 3 h    |
| Favorites + `@AppStorage`   | 2 h    |
| Unit tests                  | 3 h    |
| README                      | 2 h    |

**Total — approx. 30 hours**

---

### Trade-offs and Decisions

- Using Dependency Injection (DI) via EnvironmentKey — a solution that simplifies access to services in different parts of the app but requires additional effort for setup and testing. It provides flexibility in changing dependencies, but also increases the complexity of understanding the architecture.
- Separating image loading and caching logic into a dedicated service (ImageLoaderService) enhances reusability and testability, but increases coupling by manually passing dependencies into each View/Model.

---

### Weakest Part of the Project

- Incomplete test coverage — although the ViewModel (RecipeListViewModel) is covered by tests, other services such as FavoritesService, ImageLoaderService, and SafariService are not tested, which makes it harder to maintain and extend the code in the future.
- Lack of full support for different devices and orientations — the app’s interface is not optimized for all device types and orientations, which may lead to inconveniences for users on certain devices.

---

### Additional Information

The architecture is designed with scalability in mind and easy integration of additional features, such as:
- User profile support
- Favorites synchronization with the server
- Simple local storage via @AppStorage
- Centralized and testable dependency management using EnvironmentKey
- Image caching for improved performance
- Easy service replacement during testing through protocols

---

### Unit Tests

**RecipeListViewModelTests**  

Covers key scenarios:
1. `testLoadRecipesSuccessUpdatesStateToLoaded`  
2. `testLoadRecipesFailureUpdatesStateToError`  
3. `testFilterRecipesByNameAndCuisine`  
4. `testFilterByCuisine`  
5. `testResetFilterRestoresAllRecipes`  
6. `testUniqueCuisinesAreSortedAndUnique`  
7. `testInitialStateIsIdle`  
8. `testMultipleLoadCallsResultInSameRecipes`  
9. `testEmptyRecipesUpdatesStateToLoadedWithEmptyArray`  

---

### Technologies

- SwiftUI  
- MVVM  
- `async/await`, `URLSession`  
- Dependency Injection via `DependencyContainer`  
- Image caching via `FileManager`  
- `@AppStorage` for local state  

---

### Constants and resources using Flyweight pattern 

- `Images.swift`, `Texts.swift` — constants and resources using Flyweight pattern  

---

### Screenshots

### Onboarding
![Onboarding](Screenshots/Onboarding.png)

### RecipeList
![Recipe List 1](Screenshots/RecipeList_1.png)
![Recipe List 2](Screenshots/RecipeList_2.png)

### RecipeDetail
![Recipe Detail 1](Screenshots/RecipeDetail_1.png)
![Recipe Detail 2](Screenshots/RecipeDetail_2.png)

### Favorites
![Favorites](Screenshots/Favorites.png)

**Onboarding/**
<div style="display: flex; gap: 10px;">
  <img src="Screenshots/Onboarding.png" alt="Onboarding" width="333"/>
</div>

**RecipeList/**
<div style="display: flex; gap: 10px;">
  <img src="Screenshots/RecipeList_1.png" alt="Recipe List 1" width="333"/>
  <img src="Screenshots/RecipeList_2.png" alt="Recipe List 2" width="333"/>
</div>

**RecipeDetail/**
<div style="display: flex; gap: 10px;">
  <img src="Screenshots/RecipeDetail_1.png" alt="Recipe Detail 1" width="333"/>
  <img src="Screenshots/RecipeDetail_2.png" alt="Recipe Detail 2" width="333"/>
</div>

**Favorites/**
<div style="display: flex; gap: 10px;">
  <img src="Screenshots/Favorites.png" alt="Favorites" width="333"/>
</div>

---

### Contact  
**Developer:** Alexander Mileychik  
**GitHub:** [github.com/AMileychik/CuisineCode](https://github.com/AMileychik/CuisineCode)  
**Email:** amileychik@gmail.com

---

### Quick Start

1. Clone the repository: https://github.com/AMileychik/CuisineCode
2. Open the `.xcodeproj` file in Xcode  
3. Build and run the project on a simulator  
