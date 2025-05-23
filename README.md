# CuisineCode

### Summary

**CuisineCode** is an iOS application for discovering, viewing, and saving recipes, with support for opening external links.  
On first launch, users are prompted to enter their name to personalize the experience. 
The app is built on the MVVM architecture using `async/await`, dependency injection, and local caching.  
The project follows clean architecture principles with a focus on modularity, testability, and user experience (UX).

---

### Features

**Onboarding**

- User name entry on first launch using `@AppStorage`  
- Onboarding screen will appear only once when the app is launched for the first time. To reset it, delete the app from simulator/device.

**RecipeList**

- Time-based greeting for the user  
- Search and filtering by cuisine  
- Banner with external link (Fetch) via `SFSafariViewController`  
- Recipe loading from JSON (adaptive `LazyVGrid` layout)  

**RecipeDetail**

- Displays recipe image, description, and cuisine  
- Favorite toggle  
- “Watch Recipe” and “Video” buttons using `SFSafariViewController`  
- Horizontal partner slider with external links  

**Favorites**

- Animated “Favorites” header  
- Separate list of favorited recipes  

---

### Focus Areas

Main development priorities:
- Clean architecture emphasizing scalability and testability  
- Clear separation of concerns with MVVM layers and DI via `DependencyContainer`, `ViewModelFactory` and `ScreenFactory` 
- Modern UI/UX with minimalist design, animations, and state adaptation (`@StateObject`, `@AppStorage`)  
- Performance: Custom `ImageLoaderService` with caching via `FileManager`  
- Modular approach: each feature is encapsulated in a separate component

---

### Services

**NetworkService/**

Asynchronously loads recipes from a remote source using `URLSession`.  
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

Dependency Management
- All services are injected via `DependencyContainer`, conforming to `DependencyContainerProtocol`
- `DependencyContainer` holds services (`NetworkService`, `FavoritesService`, etc.)
- `ViewModelFactory` creates ViewModels for screens
- `ScreenFactory` builds views and injects dependencies
- Supports preview mode with mock services via `makePreview()`

---

### Time Spent

| Stage                       | Hours  |
|-----------------------------|--------|
| Architecture + DI           | 8 h    |
| RecipeList + filtering      | 10 h    |
| RecipeDetail + Safari       | 6 h    |
| Image caching               | 3 h    |
| Favorites + `@AppStorage`   | 3 h    |
| Unit tests                  | 3 h    |
| README                      | 2 h    |

**Total — approx. 35 hours**

---

### Trade-offs and Decisions

- Using Dependency Injection (DI) via DependencyContainer, ViewModelFactory and ScreenFactory — a centralized and explicit way to manage dependencies. It improves testability and modularity by allowing easy service replacement and mocking. However, it introduces additional boilerplate and may slightly increase architectural complexity, especially in smaller projects.

- Using MVVM architecture — improves separation of concerns by keeping UI logic in the ViewModel, making the codebase more testable and maintainable. However, in SwiftUI, ViewModels can sometimes grow too large if not carefully structured, and binding complex UI states may introduce boilerplate or lead to tight coupling between Views and ViewModels.

- Separating image loading and caching logic into a dedicated service (ImageLoaderService) enhances reusability and testability, but increases coupling by manually passing dependencies into each View/Model.

---

### Weakest Part of the Project

- Incomplete test coverage — although the ViewModel (RecipeListViewModel) is covered by tests, other services such as FavoritesService, ImageLoaderService, and SafariService are not tested, which makes it harder to maintain and extend the code in the future.

- Lack of full support for different devices and orientations — the app’s interface is not optimized for all device types and orientations, which may lead to inconveniences for users on certain devices.

- Insufficient error transparency — users are not always informed about the nature of an error (e.g., “data format error”), which can reduce trust in the app and complicate debugging.

- Missing visual feedback during loading — the absence of shimmer or skeleton views can lead to a perception of slowness or broken functionality, especially on slower networks.

---

### Additional Information

The architecture is designed with scalability in mind and easy integration of additional features, such as:
- User profile support
- Favorites synchronization with the server
- Image caching for improved performance
- Easy service replacement during testing through protocols
- DI setup allows easy integration of new services and features without changing existing code
- Clear boundary between infrastructure and business logic

---

### Unit Tests

**RecipeListViewModelTests**  

Covers key scenarios:
- `testLoadRecipesSuccessUpdatesStateToLoaded`  
- `testLoadRecipesFailureUpdatesStateToError`  
- `testFilterRecipesByNameAndCuisine`  
- `testFilterByCuisine`  
- `testResetFilterRestoresAllRecipes`  
- `testUniqueCuisinesAreSortedAndUnique`  
- `testInitialStateIsIdle`  
- `testMultipleLoadCallsResultInSameRecipes`  
- `testEmptyRecipesUpdatesStateToLoadedWithEmptyArray`  

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

- `Images.swift`, `Texts.swift` - centralized reuse of static UI constants to reduce memory usage and ensure consistency.

---

### Screenshots

**Onboarding/**  
<div style="display: flex; gap: 10px;">
  <img src="https://raw.githubusercontent.com/AMileychik/CuisineCode/main/CuisineCode/Screenshots/Onboarding.png" alt="Onboarding" width="333"/>
</div>

**RecipeList/**  
<div style="display: flex; gap: 10px;">
  <img src="https://raw.githubusercontent.com/AMileychik/CuisineCode/main/CuisineCode/Screenshots/RecipeList_1.png" alt="Recipe List 1" width="333"/>
  <img src="https://raw.githubusercontent.com/AMileychik/CuisineCode/main/CuisineCode/Screenshots/RecipeList_2.png" alt="Recipe List 2" width="333"/>
</div>

**RecipeDetail/**  
<div style="display: flex; gap: 10px;">
  <img src="https://raw.githubusercontent.com/AMileychik/CuisineCode/main/CuisineCode/Screenshots/RecipeDetail_1.png" alt="Recipe Detail 1" width="333"/>
  <img src="https://raw.githubusercontent.com/AMileychik/CuisineCode/main/CuisineCode/Screenshots/RecipeDetail_2.png" alt="Recipe Detail 2" width="333"/>
</div>

**Favorites/**  
<div style="display: flex; gap: 10px;">
  <img src="https://raw.githubusercontent.com/AMileychik/CuisineCode/main/CuisineCode/Screenshots/Favorites.png" alt="Favorites" width="333"/>
</div>

---

### Contact  
**Developer:** Alexander Mileychik  
**GitHub:** [github.com/AMileychik/CuisineCode](https://github.com/AMileychik)  
**Email:** amileychik@gmail.com

---

### Quick Start

1. Clone the repository: https://github.com/AMileychik/CuisineCode
2. Open the `.xcodeproj` file in Xcode  
3. Build and run the project on a simulator  
