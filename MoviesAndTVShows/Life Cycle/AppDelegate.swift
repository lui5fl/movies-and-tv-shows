//
//  AppDelegate.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 18/3/23.
//

import TMDb
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties

    /// The dependency container.
    private(set) var context: Context!

    // MARK: Methods

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard
            let keyPropertyList = Bundle.main.propertyList(named: "Key"),
            let tmdbAPIKey = keyPropertyList["TMDB_API_KEY"] as? String
        else {
            fatalError("Could not retrieve the TMDB API key from the \"Key.plist\" file.")
        }

        context = Context(
            database: Database(),
            tmdbAPI: TMDbAPI(apiKey: tmdbAPIKey)
        )

        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}
