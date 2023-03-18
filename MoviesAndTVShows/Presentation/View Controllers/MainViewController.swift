//
//  MainViewController.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 18/3/23.
//

import Combine
import Nuke
import UIKit

protocol MainViewControllerDelegate: AnyObject {

    // MARK: Methods

    /// Tells the delegate that the "change date" action for the specified item was selected.
    ///
    /// - Parameters:
    ///   - mainViewController: The `MainViewController` instance informing the delegate of this event.
    ///   - item: The item whose "change date" action was selected.
    func mainViewController(
        _ mainViewController: MainViewController,
        didSelectChangeDateActionForItem item: Item
    )

    /// Tells the delegate that the "delete" action for the specified item was selected.
    ///
    /// - Parameters:
    ///   - mainViewController: The `MainViewController` instance informing the delegate of this event.
    ///   - item: The item whose "delete" action was selected.
    func mainViewController(
        _ mainViewController: MainViewController,
        didSelectDeleteActionForItem item: Item
    )

    /// Tells the delegate that the settings button was pressed.
    ///
    /// - Parameters:
    ///   - mainViewController: The `MainViewController` instance informing the delegate of this event.
    func mainViewControllerDidPressSettingsButton(_ mainViewController: MainViewController)

    /// Tells the delegate that the add button was pressed.
    ///
    /// - Parameters:
    ///   - mainViewController: The `MainViewController` instance informing the delegate of this event.
    func mainViewControllerDidPressAddButton(_ mainViewController: MainViewController)
}

final class MainViewController: UIViewController {

    // MARK: Properties

    private let viewModel: MainViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    private weak var delegate: MainViewControllerDelegate?

    private lazy var kindHorizontalPickerView = HorizontalPickerView(
        items: [
            HorizontalPickerItem(label: "All", item: nil),
            HorizontalPickerItem(label: "Movies", item: .movie),
            HorizontalPickerItem(label: "TV Shows", item: .tvShow)
        ],
        selectedItem: viewModel.kind
    ) { [weak self] kind in
        self?.viewModel.kind = kind
    }

    private lazy var progressHorizontalPickerView = HorizontalPickerView(
        items: Item.Progress.allCases.map {
            HorizontalPickerItem(label: $0.name, item: $0)
        },
        selectedItem: viewModel.progress
    ) { [weak self] progress in
        self?.viewModel.progress = progress
    }

    private lazy var itemGridView = ItemGridView(
        contextMenuConfiguration: { [weak self] item in
            UIContextMenuConfiguration(
                actionProvider: { _ in
                    UIMenu(
                        submenus: [
                            self?.moveToProgressActionSubmenu(item: item),
                            self?.changeDateActionSubmenu(item: item),
                            self?.deleteActionSubmenu(item: item)
                        ].compactMap { $0 }
                    )
                }
            )
        },
        imagePipeline: Constant.imagePipeline
    )

    // MARK: Initialization

    /// Creates a `MainViewController` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - viewModel: The view model.
    ///   - delegate: The delegate of the instance.
    init(
        viewModel: MainViewModelProtocol,
        delegate: MainViewControllerDelegate
    ) {
        self.viewModel = viewModel
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        viewModel.viewDidLoad()
    }
}

// MARK: - Private extension

private extension MainViewController {

    // MARK: Types

    enum Constant {
        static let imagePipeline = ImagePipeline(configuration: .withDataCache)
    }

    // MARK: Methods

    func setUp() {
        setUpAppearance()
        setUpBindings()
        setUpStackViews()
    }

    func setUpAppearance() {
        navigationController?.setNavigationBarHidden(
            true,
            animated: false
        )
        navigationController?.setToolbarHidden(
            false,
            animated: false
        )
        view.backgroundColor = .systemBackground

        let settingsBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(onSettingsBarButtonItemSelection)
        )
        let spaceBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let addBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onAddBarButtonItemSelection)
        )
        toolbarItems = [
            settingsBarButtonItem,
            spaceBarButtonItem,
            addBarButtonItem
        ]
    }

    func setUpStackViews() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let pickerStackView = UIStackView()
        let pickerStackViewVerticalMargin: CGFloat = 15
        pickerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: pickerStackViewVerticalMargin,
            leading: 0,
            bottom: pickerStackViewVerticalMargin,
            trailing: 0
        )
        pickerStackView.isLayoutMarginsRelativeArrangement = true
        pickerStackView.translatesAutoresizingMaskIntoConstraints = false

        [stackView, pickerStackView].forEach {
            $0.axis = .vertical
        }

        [kindHorizontalPickerView,
         progressHorizontalPickerView].forEach {
            pickerStackView.addArrangedSubview($0)
        }

        [pickerStackView, itemGridView].forEach {
            stackView.addArrangedSubview($0)
        }

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        let pickerViewHeight: CGFloat = 41
        NSLayoutConstraint.activate([
            kindHorizontalPickerView.heightAnchor.constraint(equalToConstant: pickerViewHeight),
            progressHorizontalPickerView.heightAnchor.constraint(equalToConstant: pickerViewHeight)
        ])
    }

    func setUpBindings() {
        viewModel.itemsPublisher
            .assign(to: \.items, on: itemGridView)
            .store(in: &cancellables)
    }

    func moveToProgressActionSubmenu(item: Item) -> [UIAction] {
        Item.Progress.allCases.compactMap { progress in
            guard progress != viewModel.progress else {
                return nil
            }

            return .move(to: progress) { [weak self] in
                self?.viewModel.onMoveToProgressActionSelection(
                    item: item,
                    progress: progress
                )
            }
        }
    }

    func changeDateActionSubmenu(item: Item) -> [UIAction]? {
        guard viewModel.progress == .watched else {
            return nil
        }

        return [
            .changeDate { [weak self] in
                guard let self else {
                    return
                }

                self.delegate?.mainViewController(
                    self,
                    didSelectChangeDateActionForItem: item
                )
            }
        ]
    }

    func deleteActionSubmenu(item: Item) -> [UIAction] {
        [
            .delete { [weak self] in
                guard let self else {
                    return
                }

                self.delegate?.mainViewController(
                    self,
                    didSelectDeleteActionForItem: item
                )
            }
        ]
    }

    @objc
    func onSettingsBarButtonItemSelection() {
        delegate?.mainViewControllerDidPressSettingsButton(self)
    }

    @objc
    func onAddBarButtonItemSelection() {
        delegate?.mainViewControllerDidPressAddButton(self)
    }
}
