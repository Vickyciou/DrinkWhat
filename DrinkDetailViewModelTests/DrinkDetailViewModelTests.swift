//
//  DrinkDetailViewModelTests.swift
//  DrinkDetailViewModelTests
//
//  Created by Vickyciou on 2023/7/22.
//

import XCTest
@testable import DrinkWhat

final class DrinkDetailViewModelTests: XCTestCase {

    let drink = ShopMenu(drinkName: "Mock Drink",
                         drinkPrice: [
                            VolumePrice(volume: "S", price: 100),
                            VolumePrice(volume: "M", price: 150),
                            VolumePrice(volume: "L", price: 200)])
    let logoImageURL = "https://example.com/logo.png"
    let mainImageURL = "https://example.com/main.png"
    let shopName = "Coffee Shop"
    let shopID = "123456"


    let addToppings: [AddToppings] = [
        AddToppings(topping: "Whipped Cream", price: 30),
        AddToppings(topping: "Chocolate Syrup", price: 40)
    ]

    let dataSource = DrinkDetailDataSource()


    func testCalculateDrinkPriceWithValidCurrentVolumeIndex() {
        // Arrange
        let drink = ShopMenu(drinkName: "Mock Drink",
                             drinkPrice: [
                                VolumePrice(volume: "S", price: 100),
                                VolumePrice(volume: "M", price: 150),
                                VolumePrice(volume: "L", price: 200)])
        let logoImageURL = "https://example.com/logo.png"
        let mainImageURL = "https://example.com/main.png"
        let shopName = "Coffee Shop"
        let shopID = "123456"
        let menu: [ShopMenu] = [drink]

        let addToppings: [AddToppings] = [
            AddToppings(topping: "Whipped Cream", price: 30),
            AddToppings(topping: "Chocolate Syrup", price: 40)
        ]

        let shopObject = ShopObject(logoImageURL: logoImageURL,
                                    mainImageURL: mainImageURL,
                                    name: shopName,
                                    id: shopID,
                                    menu: menu,
                                    addToppings: addToppings)

        let dataSource = DrinkDetailDataSource()
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        // Act
        sut.setCurrentVolumeIndex(index: 1)
        sut.setCurrentAddToppingIndexes(index: 0)
        sut.setCurrentAddToppingIndexes(index: 1)
        let drinkPrice = sut.calculateDrinkPrice()

        // Assert
        XCTAssertEqual(drinkPrice, 220)
    }

    func testCalculateDrinkPriceWithNilCurrentVolumeIndex() {
        // Arrange
        let drink = ShopMenu(drinkName: "Mock Drink",
                             drinkPrice: [
                                VolumePrice(volume: "S", price: 100),
                                VolumePrice(volume: "M", price: 150),
                                VolumePrice(volume: "L", price: 200)])
        let logoImageURL = "https://example.com/logo.png"
        let mainImageURL = "https://example.com/main.png"
        let shopName = "Coffee Shop"
        let shopID = "123456"
        let menu: [ShopMenu] = [drink]

        let addToppings: [AddToppings] = [
            AddToppings(topping: "Whipped Cream", price: 30),
            AddToppings(topping: "Chocolate Syrup", price: 40)
        ]

        let shopObject = ShopObject(logoImageURL: logoImageURL,
                                    mainImageURL: mainImageURL,
                                    name: shopName,
                                    id: shopID,
                                    menu: menu,
                                    addToppings: addToppings)

        let dataSource = DrinkDetailDataSource()

        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        // Act
        sut.setCurrentVolumeIndex(index: nil)
        sut.setCurrentAddToppingIndexes(index: 0)
        sut.setCurrentAddToppingIndexes(index: 1)
        let drinkPrice = sut.calculateDrinkPrice()

        // Assert
        XCTAssertEqual(drinkPrice, 170)
    }

