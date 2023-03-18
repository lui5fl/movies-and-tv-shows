//
//  Database.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 18/3/23.
//

import CoreData

struct Database: DatabaseProtocol {

    // MARK: Properties

    private let container: NSPersistentCloudKitContainer
    let items: ItemRepositoryProtocol

    // MARK: Initialization

    init() {
        container = NSPersistentCloudKitContainer(name: "MoviesAndTVShows")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        items = ItemRepository(container: container)
    }

    // MARK: Methods

    func save() throws {
        let viewContext = container.viewContext

        guard viewContext.hasChanges else {
            return
        }

        try viewContext.save()
    }
}
