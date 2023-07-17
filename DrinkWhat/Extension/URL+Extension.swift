//
//  URL+Extension.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/25.
//

import Foundation

extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return nil
        }

        var parameters = [String : String]()
        for queryItem in queryItems {
            parameters[queryItem.name] = queryItem.value
        }

        return parameters
    }
}
