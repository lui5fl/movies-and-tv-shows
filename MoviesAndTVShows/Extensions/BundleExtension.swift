//
//  BundleExtension.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 8/5/23.
//

import Foundation

extension Bundle {

    // MARK: Methods

    /// Returns a dictionary constructed from the property list with the specified name.
    ///
    /// - Parameters:
    ///   - name: The name of the property list.
    func propertyList(named name: String) -> [String: Any]? {
        guard
            let url = url(forResource: name, withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let propertyList = try? PropertyListSerialization.propertyList(
                from: data,
                format: nil
            ) as? [String: Any]
        else {
            return nil
        }

        return propertyList
    }
}
