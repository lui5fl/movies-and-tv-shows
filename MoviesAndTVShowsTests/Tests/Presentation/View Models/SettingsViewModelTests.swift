//
//  SettingsViewModelTests.swift
//  MoviesAndTVShowsTests
//
//  Created by Luis Fariña on 14/5/23.
//

import XCTest
@testable import MoviesAndTVShows

@MainActor
final class SettingsViewModelTests: XCTestCase {

    // MARK: Tests

    func testOnExportToCSVButtonTrigger() {
        // Given
        var exportToCSVHandlerCallCount = 0
        let sut = SettingsViewModel {
            exportToCSVHandlerCallCount += 1
        }

        // When
        sut.onExportToCSVButtonTrigger()

        // Then
        XCTAssertEqual(exportToCSVHandlerCallCount, 1)
    }
}
