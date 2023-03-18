//
//  Context.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 18/3/23.
//

import TMDb

struct Context {

    // MARK: Properties

    /// The item database.
    let database: DatabaseProtocol

    /// The client for interacting with the TMDB API.
    let tmdbAPI: TMDbAPI
}
