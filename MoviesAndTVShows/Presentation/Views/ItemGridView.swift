//
//  ItemGridView.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 18/3/23.
//

import Nuke
import NukeUI
import SwiftUI
import UIKit

final class ItemGridView<Item: ItemProtocol>: UIView,
                                              UICollectionViewDelegate {

    // MARK: Types

    typealias ContextMenuConfiguration = (Item) -> UIContextMenuConfiguration?
    typealias ItemSelectionHandler = (Item) -> Void

    // MARK: Properties

    private let contextMenuConfiguration: ContextMenuConfiguration?
    private let itemSelectionHandler: ItemSelectionHandler?
    private let imagePipeline: ImagePipeline

    private lazy var collectionView = {
        let heightDimension = NSCollectionLayoutDimension.fractionalWidth(1/2)
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: heightDimension
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: heightDimension
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let collectionViewLayout = UICollectionViewCompositionalLayout(section: section)

        return UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
    }()

    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(
        collectionView: collectionView,
        cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UICollectionViewCell.reuseIdentifier,
                for: indexPath
            )

            cell.clipsToBounds = true
            cell.contentConfiguration = UIHostingConfiguration {
                if let posterURLString = item.posterURLString {
                    LazyImage(
                        url: URL(string: posterURLString),
                        transaction: Transaction(animation: .easeOut)
                    ) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else {
                            EmptyView()
                        }
                    }
                    .pipeline(self.imagePipeline)
                } else {
                    Color(uiColor: .secondarySystemBackground)
                        .overlay(
                            Text(item.title ?? "")
                                .multilineTextAlignment(.center)
                                .padding()
                        )
                }
            }
            .margins(.all, 0)

            return cell
        }
    )

    var items: [Item] = [] {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapshot.appendSections([.main])
            snapshot.appendItems(items)

            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    // MARK: Initialization

    init(
        contextMenuConfiguration: ContextMenuConfiguration? = nil,
        itemSelectionHandler: ItemSelectionHandler? = nil,
        imagePipeline: ImagePipeline = .shared
    ) {
        self.contextMenuConfiguration = contextMenuConfiguration
        self.itemSelectionHandler = itemSelectionHandler
        self.imagePipeline = imagePipeline

        super.init(frame: .zero)

        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard
            let itemSelectionHandler,
            let item = items[safe: indexPath.row]
        else {
            return
        }

        itemSelectionHandler(item)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard
            let contextMenuConfiguration,
            let row = indexPaths.first?.row,
            let item = items[safe: row]
        else {
            return nil
        }

        return contextMenuConfiguration(item)
    }
}

// MARK: - Private extension

private extension ItemGridView {

    // MARK: Types

    enum Section {
        case main
    }

    // MARK: Methods

    func setUp() {
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: UICollectionViewCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
