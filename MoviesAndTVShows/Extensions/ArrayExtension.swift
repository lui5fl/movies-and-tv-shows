//
//  ArrayExtension.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 18/3/23.
//

extension Array {

    // MARK: Subscripts

    subscript(safe index: Int) -> Element? {
        guard
            index >= 0,
            index < endIndex
        else {
            return nil
        }

        return self[index]
    }
}
