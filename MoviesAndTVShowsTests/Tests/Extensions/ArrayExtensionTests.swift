//
//  ArrayExtensionTests.swift
//  MoviesAndTVShowsTests
//
//  Created by Luis Fariña on 13/5/23.
//

import XCTest
@testable import MoviesAndTVShows

final class ArrayExtensionTests: XCTestCase {

    // MARK: Properties

    private var sut: [Int]!

    // MARK: Set up and tear down

    override func setUp() {
        super.setUp()

        sut = [0]
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    // MARK: Tests

    func testSafeSubscript_givenIndexIsLessThanZero() {
        XCTAssertNil(sut[safe: -1])
    }

    func testSafeSubscript_givenIndexIsGreaterThanOrEqualToEndIndex() {
        XCTAssertNil(sut[safe: sut.endIndex + 1])
        XCTAssertNil(sut[safe: sut.endIndex])
    }

    func testSafeSubscript_givenIndexIsWithinBounds() {
        XCTAssertNotNil(sut[safe: 0])
    }
}
