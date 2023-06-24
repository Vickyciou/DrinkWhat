//
//  FirestoreManager.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol GroupManagerDelegate: AnyObject {
    func groupManager(_ manager: GroupManager, didGetAllGroupData groupData: [GroupResponse])
    func groupManager(_ manager: GroupManager, didGetGroupObject groupObject: GroupResponse)
    func groupManager(_ manager: GroupManager, didFailWith error: Error)
    func groupManager(_ manager: GroupManager, didPostGroupID groupID: String)
}
extension GroupManagerDelegate {
    func groupManager(_ manager: GroupManager, didGetAllGroupData groupData: [GroupResponse]) {}
    func groupManager(_ manager: GroupManager, didGetGroupObject groupObject: GroupResponse) {}
    func groupManager(_ manager: GroupManager, didFailWith error: Error) {}
    func groupManager(_ manager: GroupManager, didPostGroupID  groupID: String) {}
}

enum ManagerError: LocalizedError {
    case serverError, noData, decodingError, conversionError

    var errorDescription: String? {
        switch self {
        case .serverError: return "HttpResponse statusCode 500"
        case .noData: return "No data error"
        case .decodingError: return "Decoding error"
        case.conversionError: return "Failed to change Object into dictionary"
        }
    }
}

class GroupManager {
    let db = Firestore.firestore()
    weak var delegate: GroupManagerDelegate?
// 用computer property的方式可以在一開始雖為nil，但後面取到值後還是可以將值傳入
    private var userObject: UserObject? {
        UserManager.shared.userObject
    }

    func createGroup(voteResults: [VoteResults]) {
        let groupID = db.collection("Groups").document().documentID
        guard let userObject = userObject else {
            delegate?.groupManager(self, didFailWith: ManagerError.noData)
            return
        }
        let groupObject = GroupResponse(groupID: groupID,
                                        date: Date().timeIntervalSince1970,
                                        state: "進行中",
                                        initiatorUserID: userObject.userID,
                                        initiatorUserName: userObject.userName,
                                        initiatorUserImage: userObject.userImageURL,
                                        joinUserIDs: [],
                                        voteResults: voteResults)
        do {
            try db.collection("Groups").document(groupID).setData(from: groupObject)
            delegate?.groupManager(self, didPostGroupID: groupID)
        } catch {
            print("Error created group to Firestore: \(error)")
        }
    }

// MARK: - 加飲料店進投票清單
    func addShopIntoGroup(groupID: String, shopID: String) {
        let voteResult = VoteResults(shopID: shopID, voteUserIDs: [])
        guard let userVoteDict = try? voteResult.toDictionary() else {
            delegate?.groupManager(self, didFailWith: ManagerError.conversionError)
            return
        }
        db.collection("Groups").document(groupID).updateData(["voteResults": FieldValue.arrayUnion([userVoteDict])])
    }
// MARK: - 投票記錄
    func addVoteResults(groupID: String, shopID: String, userID: String) {
        let voteResult = VoteResults(shopID: shopID, voteUserIDs: [userID])
        guard let userVoteDict = try? voteResult.toDictionary() else {
            delegate?.groupManager(self, didFailWith: ManagerError.conversionError)
            return
        }
        db.collection("Groups").document(groupID).updateData(["voteResults": FieldValue.arrayUnion([userVoteDict])])
    }

// MARK: - 結束投票
    func setVoteStateToFinish(groupID: String) {

    }
// MARK: - Load 投票主頁
    func getAllGroupData(userID: String) {
        var groupData: [GroupResponse] = []
        db.collection("Groups")
            .whereFilter(Filter.orFilter(
                [
                    Filter.whereField("initiatorUserID", isEqualTo: userID),
                    Filter.whereField("joinUserIDs", arrayContains: userID)
                ]
            ))
            .getDocuments() { (document, error) in
                if let error = error {
                    print("Error get all groups data from Firestore:\(error)")
                } else {
                    for document in document!.documents {
                        do {
                            let dataDescription = try document.data(as: GroupResponse.self)
                            groupData.append(dataDescription)
                            print("\(document.documentID) => \(document.data())")
                        } catch {
                            print("Error decode all groups data from Firestore:\(error)")
                        }
                    }
                    self.delegate?.groupManager(self, didGetAllGroupData: groupData)
                }
            }
    }
// 確認是否有自己發起並進行中的投票Group
    func checkGroupExists(userID: String) {
        db.collection("Groups")
            .whereFilter(Filter.orFilter(
                [
                    Filter.whereField("initiatorUserID", isEqualTo: userID),
                    Filter.whereField("state", isEqualTo: "進行中"),
                ]
            ))
            .getDocuments() { (document, error) in
                if let error = error {
                    print("Error get all groups data from Firestore:\(error)")
                } else {
                    for document in document!.documents {
                        do {
                            let dataDescription = try document.data(as: GroupResponse.self)
                            self.delegate?.groupManager(self, didGetGroupObject: dataDescription)
                            print("\(document.documentID) => \(document.data())")
                        } catch {
                            print("Error decode all groups data from Firestore:\(error)")
                        }
                    }
                }
            }
    }
// MARK: - 監聽投票狀況
    func getGroupObject(groupID: String) {
        db.collection("Groups").document(groupID).addSnapshotListener { [self] (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                self.delegate?.groupManager(self, didFailWith: ManagerError.noData)
                print("Error fetching document: \(error!)")
                return }
            guard var groupObject = try? document.data(as: GroupResponse.self) else {
                delegate?.groupManager(self, didFailWith: ManagerError.decodingError)
                return
            }
            groupObject.voteResults.sort(by: { $0.voteUserIDs.count > $1.voteUserIDs.count })
            delegate?.groupManager(self, didGetGroupObject: groupObject)

        }
    }
}
