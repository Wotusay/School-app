//
//  SchoolsViewModel.swift
//  NYCSchools
//
//  Created by Wout Salembier on 18/12/2023.
//

import Combine
import Foundation

class SchoolsViewModel {
    @Published private(set) var schools: [School]? = []
    @Published private(set) var error: DataError?
    @Published private(set) var schoolSats: [SchoolSAT]?

    private(set) var schoolSectionsList: [SchoolSection]?
    private(set) var schoolSATDictionary: [String: SchoolSAT] = [:]

    private let apiService: SchoolAPILogic

    init(apiService: SchoolAPILogic = SchoolAPI()) {
        self.apiService = apiService
    }

    func getSchools() {
        apiService.getSchools { [weak self] result in
            switch result {
            case let .success(schools):
                self?.schools = schools ?? []
                if schools?.isEmpty == false {
                    self?.prepareSchoolSections()
                }

            case let .failure(error):
                self?.error = error
            }
        }
    }

    func getSchoolSATs() {
        schoolSats?.removeAll()
        apiService.getSchoolSATResults { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(schoolSATResults):
                self.schoolSats = schoolSATResults

                for sat in schoolSATResults {
                    self.schoolSATDictionary[sat.dbn] = sat
                }
            case let .failure(error):
                self.error = error
            }
        }
    }

    private func prepareSchoolSections() {
        var listOfSections = [SchoolSection]()
        var schoolDictionary = [String: SchoolSection]()

        if let schools = schools {
            for school in schools {
                if let city = school.city {
                    if schoolDictionary[city] != nil {
                        schoolDictionary[city]?.schools.append(school)
                    } else {
                        var newSection = SchoolSection(city: city, schools: [])
                        newSection.schools.append(school)
                        schoolDictionary[city] = newSection
                    }
                }
            }
        }

        listOfSections = Array(schoolDictionary.values)
        listOfSections.sort {
            return $0.city < $1.city
        }
        schoolSectionsList = listOfSections
    }
}
