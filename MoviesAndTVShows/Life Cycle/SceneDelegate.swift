//
//  SceneDelegate.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 18/3/23.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: Properties

    /// The coordinator that directs the scene's behaviour and flow.
    private var sceneCoordinator: SceneCoordinator?

    var window: UIWindow?

    // MARK: Methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        guard let context else {
            fatalError("The Context instance in AppDelegate is nil.")
        }

        let navigationController = UINavigationController()
        sceneCoordinator = SceneCoordinator(
            context: context,
            navigationController: navigationController
        )
        sceneCoordinator?.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        try? context?.database.save()
    }
}

// MARK: - Private extension

private extension SceneDelegate {

    // MARK: Properties

    var context: Context? {
        (UIApplication.shared.delegate as? AppDelegate)?.context
    }
}
