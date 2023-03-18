//
//  DatabaseProtocol.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 5/4/23.
//

protocol DatabaseProtocol {

    // MARK: Properties

    /// The repository through which to execute database operations related to items.
    var items: ItemRepositoryProtocol { get }

    // MARK: Methods

    /// Attempt to save the latest changes.
    func save() throws
}
