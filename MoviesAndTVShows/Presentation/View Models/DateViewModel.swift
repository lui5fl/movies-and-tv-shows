//
//  DateViewModel.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 5/5/23.
//

import Combine
import Foundation

final class DateViewModel: DateViewModelProtocol {

    // MARK: Types

    typealias DateSelectionHandler = (Date) -> Void

    // MARK: Properties

    private(set) var date: Date
    private let dateSelectionHandler: DateSelectionHandler

    @Published var okBarButtonItemIsEnabled = false
    var okBarButtonItemIsEnabledPublisher: AnyPublisher<Bool, Never> {
        $okBarButtonItemIsEnabled.eraseToAnyPublisher()
    }

    // MARK: Initialization

    /// Creates a `DateViewModel` instance with the given arguments.
    ///
    /// - Parameters:
    ///   - date: The date that is initially selected.
    ///   - dateSelectionHandler: The closure to call when a date selection is confirmed.
    init(
        date: Date,
        dateSelectionHandler: @escaping DateSelectionHandler
    ) {
        self.date = date
        self.dateSelectionHandler = dateSelectionHandler
    }

    // MARK: Methods

    func didSelectDate(_ dateComponents: DateComponents?) {
        guard let date = dateComponents?.date else {
            return
        }

        self.date = date
        okBarButtonItemIsEnabled = true
    }

    func onOKBarButtonItemSelection() {
        dateSelectionHandler(date)
    }
}
