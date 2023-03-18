//
//  UIViewControllerExtension.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 27/3/23.
//

import UIKit

extension UIViewController {

    // MARK: Methods

    /// Makes the view controller dismissable by setting a close button as its left bar button
    /// item.
    func dismissable() -> Self {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(onCloseBarButtonItemSelection)
        )

        return self
    }

    /// Presents an alert apt for a network error.
    func presentAlertForNetworkError() {
        let alertController = UIAlertController(
            title: "Network error",
            message: "Try again later.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
}

// MARK: - Private extension

private extension UIViewController {

    // MARK: Methods

    @objc
    func onCloseBarButtonItemSelection() {
        dismiss(animated: true)
    }
}
