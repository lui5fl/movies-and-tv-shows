//
//  SearchResult.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 25/3/23.
//

struct SearchResult: ItemProtocol {

    // MARK: Properties

    /// The identifier of the search result.
    let id: Int

    let kind: Item.Kind?
    let posterURLString: String?
    let progress: Item.Progress?
    let title: String?
}
