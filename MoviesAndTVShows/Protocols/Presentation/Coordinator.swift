//
//  Coordinator.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 29/3/23.
//

import UIKit

@MainActor
protocol Coordinator {

    // MARK: Methods

    /// Starts the navigation flow.
    func start()
}
