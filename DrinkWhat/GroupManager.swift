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
    func GroupManager(_ manager: GroupManager, didGetAllGroupData: [GroupResponse])
    func GroupManager(_ manager: GroupManager, didGetGroupObject: GroupResponse)
    func GroupManager(_ manager: GroupManager, didFailWith error: Error)
}
extension GroupManagerDelegate {
    func GroupManager(_ manager: GroupManager, didGetAllGroupData: [GroupResponse]){}
    func GroupManager(_ manager: GroupManager, didGetGroupObject: GroupResponse){}
    func GroupManager(_ manager: GroupManager, didFailWith error: Error){}
}

class GroupManager {
//    static let shared = GroupManager()
    let db = Firestore.firestore()
    weak var delegate: GroupManagerDelegate?
    private var userData: UserObject?

    func createGroup(voteResults: [VoteResults]) {
        let groupID = db.collection("Groups").document().documentID
        guard let userData = userData else { return }
        let groupObject = GroupResponse(groupID: groupID, date: Date().timeIntervalSince1970, state: "進行中", initiatorUserID: userData.userID, initiatorUserName: userData.userName, initiatorUserImage: userData.userImageURL, joinUserIDs: [],voteResults: voteResults)
        do {
            try db.collection("Groups").document(groupID).setData(from: groupObject)
        } catch {
            print("Error created group to Firestore: \(error)")
        }
    }
// 要再確認存進去的資料格式是否與預期相同
    func addVoteResults(groupID: String, shopID: String, userID: String) {
        let voteResult = VoteResults(shopID: shopID, voteUsersIDs: [userID])
        do {
            try db.collection("Groups").document(groupID).setData(from: voteResult)
        } catch {
            delegate?.GroupManager(self, didFailWith: error)
        }

//        let userVotedObject: [String: Any] = [
//            "voteResults": [
//                "shopID" : shopID,
//                "userID" : [userID]
//            ]
//        ]
//        let userVoteObject = VoteResults(shopID: shopID, voteUsersIDs: [userID])
//        guard let userVoteDict = try? userVoteObject.toDictionary() else { return }
//        db.collection("Groups").document(groupID).setData(userVoteDict, merge: true)
    }
// MARK: - Load 投票主頁
    func getAllGroupData(groupIDs: [String]) {
        var groupData : [GroupResponse] = []
        groupIDs.forEach {
            let docRef = db.collection("Groups").document($0)
            docRef.getDocument { document, error in
                if let document = document, document.exists {
                    do {
                        let dataDescription = try document.data(as: GroupResponse.self)
                        groupData.append(dataDescription)
                        print("Document data: \(dataDescription)")
                    } catch {
                        self.delegate?.GroupManager(self, didFailWith: error)
                        print("Error get all groups data from Firestore:\(error)")

                    }
                } else {
                    print("Group\(groupIDs) document does not exist")
                }
            }
        }
        delegate?.GroupManager(self, didGetAllGroupData: groupData)
    }
// MARK: - 監聽投票狀況
    func getGroupObject(groupID: String)  {
        db.collection("Groups").document(groupID).addSnapshotListener { [self] (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                self.delegate?.GroupManager(self, didFailWith: error!)
                print("Error fetching document: \(error!)")
                return }
            guard let groupObject = try? document.data(as: GroupResponse.self) else { return }
            delegate?.GroupManager(self, didGetGroupObject: groupObject)

        }
    }
}
extension GroupManager: UserManagerDelegate {
    func userManager(_ manager: UserManager, didGet userData: UserObject) {
        self.userData = userData
    }

    func userManager(_ manager: UserManager, didFailWith error: Error) {
        print(error.localizedDescription)
    }


}

