//
//  SearchViewModelProtocol.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 6/5/23.
//

import Combine

@MainActor
protocol SearchViewModelProtocol: AnyObject {

    // MARK: Properties

    /// The publisher that emits an event when a network error happens.
    var networkErrorHappenedPublisher: AnyPublisher<Void, Never> { get }

    /// The publisher that publishes the search results to be displayed.
    var searchResultsPublisher: AnyPublisher<[SearchResult], Never> { get }

    // MARK: Methods

    /// Called when the search button is triggered.
    ///
    /// - Parameters:
    ///   - searchBarText: The text of the search bar.
    func searchButtonClicked(searchBarText: String?)
}
