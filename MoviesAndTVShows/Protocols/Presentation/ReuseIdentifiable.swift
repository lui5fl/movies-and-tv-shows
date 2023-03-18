//
//  ReuseIdentifiable.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 18/3/23.
//

import UIKit

protocol ReuseIdentifiable {

    // MARK: Properties

    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {

    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UICollectionViewCell: ReuseIdentifiable {}
