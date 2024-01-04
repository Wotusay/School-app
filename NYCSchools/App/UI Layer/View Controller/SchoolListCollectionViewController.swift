//
//  ViewController.swift
//  NYCSchools
//
//  Created by Wout Salembier on 14/12/2023.
//

import Combine
import MBProgressHUD
import PureLayout
import UIKit

class SchoolListCollectionViewController: UIViewController {
    private let schoolsViewModel: SchoolsViewModel = SchoolsViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var collectionView: UICollectionView?
    private var loadingHUD: MBProgressHUD?
    private var refreshControl = UIRefreshControl()

    private struct Constants {
        static let cellIdentifier: String = "schoolCell"
        static let cellHeight: CGFloat = 100
        static let sectionHeight: CGFloat = 50
        static let sectionIdentifier: String = "sectionHeader"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setUpBinders()


        setUpRefreshControl()
        setupLoadingHUD()
        retrieveSchoolsData()

        title = "schools.title".localized()
    }

    private func setUpRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "refresh.control.title".localized())
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
        retrieveSchoolsData()
        refreshControl.endRefreshing()
    }

    private func retrieveSchoolsData() {
        removeStateView()
        loadingHUD?.show(animated: true)
        schoolsViewModel.getSchools()
        schoolsViewModel.getSchoolSATs()
    }

    private func setupLoadingHUD() {
        guard let collectionView = collectionView else {
            return
        }
        loadingHUD = MBProgressHUD.showAdded(to: collectionView, animated: true)
        loadingHUD?.label.text = "loading.hud.title".localized()
        loadingHUD?.isUserInteractionEnabled = false
        loadingHUD?.detailsLabel.text = "loading.hud.subtitle".localized()
    }

    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()

        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width, height: Constants.cellHeight)
        collectionViewLayout.headerReferenceSize = CGSize(width: view.frame.size.width, height: Constants.sectionHeight)
        collectionViewLayout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewLayout)

        guard let collectionView = collectionView else {
            return
        }

        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true

        // setup & costumize flow layout
        collectionView.register(SchoolCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView.register(SchoolSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.sectionIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setUpBinders() {
        schoolsViewModel.$schools
            .receive(on: RunLoop.main)
            .sink { [weak self] schools in
                guard let schools = schools else {
                    return
                }

                if !schools.isEmpty {
                    self?.loadingHUD?.hide(animated: true)
                    self?.collectionView?.reloadData()
                    self?.removeStateView()
                } else {
                    self?.showEmptyState()
                }
            }
            .store(in: &cancellables)

        schoolsViewModel.$error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self else {
                    return
                }

                if let error = error {
                    self.loadingHUD?.hide(animated: true)
                    switch error {
                    case let .networkingError(errorMsg):
                        self.showErrorState(errorMsg)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

extension SchoolListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schoolsViewModel.schoolSectionsList?[section].schools.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? SchoolCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let schoolSection = schoolsViewModel.schoolSectionsList?[indexPath.section] {
            let school = schoolSection.schools[indexPath.item]
            cell.populate(school)
        }
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return schoolsViewModel.schoolSectionsList?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
           let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.sectionIdentifier, for: indexPath) as? SchoolSectionHeaderView {
            sectionHeader.headerLabel.text = schoolsViewModel.schoolSectionsList?[indexPath.section].city
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}

extension SchoolListCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let school = schoolsViewModel.schoolSectionsList?[indexPath.section].schools[indexPath.item],
           let schoolSAT = schoolsViewModel.schoolSATDictionary[school.dbn] {
            print("school selected: \(school.schoolName)")
            let schoolDetailsViewController = SchoolsDetailsViewController()
            schoolDetailsViewController.viewModel = SchoolDetailsViewModel(school: school, schoolSAT: schoolSAT)
            navigationController?.pushViewController(schoolDetailsViewController, animated: true)
        }
    }
}

extension SchoolListCollectionViewController {
    func showErrorState(_ errorMessage: String) {
        let errorStateView = SchoolListStateView(forAutoLayout: ())
        errorStateView.update(for: .error)
        collectionView?.backgroundView = errorStateView
    }

    func removeStateView() {
        collectionView?.backgroundView = nil
    }

    func showEmptyState() {
        let emptyStateView = SchoolListStateView(forAutoLayout: ())
        emptyStateView.update(for: .empty)
        collectionView?.backgroundView = emptyStateView
    }
}
