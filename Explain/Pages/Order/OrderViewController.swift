//
//  OrderViewController.swift
//  Explain
//
//  Created by 이병현 on 2023/02/16.
//

import UIKit
import SnapKit

class OrderViewController: UIViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateOrderInfos()
        updateTextViewHeight()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - UI Logic

    func heightWithConstrainedWidth(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }

    func updateTextViewHeight() {
        let height = heightWithConstrainedWidth(text: ordersList.text,
                                                width: ordersList.bounds.width,
                                                font: ordersList.font ?? UIFont.systemFont(ofSize: 20))
        ordersListHeight.constant = height + 40
    }

    // MARK: - Business Logic

    var orderedMenuItems: [(menu: MenuItem, count: Int)] = []

    func updateOrderInfos() {
        let allItemsText = orderedMenuItems.map { "\($0.menu.name) \($0.count)개" }.joined(separator: "\n")
        let allItemsPrice = orderedMenuItems.map { $0.menu.price * $0.count }.reduce(0, +)
        let allVatPrice = Int(Float(allItemsPrice) * 0.1 / 10 + 0.5) * 10

        ordersList.text = allItemsText
        itemsPrice.text = allItemsPrice.currencyKR()
        vatPrice.text = allVatPrice.currencyKR()
        totalPrice.text = (allItemsPrice + allVatPrice).currencyKR()
    }

    // MARK: - Interface Builder

    @IBOutlet var ordersList: UITextView!
    @IBOutlet var ordersListHeight: NSLayoutConstraint!
    @IBOutlet var itemsPrice: UILabel!
    @IBOutlet var vatPrice: UILabel!
    @IBOutlet var totalPrice: UILabel!
}
