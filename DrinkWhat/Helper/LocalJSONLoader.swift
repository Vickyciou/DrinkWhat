//
//  LocalJSONLoader.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/17.
//

import Foundation

class LocalJSONLoader {
    func loadJSON(fileName: String) -> Data {
        // JSON 檔案的完整路徑
        guard let jsonFilePath = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("找不到 JSON 檔案")
        }
        // 讀取 JSON 檔案的內容
        guard let jsonData = FileManager.default.contents(atPath: jsonFilePath) else {
            fatalError("無法讀取 JSON 檔案")
        }
        return jsonData
    }
}
