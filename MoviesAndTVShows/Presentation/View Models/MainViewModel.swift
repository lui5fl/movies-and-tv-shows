//
//  MainViewModel.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 6/5/23.
//

import Combine
import Foundation

final class MainViewModel: MainViewModelProtocol {

    // MARK: Properties

    private let context: Context

    var kind: Item.Kind? {
        didSet {
            reloadData()
        }
    }

    var progress: Item.Progress = .backlog {
        didSet {
            reloadData()
        }
    }

    @Published var items: [Item] = []
    var itemsPublisher: AnyPublisher<[Item], Never> {
        $items.eraseToAnyPublisher()
    }

    // MARK: Initialization

    /// Creates a `MainViewModel` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - context: The dependency container.
    init(context: Context) {
        self.context = context
    }

    // MARK: Methods

    func viewDidLoad() {
        reloadData()
    }

    func onMoveToProgressActionSelection(
        item: Item,
        progress: Item.Progress
    ) {
        item.progress = progress
        item.timestamp = progress == .watched ? Date() : nil
        try? context.database.save()
        reloadData()
    }

    func reloadData() {
        if progress == .watched {
            items = (
                try? context.database.items.fetch(
                    kind: kind,
                    progress: progress,
                    sortBy: \.timestamp,
                    ascending: false
                )
            ) ?? []
        } else {
            items = (
                try? context.database.items.fetch(
                    kind: kind,
                    progress: progress,
                    sortBy: \.title,
                    ascending: true
                )
            ) ?? []
        }
    }
}
