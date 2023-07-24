//
//  DrinkDetailDataSource.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/27.
//

import Foundation

protocol DrinkDetailDataSourceProtocol {
    var sugar: [String] { get }
    var ice: [String] { get }
}

class DrinkDetailDataSource: DrinkDetailDataSourceProtocol {

    let sugar = ["正常糖", "少糖", "半糖", "微糖", "無糖"]
    let ice = ["正常冰", "少冰", "微冰", "去冰", "溫", "熱"]
}
