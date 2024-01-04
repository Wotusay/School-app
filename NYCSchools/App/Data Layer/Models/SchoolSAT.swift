//
//  SchoolSAT.swift
//  NYCSchools
//
//  Created by Wout Salembier on 03/01/2024.
//

import Foundation

struct SchoolSAT: Codable {
    let dbn: String
    let schoolName: String?
    let numberOfTestTakers: String?
    let criticalReadingAvgScore: String?
    let mathAvgScore: String?
    let writingAvgScore: String?

    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case numberOfTestTakers = "num_of_sat_test_takers"
        case criticalReadingAvgScore = "sat_critical_reading_avg_score"
        case mathAvgScore = "sat_math_avg_score"
        case writingAvgScore = "sat_writing_avg_score"
    }
}