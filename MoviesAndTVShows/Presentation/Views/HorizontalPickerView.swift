//
//  HorizontalPickerView.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 18/3/23.
//

import SwiftUI
import UIKit

struct HorizontalPickerItem<Item: Hashable>: Hashable {

    // MARK: Properties

    let label: String
    let item: Item
}

final class HorizontalPickerView<Item: Hashable>: UIView,
                                                  UICollectionViewDelegate {

    // MARK: Types

    typealias ItemSelectionHandler = (Item) -> Void

    // MARK: Properties

    private let items: [HorizontalPickerItem<Item>]
    private let itemSelectionHandler: ItemSelectionHandler

    private lazy var collectionView = {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let sectionSpacing: CGFloat = 15
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: sectionSpacing,
            bottom: 0,
            trailing: sectionSpacing
        )
        section.interGroupSpacing = sectionSpacing
        section.orthogonalScrollingBehavior = .continuous
        let collectionViewLayout = UICollectionViewCompositionalLayout(section: section)

        return UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
    }()

    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, HorizontalPickerItem<Item>>(
        collectionView: collectionView,
        cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UICollectionViewCell.reuseIdentifier,
                for: indexPath
            )

            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = UIHostingConfiguration {
                    Text(item.label)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(state.isSelected ? .primary : .secondary)
                }
                .margins(.all, 0)
            }

            return cell
        }
    )

    // MARK: Initialization

    /// Creates a `HorizontalPickerView` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - items: The items of the picker.
    ///   - selectedItem: The item that is initially selected.
    ///   - itemSelectionHandler: The closure to call when an item is selected.
    init(
        items: [HorizontalPickerItem<Item>],
        selectedItem: Item?,
        itemSelectionHandler: @escaping ItemSelectionHandler
    ) {
        self.items = items
        self.itemSelectionHandler = itemSelectionHandler

        super.init(frame: .zero)

        setUp()

        var snapshot = NSDiffableDataSourceSnapshot<Section, HorizontalPickerItem<Item>>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)

        dataSource.apply(snapshot, animatingDifferences: true)

        if let row = items.firstIndex(where: { $0.item == selectedItem }) {
            collectionView.selectItem(
                at: IndexPath(row: row, section: 0),
                animated: false,
                scrollPosition: .centeredHorizontally
            )
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let item = items[safe: indexPath.row]?.item else {
            return
        }

        itemSelectionHandler(item)
        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
}

// MARK: - Private extension

private extension HorizontalPickerView {

    // MARK: Types

    enum Section {
        case main
    }

    // MARK: Methods

    func setUp() {
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: UICollectionViewCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
