//
//  DrinkDetailViewModel.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/21.
//

import Foundation

protocol DrinkDetailViewModelDelegate: AnyObject {
    func topViewNeedToReloadData(_ viewModel: DrinkDetailViewModel)
}

class DrinkDetailViewModel {
    private let drink: ShopMenu
    private let shopObject: ShopObject
    private let dataSource = DrinkDetailDataSource()
    private let orderManager = OrderManager()
    weak var delegate: DrinkDetailViewModelDelegate?
    private var note: String?
    private var currentVolumeIndex: Int?
    private var currentSugarIndex: Int?
    private var currentIceIndex: Int?
    private var currentAddToppingsIndexes: Set<Int> = []
    private var totalDrinkPrice: Int {
        calculateDrinkPrice()
    }

    init(drink: ShopMenu, shopObject: ShopObject) {
        self.drink = drink
        self.shopObject = shopObject
    }

    func getDrink() -> ShopMenu {
        return drink
    }

    func getShopObject() -> ShopObject {
        return shopObject
    }

    func getDataSource() -> DrinkDetailDataSource {
        return dataSource
    }

    func calculateDrinkPrice() -> Int {
        let basePrice = currentVolumeIndex.map { drink.drinkPrice[$0].price } ?? drink.drinkPrice[0].price
        let extraPrice = currentAddToppingsIndexes.map { shopObject.addToppings[$0].price }.reduce(0, +)
        return basePrice + extraPrice
    }

    func addOrderObject() async throws {
        var addToppings: [AddTopping] = []
        currentAddToppingsIndexes.forEach { index in
            let topping = shopObject.addToppings[index].topping
            let price = shopObject.addToppings[index].price
            let addTopping = AddTopping(topping: topping, price: price)
            addToppings.append(addTopping)
        }
        guard let currentIceIndex, let currentSugarIndex, let currentVolumeIndex else {
            throw OrderManagerError.selectionMissingError
        }
        let orderObject = OrderObject(
            drinkName: drink.drinkName,
            drinkPrice: totalDrinkPrice,
            volume: drink.drinkPrice[currentVolumeIndex].volume,
            sugar: dataSource.sugar[currentSugarIndex],
            ice: dataSource.ice[currentIceIndex],
            addToppings: addToppings,
            note: note ?? "")

        try await addOrderResult(orderObject: orderObject)

    }

    func addOrderResult(orderObject: OrderObject) async throws {
        let userObject = try await UserManager.shared.loadCurrentUser()
        do {
            try await orderManager.addOrderResult(
                userID: userObject.userID,
                orderObject: orderObject,
                shopID: shopObject.id)
        } catch UserManagerError.noCurrentUser {
            throw UserManagerError.noCurrentUser
        } catch OrderManagerError.noData {
            throw OrderManagerError.noData
        } catch OrderManagerError.noMatchData {
            throw OrderManagerError.noMatchData
        } catch {
            throw error
        }
    }

    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return drink.drinkPrice.count
        case 1:
            return dataSource.sugar.count
        case 2:
            return dataSource.ice.count
        case 3:
            return shopObject.addToppings.count
        default:
            return 0
        }
    }
    func setNote(note: String) {
        self.note = note
    }

    func currentVolumeIndexSelected(index: Int) -> Bool {
        currentVolumeIndex == index
    }

    func currentIceIndexSelected(index: Int) -> Bool {
        currentIceIndex == index
    }

    func currentAddToppingsIndexesSelected(index: Int) -> Bool {
        currentAddToppingsIndexes.contains(index)
    }

    func currentSugarIndexSelected(index: Int) -> Bool {
        currentSugarIndex == index
    }

    func setCurrentVolumeIndex(index: Int) {
        guard currentVolumeIndex != index else { return }
        currentVolumeIndex = index
            delegate?.topViewNeedToReloadData(self)
    }

    func setCurrentSugarIndex(index: Int) {
        guard currentSugarIndex != index else { return }
        currentSugarIndex = index
            delegate?.topViewNeedToReloadData(self)
    }

    func setCurrentIceIndex(index: Int) {
        guard currentIceIndex != index else { return }
        currentIceIndex = index
            delegate?.topViewNeedToReloadData(self)
    }

    func setCurrentAddToppingIndexes(index: Int) {
        currentAddToppingsIndexes.toggle(with: index)
        delegate?.topViewNeedToReloadData(self)
    }
}

extension Set {
    mutating func toggle(with value: Element) {
        if contains(value) {
            remove(value)
        } else {
            insert(value)
        }
    }
}
