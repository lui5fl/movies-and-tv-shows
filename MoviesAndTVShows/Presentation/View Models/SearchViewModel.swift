//
//  SearchViewModel.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 6/5/23.
//

import Combine

final class SearchViewModel: SearchViewModelProtocol {

    // MARK: Properties

    private let context: Context

    @Published var networkErrorHappened: Void = ()
    var networkErrorHappenedPublisher: AnyPublisher<Void, Never> {
        $networkErrorHappened.dropFirst().eraseToAnyPublisher()
    }

    @Published var searchResults: [SearchResult] = []
    var searchResultsPublisher: AnyPublisher<[SearchResult], Never> {
        $searchResults.eraseToAnyPublisher()
    }

    // MARK: Initialization

    /// Creates a `SearchViewModel` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - context: The dependency container.
    init(context: Context) {
        self.context = context
    }

    // MARK: Methods

    func searchButtonClicked(searchBarText: String?) {
        guard let searchBarText else {
            return
        }

        Task {
            do {
                let results = try await context.tmdbAPI.search.searchAll(
                    query: searchBarText,
                    page: 1
                ).results

                searchResults = results.compactMap {
                    switch $0 {
                    case .movie(let movie):
                        return SearchResult(
                            id: movie.id,
                            kind: .movie,
                            posterURLString: movie.posterPath.map {
                                "https://image.tmdb.org/t/p/w500\($0.absoluteString)"
                            },
                            progress: .backlog,
                            title: movie.title
                        )
                    case .tvShow(let tvShow):
                        return SearchResult(
                            id: tvShow.id,
                            kind: .tvShow,
                            posterURLString: tvShow.posterPath.map {
                                "https://image.tmdb.org/t/p/w500\($0.absoluteString)"
                            },
                            progress: .backlog,
                            title: tvShow.name
                        )
                    default:
                        return nil
                    }
                }
            } catch {
                networkErrorHappened = ()
            }
        }
    }
}
