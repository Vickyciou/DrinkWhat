//
//  ShopMenuViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/22.
//

import UIKit

class ShopMenuViewController: UIViewController {
    private lazy var tableHeaderView: UIImageView = makeTableHeaderView()
    private lazy var tableView: UITableView = makeTableView()
    private let groupManager = GroupManager()
    private let orderManager = OrderManager()
    private let userManager = UserManager.shared
    private var shopObject: ShopObject
    private var groupObject: GroupResponse?
    private var orderResponse: OrderResponse?

    init(shopObject: ShopObject, orderResponse: OrderResponse? = nil) {
        self.shopObject = shopObject
        self.orderResponse = orderResponse
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        groupManager.delegate = self
    }

    private func setupVC() {
        view.backgroundColor = .white
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.tableHeaderView = tableHeaderView
    }
}

extension ShopMenuViewController {
    private func makeTableHeaderView() -> UIImageView {
        let tableHeaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        tableHeaderView.contentMode = .scaleAspectFill
        tableHeaderView.layer.masksToBounds = true
        tableHeaderView.loadImage(shopObject.mainImageURL, placeHolder: UIImage(systemName: "bag"))
        return tableHeaderView
    }

    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ShopMenuCell.self, forCellReuseIdentifier: "ShopMenuCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionHeaderTopPadding = 0.0
        return tableView
    }
}

extension ShopMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return shopObject.menu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShopMenuCell", for: indexPath) as? ShopMenuCell
        else { fatalError("Cannot created ShopMenuCell") }
        let drink = shopObject.menu[indexPath.row]
        cell.setupCell(drinkName: drink.drinkName, drinkPrice: drink.drinkPrice[0].price)
        return cell
    }
}

extension ShopMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drink = shopObject.menu[indexPath.row]
        let drinkDetailVC = DrinkDetailViewController(shopObject: shopObject, drink: drink)
        show(drinkDetailVC, sender: nil)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let firstSectionHeaderView = SectionHeaderView(frame: .zero)
        firstSectionHeaderView.setupView(shopName: shopObject.name)
        firstSectionHeaderView.delegate = self
        return section == 0 ? firstSectionHeaderView : nil
    }
}

extension ShopMenuViewController: SectionHeaderViewDelegate {
    func didPressAddOrderButton(_ view: SectionHeaderView) {
        Task {
            do {
                let userObject = try await userManager.loadCurrentUser()
                let orderID = try await orderManager.createOrder(
                    shopObject: shopObject,
                    initiatorUserID: userObject.userID,
                    initiatorUserName: userObject.userName ?? "Name").orderID

                let alert = UIAlertController(
                    title: "開啟團購囉",
                    message: "要立刻分享給朋友嗎？",
                    preferredStyle: .alert
                )
                DispatchQueue.main.async {
                    let shareAction = UIAlertAction(title: "分享", style: .default) { _ in
                        let orderID = orderID
                        let shareURL = URL(string: "drinkWhat://share?orderID=\(orderID)")!
                        let aVC = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
                        self.present(aVC, animated: true)
                    }
                    let cancelAction = UIAlertAction(title: "先不要", style: .cancel)
                    alert.addAction(shareAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                }
            } catch UserManagerError.noCurrentUser {
                let alert = UIAlertController(
                    title: "加入失敗",
                    message: "請先登入會員",
                    preferredStyle: .alert
                )
                let loginAction = UIAlertAction(title: "前往登入", style: .default) { _ in
                    let loginVC = LoginSheetViewController()
                    loginVC.delegate = self
                    loginVC.modalPresentationStyle = .pageSheet
                    if let sheet = loginVC.sheetPresentationController {
                        sheet.detents = [.medium()]
                    }
                    self.present(loginVC, animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "稍後再說", style: .cancel)
                alert.addAction(loginAction)
                alert.addAction(cancelAction)
                present(alert, animated: true)
            } catch ManagerError.itemAlreadyExistsError {
                let alert = UIAlertController(
                    title: "加入失敗",
                    message: "目前已有進行中的團購囉！",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            } catch {
                print("error \(error)")
            }
        }
    }

    func didPressAddVoteButton(_ view: SectionHeaderView) {
        let authUser = try? userManager.checkCurrentUser()
        if authUser == nil {
            let alert = UIAlertController(
                title: "加入失敗",
                message: "請先登入會員",
                preferredStyle: .alert
            )
            let loginAction = UIAlertAction(title: "前往登入", style: .default) { _ in
                let loginVC = LoginSheetViewController()
                loginVC.delegate = self
                loginVC.modalPresentationStyle = .pageSheet
                if let sheet = loginVC.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                self.present(loginVC, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "稍後再說", style: .cancel)
            alert.addAction(loginAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
            return
        } else {
            Task {
                do {
                    try await groupManager.addShopIntoGroup(shopID: shopObject.id)
                    makeAlertToast(message: "加入成功！", title: nil, duration: 2)
                } catch ManagerError.itemAlreadyExistsError {
                    let alert = UIAlertController(
                        title: "加入失敗",
                        message: "此商店已加入投票清單囉",
                        preferredStyle: .alert
                    )
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okAction)
                    present(alert, animated: true)
                } catch {
                    print("error \(error)")
                }
            }
        }
    }

//    func didPressAddFavoriteButton(_ view: SectionHeaderView) {
//        //
//    }
}
extension ShopMenuViewController: GroupManagerDelegate {
    func groupManager(_ manager: GroupManager, didGetGroupObject groupObject: GroupResponse) {
        self.groupObject = groupObject
    }
    func groupManager(_ manager: GroupManager, didFailWith error: Error) {
        print(error)
    }
}

extension ShopMenuViewController: LoginSheetViewControllerDelegate {
    func loginSheetViewControllerLoginSuccess(_ viewController: LoginSheetViewController, withUser userObject: UserObject) {
        makeAlertToast(message: "登入成功", title: nil, duration: 2)

        // let TabBarViewController reload viewcontrollers
        // Better put "Init LoginSheetVC" as a delegate event to HomeVC -> TabBarVC
    }
}
