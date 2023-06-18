//
//  Date+Extension.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/17.
//

import Foundation

extension Date {
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM月dd日．"
        return dateFormatter.string(from: self)
    }
}
