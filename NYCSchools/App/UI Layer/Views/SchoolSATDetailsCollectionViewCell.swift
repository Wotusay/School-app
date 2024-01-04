//
//  SchoolSATDetailsCollectionViewCell.swift
//  NYCSchools
//
//  Created by Wout Salembier on 03/01/2024.
//

import Foundation
import UIKit

class SchoolSATDetailsCollectionViewCell: UICollectionViewCell {
    private var schoolSAT: SchoolSAT?

    private struct Constants {
        static let leftInset: CGFloat = 20
        static let rightInset: CGFloat = 20
        static let topInset: CGFloat = 10
        static let bottomInset: CGFloat = 10
        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10.0
        static let wrapperViewInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        static let spacing: CGFloat = 3.0
    }

    private var numberOfSATTestTakersTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()

    private var numberOfSATTestTakersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()

    private var mathScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()

    private var mathScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()

    private var readingScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()

    private var readingScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()

    private var writingScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()

    private var writingScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()

    private var wrapperView: UIView = {
        let stackView = UIView(forAutoLayout: ())
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = Constants.borderWidth
        stackView.layer.cornerRadius = Constants.cornerRadius
        return stackView
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

    private func setupWrapperView() {
        addSubview(wrapperView)
        wrapperView.autoPinEdgesToSuperviewEdges(with: Constants.wrapperViewInsets)
    }

    private func setupViews() {
        backgroundColor = .white
        setupWrapperView()
        setupStackView()
    }

    private func setupStackView() {
        wrapperView.addSubview(stackView)

        stackView.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.topInset)
        stackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constants.bottomInset)
        stackView.autoPinEdge(toSuperviewEdge: .leading, withInset: Constants.leftInset)
        stackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.rightInset)

        stackView.addArrangedSubview(numberOfSATTestTakersTitleLabel)
        stackView.addArrangedSubview(numberOfSATTestTakersLabel)

        stackView.addArrangedSubview(mathScoreTitleLabel)
        stackView.addArrangedSubview(mathScoreLabel)

        stackView.addArrangedSubview(readingScoreTitleLabel)
        stackView.addArrangedSubview(readingScoreLabel)

        stackView.addArrangedSubview(writingScoreTitleLabel)
        stackView.addArrangedSubview(writingScoreLabel)
        
        numberOfSATTestTakersTitleLabel.text = "school.sat.number.of.test.takers.title".localized()
        mathScoreTitleLabel.text = "school.sat.math.score.title".localized()
        readingScoreTitleLabel.text = "school.sat.reading.score.title".localized()
        writingScoreTitleLabel.text = "school.sat.writing.score.title".localized()
    }

    func populate(schoolSAT: SchoolSAT) {
        numberOfSATTestTakersLabel.text = schoolSAT.numberOfTestTakers ?? ""
        mathScoreLabel.text = schoolSAT.mathAvgScore ?? ""
        readingScoreLabel.text = schoolSAT.criticalReadingAvgScore ?? ""
        writingScoreLabel.text = schoolSAT.writingAvgScore ?? ""
    }
}
