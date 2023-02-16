//
//  MenuItemTableViewCell.swift
//  Explain
//
//  Created by 이병현 on 2023/02/16.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    var onCountChanged: (Int) -> Void = { _ in }

    @IBOutlet var title: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var price: UILabel!

    @IBAction func onIncreaseCount() {
        onCountChanged(1)
    }

    @IBAction func onDecreaseCount() {
        onCountChanged(-1)
    }
}
