//
//  SchoolsDetailsViewController.swift
//  NYCSchools
//
//  Created by Wout Salembier on 20/12/2023.
//

import CoreLocation
import Foundation
import PureLayout
import UIKit

class SchoolsDetailsViewController: UIViewController {
    private var sectionList: [String] = ["school.details.section".localized(), "school.details.sat.title".localized(), "school.details.map.title".localized()]
    private var collectionView: UICollectionView?
    private let locationManger = CLLocationManager()

    var viewModel: SchoolDetailsViewModel?

    struct Constants {
        static let schoolDetailsCellId: String = "schoolDetailsCell"
        static let schoolSATCellId: String = "schoolDetailsSATCell"
        static let schoolMapCellId: String = "schoolMapCell"
        static let detailsCellHeight: CGFloat = 360
        static let sectionIdentifier: String = "sectionHeader"
        static let sectionHeight: CGFloat = 50
        static let satCellHeight: CGFloat = 180
        static let mapCellHeight: CGFloat = 150
        static let locationUpdateNoti = "UserLocationAvailable"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel?.school.schoolName ?? ""
        view.backgroundColor = .white
        setupCollectionView()
        setupLocationManger()
    }

    private func setupLocationManger() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }

    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()

        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width, height: Constants.detailsCellHeight)
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

        collectionView.register(SchoolDetailsCollectionViewCell.self, forCellWithReuseIdentifier: Constants.schoolDetailsCellId)
        collectionView.register(SchoolSATDetailsCollectionViewCell.self, forCellWithReuseIdentifier: Constants.schoolSATCellId)
        collectionView.register(SchoolDetailMapCollectionViewCell.self, forCellWithReuseIdentifier: Constants.schoolMapCellId)
        collectionView.register(SchoolSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.sectionIdentifier)

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SchoolsDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in colectionView: UICollectionView) -> Int {
        return sectionList.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.schoolDetailsCellId, for: indexPath)
            guard let schoolDetailsCell = cell as? SchoolDetailsCollectionViewCell,
                  let school = viewModel?.school else {
                return cell
            }
            schoolDetailsCell.populate(school)
            return schoolDetailsCell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.schoolSATCellId, for: indexPath)
            guard let schoolSATCell = cell as? SchoolSATDetailsCollectionViewCell,
                  let schoolSAT = viewModel?.schoolSAT else {
                return cell
            }
            schoolSATCell.populate(schoolSAT: schoolSAT)
            return schoolSATCell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.schoolMapCellId, for: indexPath)
            guard let schoolMapCell = cell as? SchoolDetailMapCollectionViewCell,
                  let school = viewModel?.school else {
                return cell
            }
            schoolMapCell.populate(school: school)
            return schoolMapCell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
           let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.sectionIdentifier, for: indexPath) as? SchoolSectionHeaderView {
            sectionHeader.headerLabel.text = sectionList[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}

extension SchoolsDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: Constants.detailsCellHeight)
        case 1:
            return CGSize(width: collectionView.bounds.width, height: Constants.satCellHeight)
        default:
            return CGSize(width: collectionView.bounds.width, height: Constants.mapCellHeight)
        }
    }
}

extension SchoolsDetailsViewController: UICollectionViewDelegate {
}

extension SchoolsDetailsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        NotificationCenter.default.post(name: NSNotification.Name(Constants.locationUpdateNoti), object: nil, userInfo: ["userLocation": location])
    }
}
