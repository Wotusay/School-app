//
//  NYCSchoolsTests.swift
//  NYCSchoolsTests
//
//  Created by Wout Salembier on 14/12/2023.
//

import Combine
@testable import NYCSchools
import XCTest

final class NYCSchoolsTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    override func setUp() async throws {
        try await super.setUp()
        cancellables.removeAll()
    }

    func testGettingSchoolsWithMockEmptyResult() {
        let expectation = expectation(description: "Get schools with mock empty result")
        let mockAPI = MockSchoolAPI()
        mockAPI.loadState = .empty

        let viewModel = SchoolsViewModel(apiService: mockAPI)
        viewModel.getSchools()

        viewModel.$schools.receive(on: RunLoop.main).sink { schools in
            XCTAssertTrue(schools?.isEmpty == true, "Expected Schools to be empty, but retrieved values")
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Failed")
            }
        }
    }

    func testGettingSchoolsWithErrorResult() {
        let expectation = expectation(description: "Get schools with error result")
        let mockAPI = MockSchoolAPI()
        mockAPI.loadState = .error

        let viewModel = SchoolsViewModel(apiService: mockAPI)
        viewModel.getSchools()

        viewModel.$error.receive(on: RunLoop.main).sink { error in
            XCTAssertNotNil(error, "Expected error to be not nil, but retrieved nil")
            expectation.fulfill()
        }.store(in: &cancellables)

        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Failed")
            }
        }
    }

    func testGettingSchoolsWithResults() {
        let expectation = expectation(description: "Get schools with results")
        let mockAPI = MockSchoolAPI()

        mockAPI.loadState = .loaded
        let viewModel = SchoolsViewModel(apiService: mockAPI)

        viewModel.getSchools()

        viewModel.$schools.receive(on: RunLoop.main).sink { schools in
            guard let schools = schools else {
                XCTFail("Expected Schools to be not nil, but retrieved nil")
                return
            }
            XCTAssertTrue(schools.isEmpty == false, "Expected Schools to be not empty, but retrieved empty")
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Failed")
            }
        }
    }
}
