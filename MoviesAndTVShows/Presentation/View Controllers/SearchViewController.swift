//
//  SearchViewController.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 20/3/23.
//

import Combine
import UIKit

protocol SearchViewControllerDelegate: AnyObject {

    // MARK: Methods

    /// Tells the delegate that the specified search result was selected.
    ///
    /// - Parameters:
    ///   - searchViewController: The `SearchViewController` instance informing the delegate of this event.
    ///   - searchResult: The selected search result.
    func searchViewController(
        _ searchViewController: SearchViewController,
        didSelectSearchResult searchResult: SearchResult
    )
}

final class SearchViewController: UIViewController {

    // MARK: Properties

    private let viewModel: SearchViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    private weak var delegate: SearchViewControllerDelegate?

    private lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self

        return searchBar
    }()

    private lazy var itemGridView = ItemGridView(
        itemSelectionHandler: { [weak self] searchResult in
            guard let self else {
                return
            }

            self.delegate?.searchViewController(
                self,
                didSelectSearchResult: searchResult
            )
        }
    )

    // MARK: Initialization

    /// Creates a `SearchViewController` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - viewModel: The view model.
    ///   - delegate: The delegate of the instance.
    init(
        viewModel: SearchViewModelProtocol,
        delegate: SearchViewControllerDelegate
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

        searchBar.becomeFirstResponder()
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchButtonClicked(searchBarText: searchBar.text)
    }
}

// MARK: - Private extension

private extension SearchViewController {

    // MARK: Methods

    func setUp() {
        setUpAppearance()
        setUpBindings()
        setUpStackView()
    }

    func setUpAppearance() {
        title = "Search"
        view.backgroundColor = .systemBackground
    }

    func setUpBindings() {
        viewModel.networkErrorHappenedPublisher
            .sink { [weak self] _ in
                self?.presentAlertForNetworkError()
            }
            .store(in: &cancellables)

        viewModel.searchResultsPublisher
            .assign(to: \.items, on: itemGridView)
            .store(in: &cancellables)
    }

    func setUpStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [searchBar, itemGridView].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
