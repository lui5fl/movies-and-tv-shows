//
//  ItemProtocol.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 25/3/23.
//

protocol ItemProtocol: Hashable, Identifiable {

    // MARK: Properties

    /// The kind of the item.
    var kind: Item.Kind? { get }

    /// The URL of the item's poster as a string.
    var posterURLString: String? { get }

    /// The progress of the item.
    var progress: Item.Progress? { get }

    /// The title of the item.
    var title: String? { get }
}
