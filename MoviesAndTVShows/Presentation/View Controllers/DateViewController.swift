//
//  DateViewController.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 19/3/23.
//

import Combine
import UIKit

final class DateViewController: UIViewController {

    // MARK: Properties

    private let viewModel: DateViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Initialization

    /// Creates a `DateViewController` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - viewModel: The view model.
    init(viewModel: DateViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate

extension DateViewController: UICalendarSelectionSingleDateDelegate {

    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
        viewModel.didSelectDate(dateComponents)
    }
}

// MARK: - Private extension

private extension DateViewController {

    // MARK: Methods

    func setUp() {
        setUpAppearance()
        setUpBindings()
        setUpCalendarView()
    }

    func setUpAppearance() {
        isModalInPresentation = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "OK",
            style: .done,
            target: self,
            action: #selector(onOKBarButtonItemSelection)
        )
        view.backgroundColor = .systemBackground
    }

    func setUpBindings() {
        viewModel.okBarButtonItemIsEnabledPublisher
            .sink { [weak self] okBarButtonItemIsEnabled in
                self?.navigationItem.rightBarButtonItem?.isEnabled = okBarButtonItemIsEnabled
            }
            .store(in: &cancellables)
    }

    func setUpCalendarView() {
        let singleDateSelection = UICalendarSelectionSingleDate(delegate: self)
        singleDateSelection.selectedDate = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: viewModel.date
        )

        let calendarView = UICalendarView()
        calendarView.selectionBehavior = singleDateSelection
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    @objc
    func onOKBarButtonItemSelection() {
        viewModel.onOKBarButtonItemSelection()
    }
}
