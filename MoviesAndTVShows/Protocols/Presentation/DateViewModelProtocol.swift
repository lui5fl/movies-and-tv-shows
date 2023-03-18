//
//  DateViewModelProtocol.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 5/5/23.
//

import Combine
import Foundation

@MainActor
protocol DateViewModelProtocol: AnyObject {

    // MARK: Properties

    /// The selected date.
    var date: Date { get }

    /// The publisher which publishes whether the OK bar button item should be enabled.
    var okBarButtonItemIsEnabledPublisher: AnyPublisher<Bool, Never> { get }

    // MARK: Methods

    /// Called when a date is selected.
    ///
    /// - Parameters:
    ///   - dateComponents: The selected date as a `DateComponents` instance.
    func didSelectDate(_ dateComponents: DateComponents?)

    /// Called when the OK bar button item is selected.
    func onOKBarButtonItemSelection()
}
