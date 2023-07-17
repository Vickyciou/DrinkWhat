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
    func groupManager(_ manager: GroupManager, didGetVoteResults voteResults: [VoteResult])
    func groupManager(_ manager: GroupManager, didFailWith error: Error)
}
extension GroupManagerDelegate {
    func groupManager(_ manager: GroupManager, didGetAllGroupData groupData: [GroupResponse]) {}
    func groupManager(_ manager: GroupManager, didGetGroupObject groupObject: GroupResponse) {}
    func groupManager(_ manager: GroupManager, didGetVoteResults voteResults: [VoteResult]) {}
    func groupManager(_ manager: GroupManager, didFailWith error: Error) {}
}

enum GroupStatus: String {
    case active = "進行中"
    case canceled = "已取消"
    case finished = "已完成"
}

enum ManagerError: LocalizedError {
    case serverError, noData, decodingError, encodingError, conversionError, itemAlreadyExistsError, hadActiveOrderGroup, alreadyAddAnotherOrderError, noMatchData

    var errorDescription: String? {
        switch self {
        case .serverError: return "HttpResponse statusCode 500"
        case .noData: return "No data error"
        case .decodingError: return "Decoding error"
        case .encodingError: return "Encoding error"
        case .conversionError: return "Failed to change Object into dictionary"
        case .itemAlreadyExistsError: return "Item Already Exists."
        case .hadActiveOrderGroup: return "Had active order group"
        case .alreadyAddAnotherOrderError: return "Already add another order"
        case .noMatchData: return "Could not found match data"
        }
    }
}

class GroupManager {
    private let db = Firestore.firestore()
    weak var delegate: GroupManagerDelegate?
// 用computer property的方式可以在一開始雖為nil，但後面取到值後還是可以將值傳入

    private func groupCollection() -> CollectionReference {
        db.collection("Groups")
    }

    private func voteResultsCollection(groupID: String) -> CollectionReference {
        groupCollection().document(groupID).collection("voteResults")
    }

    private var groupListener: ListenerRegistration?

    private var voteResultsListener: ListenerRegistration?

// MARK: - 加飲料店進投票清單
    func addShopIntoGroup(shopID: String) async throws {
        let userObject = try await UserManager.shared.loadCurrentUser()
        let snapshot = try await groupCollection()
            .whereFilter(Filter.andFilter(
                [
                    Filter.whereField("initiatorUserID", isEqualTo: userObject.userID),
                    Filter.whereField("state", isEqualTo: GroupStatus.active.rawValue)
                ]
            ))
            .getDocuments()
        if let group = try snapshot.documents.first?.data(as: GroupResponse.self) {
            let shopRef = voteResultsCollection(groupID: group.groupID).document(shopID)
            if let _ = try? await shopRef.getDocument().data(as: VoteResult.self) {
                throw ManagerError.itemAlreadyExistsError
            } else {
                let voteResultDic = try VoteResult(shopID: shopID, userIDs: []).toDictionary()
                try await shopRef.setData(voteResultDic)
            }
        } else {
            let document = groupCollection().document()
            let groupObject = GroupResponse(
                groupID: document.documentID,
                date: Date().timeIntervalSince1970,
                state: GroupStatus.active.rawValue,
                initiatorUserID: userObject.userID,
                initiatorUserName: userObject.userName ?? "Name",
                initiatorUserImage: userObject.userImageURL ?? "",
                joinUserIDs: []
            )
            try document.setData(from: groupObject)
            let voteResultDic = try VoteResult(shopID: shopID, userIDs: []).toDictionary()
            try await voteResultsCollection(groupID: document.documentID).document(shopID).setData(voteResultDic)
        }
    }
// MARK: - 跟團者加入Group
    func addUserIntoGroup(groupID: String, userID: String) {
        groupCollection().document(groupID)
            .updateData(["joinUserIDs": FieldValue.arrayUnion([userID])])
    }

// MARK: - 投票記錄
    func addVoteResults(groupID: String, shopID: String, userID: String) {
        voteResultsCollection(groupID: groupID)
            .document(shopID)
            .updateData(["userIDs": FieldValue.arrayUnion([userID])])
    }

// MARK: - 更新投票群組狀態為完成或取消
    func setVoteStatus(groupID: String, status: String) {
        groupCollection().document(groupID).updateData(["state": status])
    }

// MARK: - 刪除投票店家
    func removeShopFromGroup(groupID: String, shopID: String) {
        voteResultsCollection(groupID: groupID).document(shopID).delete()
    }
// MARK: - Load 投票主頁
    func listenGroupChangeEvent(userID: String) {
        groupListener = groupCollection()
            .whereFilter(Filter.orFilter(
                [
                    Filter.whereField("initiatorUserID", isEqualTo: userID),
                    Filter.whereField("joinUserIDs", arrayContains: userID)
                ]
            ))
            .addSnapshotListener({ [weak self] snapshot, error in
                guard let self else { return }
                if let error = error {
                    self.delegate?.groupManager(self, didFailWith: error)
                } else if let snapshot {
                    let groupData: [GroupResponse] = snapshot.documents.compactMap {
                        try? $0.data(as: GroupResponse.self)
                    }
                    self.delegate?.groupManager(self, didGetAllGroupData: groupData)
                }
            })
    }

//    func listenGroupChangeEvent(userID: String) async throws -> [GroupResponse] {
//        return try await withCheckedThrowingContinuation { continuation in
//            groupListener = groupCollection()
//                .whereFilter(Filter.orFilter([
//                    Filter.whereField("initiatorUserID", isEqualTo: userID),
//                    Filter.whereField("joinUserIDs", arrayContains: userID)
//                ]))
//                .addSnapshotListener { snapshot, error in
//                    if let error = error {
//                        continuation.resume(throwing: error)
//                    } else if let snapshot = snapshot {
//                        let groupData: [GroupResponse] = snapshot.documents.compactMap {
//                            try? $0.data(as: GroupResponse.self)
//                        }
//                        continuation.resume(returning: groupData)
//                    }
//                }
//        }
//    }

// MARK: - 監聽投票狀況
    func getGroupObject(groupID: String) {
        groupCollection().document(groupID).addSnapshotListener { [self] (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                self.delegate?.groupManager(self, didFailWith: ManagerError.noData)
                print("Error fetching document: \(error!)")
                return
            }
            guard let groupObject = try? document.data(as: GroupResponse.self) else {
                delegate?.groupManager(self, didFailWith: ManagerError.decodingError)
                return
            }
            delegate?.groupManager(self, didGetGroupObject: groupObject)
        }
    }

    func listenVoteResults(inGroup groupID: String) {
        voteResultsListener = voteResultsCollection(groupID: groupID)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }
                if let error {
                    self.delegate?.groupManager(self, didFailWith: error)
                } else if let snapshot {
                    let results = snapshot.documents.compactMap { try? $0.data(as: VoteResult.self) }
                    self.delegate?.groupManager(self, didGetVoteResults: results)
                }
            }
    }
}
