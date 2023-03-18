//
//  MainViewModelProtocol.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 6/5/23.
//

import Combine

@MainActor
protocol MainViewModelProtocol: AnyObject {

    // MARK: Properties

    /// The selected kind.
    var kind: Item.Kind? { get set }

    /// The selected progress.
    var progress: Item.Progress { get set }

    /// The publisher that publishes the items to be displayed.
    var itemsPublisher: AnyPublisher<[Item], Never> { get }

    // MARK: Methods

    /// Called when the view loads.
    func viewDidLoad()

    /// Called when the "move to progress" action for the specified item is selected.
    ///
    /// - Parameters:
    ///   - item: The item whose "move to progress" action was selected.
    ///   - progress: The new progress.
    func onMoveToProgressActionSelection(
        item: Item,
        progress: Item.Progress
    )

    /// Fetches the items to be displayed.
    func reloadData()
}
