//
//  SettingsViewModel.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 5/5/23.
//

struct SettingsViewModel: SettingsViewModelProtocol {

    // MARK: Types

    typealias ExportToCSVHandler = () -> Void

    // MARK: Properties

    private let exportToCSVHandler: ExportToCSVHandler

    // MARK: Initialization

    /// Creates a `SettingsViewModel` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - exportToCSVHandler: The closure to call when the "export to CSV" button is triggered.
    init(exportToCSVHandler: @escaping ExportToCSVHandler) {
        self.exportToCSVHandler = exportToCSVHandler
    }

    // MARK: Methods

    func onExportToCSVButtonTrigger() {
        exportToCSVHandler()
    }
}
