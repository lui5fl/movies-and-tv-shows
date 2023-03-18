//
//  SettingsViewModelProtocol.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 5/5/23.
//

@MainActor
protocol SettingsViewModelProtocol {

    // MARK: Methods

    /// Called when the "export to CSV" button is triggered.
    func onExportToCSVButtonTrigger()
}
