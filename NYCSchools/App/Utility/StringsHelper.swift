//
//  StringsHelper.swift
//  NYCSchools
//
//  Created by Wout Salembier on 19/12/2023.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(params: CVarArg...) -> String {
        return String(format: localized(), arguments: params)
    }
}
