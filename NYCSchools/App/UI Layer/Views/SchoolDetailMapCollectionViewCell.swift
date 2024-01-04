//
//  SchoolDetailMapCollectionViewCell.swift
//  NYCSchools
//
//  Created by Wout Salembier on 03/01/2024.
//

import Foundation
import MapKit
import UIKit

class SchoolDetailMapCollectionViewCell: UICollectionViewCell {
    private var school: School?
    private var currentUserLocationAnnotation: SchoolMapAnnotation? = nil

    private struct Constants {
        static let leftInset: CGFloat = 10
        static let rightInset: CGFloat = 10
        static let topInset: CGFloat = 10
        static let bottomInset: CGFloat = 10
        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10.0
        static let wrapperViewInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

    private var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()

    private var wrapperView: UIView = {
        let stackView = UIView(forAutoLayout: ())
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = Constants.borderWidth
        stackView.layer.cornerRadius = Constants.cornerRadius
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupWrapperView() {
        addSubview(wrapperView)
        wrapperView.autoPinEdgesToSuperviewEdges(with: Constants.wrapperViewInsets)
    }

    private func setupViews() {
        backgroundColor = .white
        setupWrapperView()

        wrapperView.addSubview(mapView)
        mapView.autoPinEdgesToSuperviewEdges()
        mapView.delegate = self
        wrapperView.clipsToBounds = true

        NotificationCenter.default.addObserver(self, selector: #selector(listenToUserLocation), name: NSNotification.Name(SchoolsDetailsViewController.Constants.locationUpdateNoti), object: nil)
    }

    @objc func listenToUserLocation(_ notifaction: Notification) {
        print(notifaction.userInfo)

        guard let userCordinateLocation = notifaction.userInfo?["userLocation"] as? CLLocation else {
            return
        }
        if currentUserLocationAnnotation == nil {
            currentUserLocationAnnotation = SchoolMapAnnotation(title: "You", coordinate: userCordinateLocation.coordinate, subtitle: "Current Location")
            if let annotation = currentUserLocationAnnotation {
                mapView.addAnnotation(annotation)
            } else {
                currentUserLocationAnnotation?.coordinate = userCordinateLocation.coordinate
            }
        }
    }

    func populate(school: School) {
        self.school = school

        updateMap()
    }

    private func updateMap() {
        if let longitude = school?.longitude,
           let longitudeDouble = Double(longitude),
           let latitude = school?.latitude,
           let latitudeDouble = Double(latitude) {
            let coordinates = CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble)
            let annotation = SchoolMapAnnotation(title: school?.schoolName ?? "", coordinate: coordinates, subtitle: school?.primaryAddressLine ?? "")
            mapView.addAnnotation(annotation)

            print(coordinates)

            if let regionMeters = CLLocationDistance(exactly: 600) {
                let region = MKCoordinateRegion(center: coordinates,
                                                latitudinalMeters: regionMeters,
                                                longitudinalMeters: regionMeters)
                mapView.setRegion(mapView.regionThatFits(region), animated: true)
            }
        }
    }
}

extension SchoolDetailMapCollectionViewCell: MKMapViewDelegate {
}
