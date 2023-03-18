//
//  ItemRepository.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 25/3/23.
//

import CoreData

struct ItemRepository: ItemRepositoryProtocol {

    // MARK: Properties

    private let container: NSPersistentContainer

    // MARK: Initialization

    /// Creates an `ItemRepository` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - container: The Core Data stack container
    init(container: NSPersistentContainer) {
        self.container = container
    }

    // MARK: Methods

    func fetch<Value>(
        kind: Item.Kind?,
        progress: Item.Progress?,
        sortBy keyPath: KeyPath<Item, Value>,
        ascending: Bool
    ) throws -> [Item] {
        let request = Item.fetchRequest()
        request.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                kind.map {
                    NSPredicate(
                        format: "%K == %@",
                        #keyPath(Item.kindString),
                        $0.rawValue
                    )
                },
                progress.map {
                    NSPredicate(
                        format: "%K == %@",
                        #keyPath(Item.progressString),
                        $0.rawValue
                    )
                }
            ]
            .compactMap { $0 }
        )
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: keyPath,
                ascending: ascending
            )
        ]

        return try container.viewContext.fetch(request)
    }

    func insert(
        kind: Item.Kind?,
        posterURLString: String?,
        progress: Item.Progress?,
        timestamp: Date?,
        title: String?
    ) {
        let item = Item(context: container.viewContext)
        item.kind = kind
        item.posterURLString = posterURLString
        item.progress = progress
        item.timestamp = timestamp
        item.title = title
    }

    func delete(_ item: Item) {
        container.viewContext.delete(item)
    }
}
