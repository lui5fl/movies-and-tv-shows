# Movies And TV Shows
Movies And TV Shows[^1] is a **movie and TV show tracking app for iPhone**. Add movies and TV shows to your backlog and mark them as "watching" or watched later on: it's as simple as it gets! The app is built using UIKit with some SwiftUI sprinkled here and there.

[Video](https://github.com/lui5fl/movies-and-tv-shows/assets/12814370/3a35b0d0-329b-4a05-956e-8b5ce0070ed3)

## Motivation
I was on the lookout for a movie and TV show tracking app but the ones I tried were either too complicated or had a user interface that I didn't like, so I set out to build my own following the next three principles:
- **Flexibility:** allow the user to export all data if they want to
- **Simplicity:** no menu diving, just long-press an item to move it from one list to another
- **Strikingness:** give the gorgeous movie and TV show posters the screen real estate they deserve

## Installation

An API key is required to retrieve movie and TV show metadata from TMDB. Read the [TMDB API documentation](https://developer.themoviedb.org/docs) for more information on how to apply for one.

Once you've got an API key, you must create a `Key.plist` file inside the `Resources` folder of the Xcode project. This property list must have a `TMDB_API_KEY` property with your API key as its value.

## Technologies

### Apple
- Combine
- Core Data
- SwiftUI
- UIKit

### Third-party
- [adamayoung/TMDb](https://github.com/adamayoung/TMDb)
- [kean/Nuke](https://github.com/kean/Nuke)

## Architecture
The app follows the MVVM and Coordinator architectural patterns. The `SceneCoordinator` class is responsible for directing the scene's behaviour and flow, initializing the views and its view models. The view models' properties are bound to the views using Combine.

## Roadmap
- [Issues](https://github.com/lui5fl/movies-and-tv-shows/issues)
- [Project](https://github.com/users/lui5fl/projects/4)

## Attribution
All movie and TV show metadata used in this application is supplied by [The Movie Database](https://www.themoviedb.org) (TMDB). This application uses the TMDB API but is not endorsed or certified by TMDB.

<img src="https://github.com/lui5fl/movies-and-tv-shows/assets/12814370/824e914e-85d5-45a2-b270-75dfdb26f89e" height="45">

## License
Released under GPL-3.0 license. See [LICENSE](/LICENSE) for details.

[^1]: Still got to think of a proper name...