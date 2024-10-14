
# Movie Discovery App

## Overview
**The Movie Discovery** App allows users to explore the top movies of the year, view detailed information about each movie, and book tickets. For the time being, the app redirects users to a Google WebView for booking, but this functionality can be updated in the future to enhance the user experience.

## Features
- **Discovery:** List of top 10 movies for the year.
- **Movie Details:** Information on duration, director, genres, and actors.
- **Image Fetching:** Displays movie posters dynamically.
- **Video Support (Upcoming):** Plans to include movie trailers and videos.
- **Caching:** Utilizes `NSCache` for performance optimization.
- **Accessibility:** Improved support for dynamic text and screen readers.
- **Programmatic Auto Layout:** Layout handled entirely in code.

## Architecture
The app follows **MVVM** architecture:
- **Model:** Contains data structures (e.g., `MovieModel`, `MovieDetailModel`).
- **View:** UI components (`ViewControllers` and `Views`).
- **ViewModel:** Manages business logic and state.

## How It Works
1. **Discovery Screen:** Displays top 10 movies using `UICollectionView`.
2. **Movie Detail Screen:** Shows detailed information for selected movies.
3. **Networking:** Fetches data using `NetworkClientAPI` and caches it.
4. **Image Fetching:** Images fetched asynchronously and displayed.
5. **Video Support (Upcoming):** Future updates will allow streaming trailers.
6. **Error Handling:** Displays messages for network issues.

## API Integration
The app uses two endpoints:
1. **Top Movies List:** Fetches the top 10 movies.
2. **Movie Details:** Retrieves detailed info by movie ID.

## Networking and Caching
- `NetworkClientAPI`: Handles API requests.
- `MovieCacheManager`: Manages caching of movie details.

## Project Structure
```
├── MovieDiscoveryApp
│   ├── Models
│   ├── ViewModels
│   ├── Views
│   ├── Networking
│   └── Utilities
```

## Usage
- **DiscoveryViewController:** Displays the movie list.
- **MovieDetailViewController:** Shows details for selected movies.
- Handles network calls and caching.

### Image Fetching
Images are fetched using `fetchImage(from:)` in `NetworkClientAPI`.

### Dummy Data
Currently uses dummy data in `NetworkClientAPI.swift`. It can easily replaced with actual API responses.

## Testing
Consider writing unit tests for:
- ViewModel logic
- Caching mechanism
- Network failure scenarios

## Improvements and Future Enhancements
- **Persistent Caching:** Consider Core Data for offline usage.
- **Unit Testing:** Add tests for ViewModel and network operations.
- **Video Support:** Introduce movie trailer playback.
- **API Expansion:** More movie-related details and features.

## Sample Video

https://github.com/user-attachments/assets/bfdeae90-3f46-4fa8-8ab4-ef77f978e96d

