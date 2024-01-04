//
//  SchoolDetailsViewModel.swift
//  NYCSchools
//
//  Created by Wout Salembier on 20/12/2023.
//

import Foundation

class SchoolDetailsViewModel {
    private(set) var school: School
    private(set) var schoolSAT: SchoolSAT

    init(school: School, schoolSAT: SchoolSAT) {
        self.school = school
        self.schoolSAT = schoolSAT
    }
}
