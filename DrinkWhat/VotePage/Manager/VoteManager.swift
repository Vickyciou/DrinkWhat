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
    func getDataFromVoteObject(roomID: String, completionHandler: @escaping (Result<VoteObject, Error>) -> Void) {
        var count = 0
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            count += 1
            print("count is \(count)")
            switch count {
            case 0..<5:
                do {
                    let data = LocalJSONLoader().loadJSON(fileName: "VoteObject"+roomID)
                    let result = try JSONDecoder().decode(VoteObjectResponse.self, from: data).data
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            case 5..<10:
                do {
                    let data = LocalJSONLoader().loadJSON(fileName: "VoteObjectIsVoted")
                    let result = try JSONDecoder().decode(VoteObjectResponse.self, from: data).data
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            case 10:
                do {
                    let data = LocalJSONLoader().loadJSON(fileName: "VoteObjectIsFinished")
                    let result = try JSONDecoder().decode(VoteObjectResponse.self, from: data).data
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            default:
                timer.invalidate()
            }
        }
    }
}
