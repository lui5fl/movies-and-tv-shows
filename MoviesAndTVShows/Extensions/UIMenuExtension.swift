//
//  UIMenuExtension.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 28/3/23.
//

import UIKit

extension UIMenu {

    // MARK: Initialization

    /// Creates a `UIMenu` instance from an array of submenus whose children will be
    /// displayed inline.
    ///
    /// - Parameters:
    ///   - submenus: The array of submenus.
    convenience init(submenus: [[UIAction]]) {
        self.init(
            children: submenus.map {
                UIMenu(options: .displayInline, children: $0)
            }
        )
    }
}
