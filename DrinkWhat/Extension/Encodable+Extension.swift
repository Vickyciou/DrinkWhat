//
//  Encodable+Extension.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/29.
//

import Foundation

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary =
                try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "Invalid JSON data", code: -1, userInfo: nil)
        }
        return dictionary
    }
}
