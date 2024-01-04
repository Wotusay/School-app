//
//  SchoolDetailsCollectionViewCell.swift
//  NYCSchools
//
//  Created by Wout Salembier on 20/12/2023.
//

import Foundation
import UIKit

class SchoolDetailsCollectionViewCell: UICollectionViewCell {
    private var schools: School?

    private struct Constants {
        static let leftInset: CGFloat = 10
        static let rightInset: CGFloat = 10
        static let topInset: CGFloat = 10
        static let bottomInset: CGFloat = 10

        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10.0
        static let wrapperViewInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        static let spacing: CGFloat = 5.0
    }

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.numberOfLines = 0
        return label
    }()

    private var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.numberOfLines = 0
        label.text = "school.details.address".localized()
        return label
    }()

    private var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()

    private var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.numberOfLines = 0
        label.text = "school.details.email".localized()
        return label
    }()

    private var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()

    private var phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.numberOfLines = 0
        label.text = "school.details.phone".localized()
        return label
    }()

    private var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()

    private var academicOpportunitiesTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.numberOfLines = 0
        label.text = "school.details.academicOpportunities".localized()
        return label
    }()

    private var academicOpportunitiesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()

    private var gradesTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.numberOfLines = 0
        label.text = "school.details.grades".localized()
        return label
    }()

    private var gradesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()

    private var websiteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.numberOfLines = 0
        label.text = "school.details.website".localized()
        return label
    }()

    private var websiteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()

    private var wrapperView: UIView = {
        let view = UIView(forAutoLayout: ())
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = Constants.borderWidth
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView(forAutoLayout: ())
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.alignment = .fill
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

    private func setupWrapperViews() {
        addSubview(wrapperView)
        wrapperView.autoPinEdgesToSuperviewEdges(with: Constants.wrapperViewInsets)
    }

    private func setupViews() {
        backgroundColor = .white
        setupWrapperViews()
        setupStackView()
    }

    private func setupStackView() {
        wrapperView.addSubview(stackView)

        stackView.autoPinEdge(toSuperviewEdge: .leading, withInset: Constants.leftInset)
        stackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.rightInset)
        stackView.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.topInset)
        stackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constants.bottomInset)

        stackView.addArrangedSubview(nameLabel)

        stackView.addArrangedSubview(addressTitleLabel)
        stackView.addArrangedSubview(addressLabel)

        stackView.addArrangedSubview(emailTitleLabel)
        stackView.addArrangedSubview(emailLabel)

        stackView.addArrangedSubview(phoneTitleLabel)
        stackView.addArrangedSubview(phoneLabel)

        stackView.addArrangedSubview(academicOpportunitiesTitleLabel)
        stackView.addArrangedSubview(academicOpportunitiesLabel)

        stackView.addArrangedSubview(gradesTitleLabel)
        stackView.addArrangedSubview(gradesLabel)

        stackView.addArrangedSubview(websiteTitleLabel)
        stackView.addArrangedSubview(websiteLabel)
    }

    func populate(_ school: School) {
        schools = school
        nameLabel.text = school.schoolName
        var fullAddress = ""
        var addressComponents: [String] = []

        if let city = school.city {
            addressComponents.append(city)
        }

        if let zip = school.zip {
            addressComponents.append(zip)
        }

        if let addressLine = school.primaryAddressLine {
            addressComponents.append(addressLine)
        }

        fullAddress = addressComponents.joined(separator: ", ")

        addressLabel.text = fullAddress
        emailLabel.text = school.schoolEmail ?? ""
        phoneLabel.text = school.phoneNumber ?? ""

        var opportunities: [String] = []
        if let academicOpportunities1 = school.academicOpportunities1 {
            opportunities.append(academicOpportunities1)
        }
        if let academicOpportunities2 = school.academicOpportunities2 {
            opportunities.append(academicOpportunities2)
        }
        academicOpportunitiesLabel.text = opportunities.joined(separator: ", ")

        gradesLabel.text = school.finalGrades ?? ""
        websiteLabel.text = school.website ?? ""
    }
}