    func testNumberOfRowsInSection() {
        let drinkPrice1 = VolumePrice(volume: "Small", price: 100)
        let drinkPrice2 = VolumePrice(volume: "Medium", price: 150)
        let drink = ShopMenu(drinkName: "Mock Drink",
                          drinkPrice: [drinkPrice1, drinkPrice2])

        let topping1 = AddToppings(topping: "Topping A", price: 50)
        let topping2 = AddToppings(topping: "Topping B", price: 75)

        let logoImageURL = "https://example.com/logo.png"
        let mainImageURL = "https://example.com/main.png"
        let shopName = "Coffee Shop"
        let shopID = "123456"
        let menu: [ShopMenu] = [drink]
        let shopObject = ShopObject(logoImageURL: logoImageURL,
                                    mainImageURL: mainImageURL,
                                    name: shopName,
                                    id: shopID,
                                    menu: menu,
                                    addToppings: [topping1, topping2])
        struct DataSource: DrinkDetailDataSourceProtocol {
            let sugar = ["Regular", "Less Sugar", "No Sugar"]
            let ice = ["Regular", "Less Ice", "No Ice"]
        }

        let dataSource = DataSource()
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        XCTAssertEqual(sut.numberOfRowsInSection(section: 0), 2)
        XCTAssertEqual(sut.numberOfRowsInSection(section: 1), 3)
        XCTAssertEqual(sut.numberOfRowsInSection(section: 2), 3)
        XCTAssertEqual(sut.numberOfRowsInSection(section: 3), 2)
        XCTAssertEqual(sut.numberOfRowsInSection(section: 4), 0)
    }

    func testSetCurrentSugarIndexWithDiffIndex() {
        let menu: [ShopMenu] = [drink]
        let shopObject = ShopObject(logoImageURL: logoImageURL,
                                    mainImageURL: mainImageURL,
                                    name: shopName,
                                    id: shopID,
                                    menu: menu,
                                    addToppings: addToppings)
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        sut.setCurrentSugarIndex(index: 1)
        let mockDelegate = MockDrinkDetailViewModelDelegate()
        sut.delegate = mockDelegate

        sut.setCurrentSugarIndex(index: 2)

        XCTAssertTrue(sut.currentSugarIndexSelected(index: 2))
        XCTAssertTrue(mockDelegate.reloadDataCalled)

    }

    func testSetCurrentSugarIndexWithSameIndex() {
        let menu: [ShopMenu] = [drink]
        let shopObject = ShopObject(logoImageURL: logoImageURL,
                                    mainImageURL: mainImageURL,
                                    name: shopName,
                                    id: shopID,
                                    menu: menu,
                                    addToppings: addToppings)
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        sut.setCurrentSugarIndex(index: 1)
        let mockDelegate = MockDrinkDetailViewModelDelegate()
        sut.delegate = mockDelegate

        sut.setCurrentSugarIndex(index: 1)

        XCTAssertTrue(sut.currentSugarIndexSelected(index: 1))
        XCTAssertFalse(mockDelegate.reloadDataCalled)

    }

    func testSetCurrentIceIndexWithDiffIndex() {
        let menu: [ShopMenu] = [drink]
        let shopObject = ShopObject(logoImageURL: logoImageURL,
                                    mainImageURL: mainImageURL,
                                    name: shopName,
                                    id: shopID,
                                    menu: menu,
                                    addToppings: addToppings)
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        sut.setCurrentIceIndex(index: 1)
        let mockDelegate = MockDrinkDetailViewModelDelegate()
        sut.delegate = mockDelegate

        sut.setCurrentIceIndex(index: 2)

        XCTAssertTrue(sut.currentIceIndexSelected(index: 2))
        XCTAssertTrue(mockDelegate.reloadDataCalled)

    }

    func testSetCurrentIceIndexWithSameIndex() {
        let menu: [ShopMenu] = [drink]
        let shopObject = ShopObject(logoImageURL: logoImageURL,
                                    mainImageURL: mainImageURL,
                                    name: shopName,
                                    id: shopID,
                                    menu: menu,
                                    addToppings: addToppings)
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        sut.setCurrentIceIndex(index: 1)
        let mockDelegate = MockDrinkDetailViewModelDelegate()
        sut.delegate = mockDelegate

        sut.setCurrentIceIndex(index: 1)

        XCTAssertTrue(sut.currentIceIndexSelected(index: 1))
        XCTAssertFalse(mockDelegate.reloadDataCalled)

    }

    func testSetCurrentAddToppingsIndexWithSameIndex() {
        let menu: [ShopMenu] = [drink]
        let shopObject = ShopObject(logoImageURL: logoImageURL,
                                    mainImageURL: mainImageURL,
                                    name: shopName,
                                    id: shopID,
                                    menu: menu,
                                    addToppings: addToppings)
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        sut.setCurrentAddToppingIndexes(index: nil)
        let mockDelegate = MockDrinkDetailViewModelDelegate()
        sut.delegate = mockDelegate

        XCTAssertFalse(mockDelegate.reloadDataCalled)

    }
}

class MockDrinkDetailViewModelDelegate: DrinkDetailViewModelDelegate {
    var reloadDataCalled = false

    func topViewNeedToReloadData(_ viewModel: DrinkWhat.DrinkDetailViewModel) {
        reloadDataCalled = true
    }


}
