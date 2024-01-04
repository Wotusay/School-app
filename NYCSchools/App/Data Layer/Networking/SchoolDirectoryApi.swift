//
//  SchoolDirectoryApi.swift
//  NYCSchools
//
//  Created by Wout Salembier on 15/12/2023.
//

import Alamofire
import Foundation

typealias SchoolListAPIResponse = (Swift.Result<[School]?, DataError>) -> Void
typealias SchoolSATAPIResponse = (Swift.Result<[SchoolSAT], DataError>) -> Void

protocol SchoolAPILogic {
    func getSchools(completion: @escaping (SchoolListAPIResponse))
    func getSchoolSATResults(completion: @escaping (SchoolSATAPIResponse))
}

class SchoolAPI: SchoolAPILogic {
    private struct Constants {
        public static let schoolURL = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json?$$app_token=L1KwLSwm1yz1N7aWqFCF4dLmM"
        public static let schoolSATURL = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
    }

    public func getSchools(completion: @escaping (SchoolListAPIResponse)) {
//        retrieveSchoolUsingStandardServices()
        AF.request(Constants.schoolURL)
            .validate()
            .responseDecodable(of: [School].self) { response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(.networkingError(error.localizedDescription)))
                case .success(let schools):
                    completion(.success(schools))
                }
            }
    }

    public func getSchoolSATResults(completion: @escaping (SchoolSATAPIResponse)) {
        URLCache.shared.removeAllCachedResponses()

        AF.request(Constants.schoolSATURL)
            .validate()
            .responseDecodable(of: [SchoolSAT].self) {
                response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(.networkingError(error.localizedDescription)))
                case .success(let schoolSats):
                    completion(.success(schoolSats))
                }
            }
    }

    private func retrieveSchoolUsingStandardServices() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "data.cityofnewyork.us"
        urlComponents.path = "/resource/s3k6-pzi2.json"
        urlComponents.queryItems = [URLQueryItem(name: "$$app_token", value: "L1KwLSwm1yz1N7aWqFCF4dLmM")]

        // Also possible:
        /// ULR(string: schoolURL)

        if let url = urlComponents.url {
            let urlSession = URLSession(configuration: .default)

            let task = urlSession.dataTask(with: url) { data, _, error in
                guard error == nil else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    return
                }
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let schools = try decoder.decode([School].self, from: data)
                    } catch let error {
                        print("Error during parsing: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
}
