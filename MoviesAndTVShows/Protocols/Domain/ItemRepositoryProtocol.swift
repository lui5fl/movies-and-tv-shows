//
//  ItemRepositoryProtocol.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 5/4/23.
//

import Foundation

protocol ItemRepositoryProtocol {

    // MARK: Methods

    /// Fetch items according to the given parameters.
    ///
    /// - Parameters:
    ///   - kind: The kind of the items.
    ///   - progress: The progress of the items.
    ///   - keyPath: The key path by which to sort the items.
    ///   - ascending: Whether to sort the items in ascending order.
    func fetch<Value>(
        kind: Item.Kind?,
        progress: Item.Progress?,
        sortBy keyPath: KeyPath<Item, Value>,
        ascending: Bool
    ) throws -> [Item]

    /// Insert an item with the given parameters.
    ///
    /// - Parameters:
    ///   - kind: The kind of the item.
    ///   - posterURLString: The URL of the item's poster as a string.
    ///   - progress: The progress of the item.
    ///   - timestamp: The timestamp of the item.
    ///   - title: The title of the item.
    func insert(
        kind: Item.Kind?,
        posterURLString: String?,
        progress: Item.Progress?,
        timestamp: Date?,
        title: String?
    )

    /// Delete an item.
    ///
    /// - Parameters:
    ///   - item: The item to delete.
    func delete(_ item: Item)
}
