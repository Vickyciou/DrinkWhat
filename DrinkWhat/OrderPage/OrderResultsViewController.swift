//
//  OrderResultsViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/1.
//

import UIKit

class OrderResultsViewController: UIViewController {
    private let orderResponse: OrderResponse
    private let joinUserObject: [UserObject]
    private let orderResults: [OrderResults]

    init(
        orderResponse: OrderResponse,
        joinUserObject: [UserObject],
        orderResults: [OrderResults]
    ) {
        self.orderResponse = orderResponse
        self.joinUserObject = joinUserObject
        self.orderResults = orderResults
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
