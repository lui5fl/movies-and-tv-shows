//
//  UIActionExtension.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 28/3/23.
//

import UIKit

extension UIAction {

    // MARK: Methods

    /// Creates a `UIAction` instance for a "move to progress" action.
    ///
    /// - Parameters:
    ///   - progress: The progress in which to base the style of the action.
    ///   - handler: The closure to call when the action is selected.
    static func move(
        to progress: Item.Progress,
        handler: @escaping () -> Void
    ) -> UIAction {
        UIAction(
            title: "Move to \(progress.name)",
            image: UIImage(systemName: progress.systemImage)
        ) { _ in
            handler()
        }
    }

    /// Creates a `UIAction` instance for a "relink" action.
    ///
    /// - Parameters:
    ///   - handler: The closure to call when the action is selected.
    static func relink(handler: @escaping () -> Void) -> UIAction {
        UIAction(
            title: "Relink",
            image: UIImage(systemName: "link")
        ) { _ in
            handler()
        }
    }

    /// Creates a `UIAction` instance for a "change date" action.
    ///
    /// - Parameters:
    ///   - handler: The closure to call when the action is selected.
    static func changeDate(handler: @escaping () -> Void) -> UIAction {
        UIAction(
            title: "Change date",
            image: UIImage(systemName: "calendar")
        ) { _ in
            handler()
        }
    }

    /// Creates a `UIAction` instance for a "delete" action.
    ///
    /// - Parameters:
    ///   - handler: The closure to call when the action is selected.
    static func delete(handler: @escaping () -> Void) -> UIAction {
        UIAction(
            title: "Delete",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { _ in
            handler()
        }
    }
}
