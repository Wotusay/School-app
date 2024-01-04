//
//  MockSchoolAPI.swift
//  NYCSchoolsTests
//
//  Created by Wout Salembier on 18/12/2023.
//

import Foundation
@testable import NYCSchools
class MockSchoolAPI: SchoolAPI {
    var loadState: SchoolListLoadState = .empty

    override func getSchools(completion: @escaping (NYCSchools.SchoolListAPIResponse)) {
        switch loadState {
        case .error:
            completion(.failure(.networkingError("Could not retrieve schools")))
        case .loaded:
            let mock = School(
                        dbn: "123456", 
                        schoolName: "Mock High School", 
                        overviewParagraph: "This is a mock high school for testing purposes.", 
                        schoolEmail: "mock@highschool.com", 
                        academicOpportunities1: "Mock academic opportunity 1", 
                        academicOpportunities2: "Mock academic opportunity 2", 
                        neighborhood: "Mock Neighborhood", 
                        phoneNumber: "123-456-7890", 
                        website: "www.mockhighschool.com", 
                        finalGrades: "9-12", 
                        totalStudents: "1000", 
                        schoolSports: "Mock Sports", 
                        primaryAddressLine: "123 Mock Street", 
                        city: "Mock City", 
                        zip: "12345", 
                        latitude: "40.7128", 
                        longitude: "74.0060"
                    )
            completion(.success([mock]))
        case .empty:
            completion(.success([]))
        }
    }
}
