//
//  DrinkDetailViewModelTests.swift
//  DrinkDetailViewModelTests
//
//  Created by Vickyciou on 2023/7/22.
//

import XCTest
@testable import DrinkWhat

final class DrinkDetailViewModelTests: XCTestCase {

    private let drink = ShopMenu(
        drinkName: "Mock Drink",
        drinkPrice: [
            VolumePrice(volume: "S", price: 100),
            VolumePrice(volume: "M", price: 150),
            VolumePrice(volume: "L", price: 200)]
    )
    private let logoImageURL = "https://example.com/logo.png"
    private let mainImageURL = "https://example.com/main.png"
    private let shopName = "Coffee Shop"
    private let shopID = "123456"


    private let addToppings: [AddToppings] = [
        AddToppings(topping: "Whipped Cream", price: 30),
        AddToppings(topping: "Chocolate Syrup", price: 40)
    ]

    private lazy var shopObject = ShopObject(
        logoImageURL: logoImageURL,
        mainImageURL: mainImageURL,
        name: shopName,
        id: shopID,
        menu: [drink],
        addToppings: addToppings
    )

    struct DataSource: DrinkDetailDataSourceProtocol {
        let sugar = ["Regular", "Less Sugar", "No Sugar"]
        let ice = ["Regular", "Less Ice", "No Ice"]
    }

    private let dataSource = DataSource()

    func testCalculateDrinkPriceWithValidCurrentVolumeIndex() {
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
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        XCTAssertEqual(sut.numberOfRowsInSection(section: 0), 3)
        XCTAssertEqual(sut.numberOfRowsInSection(section: 1), 3)
        XCTAssertEqual(sut.numberOfRowsInSection(section: 2), 3)
        XCTAssertEqual(sut.numberOfRowsInSection(section: 3), 2)
        XCTAssertEqual(sut.numberOfRowsInSection(section: 4), 0)
    }

    func testSetCurrentSugarIndexWithDiffIndex() {
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        sut.setCurrentSugarIndex(index: 1)
        let mockDelegate = MockDrinkDetailViewModelDelegate()
        sut.delegate = mockDelegate

        sut.setCurrentSugarIndex(index: 2)

        XCTAssertTrue(sut.currentSugarIndexSelected(index: 2))
        XCTAssertTrue(mockDelegate.reloadDataCalled)

    }

    func testSetCurrentSugarIndexWithSameIndex() {
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        sut.setCurrentSugarIndex(index: 1)
        let mockDelegate = MockDrinkDetailViewModelDelegate()
        sut.delegate = mockDelegate

        sut.setCurrentSugarIndex(index: 1)

        XCTAssertTrue(sut.currentSugarIndexSelected(index: 1))
        XCTAssertFalse(mockDelegate.reloadDataCalled)

    }

    func testSetCurrentIceIndexWithDiffIndex() {
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        sut.setCurrentIceIndex(index: 1)
        let mockDelegate = MockDrinkDetailViewModelDelegate()
        sut.delegate = mockDelegate

        sut.setCurrentIceIndex(index: 2)

        XCTAssertTrue(sut.currentIceIndexSelected(index: 2))
        XCTAssertTrue(mockDelegate.reloadDataCalled)

    }

    func testSetCurrentIceIndexWithSameIndex() {
        let sut = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)

        sut.setCurrentIceIndex(index: 1)
        let mockDelegate = MockDrinkDetailViewModelDelegate()
        sut.delegate = mockDelegate

        sut.setCurrentIceIndex(index: 1)

        XCTAssertTrue(sut.currentIceIndexSelected(index: 1))
        XCTAssertFalse(mockDelegate.reloadDataCalled)

    }

    func testSetCurrentAddToppingsIndexWithSameIndex() {
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
