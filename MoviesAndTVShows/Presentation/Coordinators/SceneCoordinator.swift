//
//  SceneCoordinator.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 29/3/23.
//

import SwiftUI

final class SceneCoordinator: Coordinator {

    // MARK: Properties

    private let context: Context
    private let navigationController: UINavigationController
    private var mainViewModel: MainViewModelProtocol?
    private var itemToRelink: Item?

    // MARK: Initialization

    /// Creates a `SceneCoordinator` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - context: The dependency container.
    ///   - navigationController: The root navigation view controller.
    init(
        context: Context,
        navigationController: UINavigationController
    ) {
        self.context = context
        self.navigationController = navigationController
    }

    // MARK: Methods

    func start() {
        let mainViewModel = MainViewModel(context: context)
        let mainViewController = MainViewController(
            viewModel: mainViewModel,
            delegate: self
        )
        navigationController.viewControllers = [mainViewController]
        self.mainViewModel = mainViewModel
    }
}

// MARK: - MainViewControllerDelegate

extension SceneCoordinator: MainViewControllerDelegate {

    func mainViewController(
        _ mainViewController: MainViewController,
        didSelectRelinkActionForItem item: Item
    ) {
        let searchViewController = SearchViewController
            .init(
                viewModel: SearchViewModel(context: context),
                delegate: self
            )
            .dismissable()
        searchViewController.title = "Relink"
        let navigationController = UINavigationController(
            rootViewController: searchViewController
        )
        visibleViewController?.present(
            navigationController,
            animated: true
        )
        itemToRelink = item
    }

    func mainViewController(
        _ mainViewController: MainViewController,
        didSelectChangeDateActionForItem item: Item
    ) {
        guard let timestamp = item.timestamp else {
            return
        }

        let dateViewController = DateViewController(
            viewModel: DateViewModel(date: timestamp) { [weak self] date in
                self?.dateViewModelDateSelectionHandler(
                    item: item,
                    date: date
                )
            }
        ).dismissable()
        dateViewController.title = item.title
        let navigationController = UINavigationController(rootViewController: dateViewController)

        visibleViewController?.present(
            navigationController,
            animated: true
        )
    }

    func mainViewController(
        _ mainViewController: MainViewController,
        didSelectDeleteActionForItem item: Item
    ) {
        let alertController = UIAlertController(
            title: "Delete \"\(item.title ?? "item")\"",
            message: "Are you sure you want to delete this item?",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "Delete",
                style: .destructive
            ) { [weak self] _ in
                self?.itemDeletionHandler(item: item)
            }
        )

        visibleViewController?.present(
            alertController,
            animated: true
        )
    }

    func mainViewControllerDidPressSettingsButton(_ mainViewController: MainViewController) {
        let settingsViewController = UIHostingController(
            rootView: SettingsView(
                viewModel: SettingsViewModel { [weak self] in
                    self?.settingsViewModelExportToCSVHandler()
                }
            )
        ).dismissable()
        let navigationController = UINavigationController(rootViewController: settingsViewController)

        visibleViewController?.present(
            navigationController,
            animated: true
        )
    }

    func mainViewControllerDidPressAddButton(_ mainViewController: MainViewController) {
        let searchViewController = SearchViewController(
            viewModel: SearchViewModel(context: context),
            delegate: self
        ).dismissable()
        let navigationController = UINavigationController(rootViewController: searchViewController)

        visibleViewController?.present(
            navigationController,
            animated: true
        )
    }
}

// MARK: - SearchViewControllerDelegate

extension SceneCoordinator: SearchViewControllerDelegate {

    func searchViewController(
        _ searchViewController: SearchViewController,
        didSelectSearchResult searchResult: SearchResult
    ) {
        if let itemToRelink {
            context.database.items.insert(
                kind: itemToRelink.kind,
                posterURLString: searchResult.posterURLString,
                progress: itemToRelink.progress,
                timestamp: itemToRelink.timestamp,
                title: searchResult.title
            )
            context.database.items.delete(itemToRelink)
            self.itemToRelink = nil
        } else {
            context.database.items.insert(
                kind: searchResult.kind,
                posterURLString: searchResult.posterURLString,
                progress: searchResult.progress,
                timestamp: nil,
                title: searchResult.title
            )
        }

        try? context.database.save()
        mainViewModel?.reloadData()
        visibleViewController?.dismiss(animated: true)
    }
}

// MARK: - Private extension

private extension SceneCoordinator {

    // MARK: Properties

    var visibleViewController: UIViewController? {
        navigationController.visibleViewController
    }

    // MARK: Methods

    func dateViewModelDateSelectionHandler(item: Item, date: Date) {
        item.timestamp = date
        try? context.database.save()
        mainViewModel?.reloadData()
        visibleViewController?.dismiss(animated: true)
    }

    func itemDeletionHandler(item: Item) {
        context.database.items.delete(item)
        try? context.database.save()
        mainViewModel?.reloadData()
    }

    func settingsViewModelExportToCSVHandler() {
        guard
            let items = try? context.database.items.fetch(
                kind: nil,
                progress: nil,
                sortBy: \.title,
                ascending: true
            )
        else {
            return
        }

        var string = "Kind,Poster URL,Progress,Timestamp,Title\n"
        for item in items {
            let columns = [
                item.kindString ?? "nil",
                item.posterURLString ?? "nil",
                item.progressString ?? "nil",
                item.timestamp?.description ?? "nil",
                item.title ?? "nil"
            ]
            string += columns.joined(separator: ",") + "\n"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = dateFormatter.string(from: .now)
        let url = URL.temporaryDirectory.appendingPathComponent("/MoviesAndTVShows_\(dateString).csv")
        try? string.write(to: url, atomically: true, encoding: .utf8)

        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        visibleViewController?.present(
            activityViewController,
            animated: true
        )
    }
}
