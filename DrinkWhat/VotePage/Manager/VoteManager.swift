//
//  VoteManager.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/17.
//

import Foundation

class VoteManager {
    func getDataFromVoteList(completionHandler: (Result<[VoteList], Error>) -> Void) {
        do {
            let data = LocalJSONLoader().loadJSON(fileName: "VoteList")
            let result = try JSONDecoder().decode(VoteListResponse.self, from: data).data
            completionHandler(.success(result))
        } catch {
            completionHandler(.failure(error))
        }
    }
    func getDataFromVoteObject(roomID: String, completionHandler: (Result<VoteObject, Error>) -> Void) {
        do {
            let data = LocalJSONLoader().loadJSON(fileName: "VoteObject"+roomID)
            let result = try JSONDecoder().decode(VoteObjectResponse.self, from: data).data
            completionHandler(.success(result))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
