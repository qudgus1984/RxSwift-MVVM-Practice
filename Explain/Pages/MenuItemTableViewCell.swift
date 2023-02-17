//
//  MenuItemTableViewCell.swift
//  Explain
//
//  Created by 이병현 on 2023/02/16.
//

import UIKit
import SnapKit

class MenuItemTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        configureLayout()
        setConstraints()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onCountChanged: (Int) -> Void = { _ in }

//    @IBOutlet var title: UILabel!
    internal var title = UILabel()
//    @IBOutlet var count: UILabel!
    internal var count = UILabel()
//    @IBOutlet var price: UILabel!
    internal var price = UILabel()
    
    func configureUI() {
        title.font = UIFont.systemFont(ofSize: 24)
        title.textColor = .black
        count.font = UIFont.systemFont(ofSize: 18)
        count.textColor = .systemGray3
        price.textColor = .systemGray5
        price.font = UIFont.systemFont(ofSize: 16)
    }
    
    func configureLayout() {
        [title, count, price].forEach { addSubview($0) }
    }
    
    func setConstraints() {
        price.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(20)
        }
        
        title.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(30)
        }
        
        price.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(title.snp.trailing).offset(8)
            make.width.equalTo(12)
        }
        
    }
    

    @IBAction func onIncreaseCount() {
        onCountChanged(1)
    }

    @IBAction func onDecreaseCount() {
        onCountChanged(-1)
    }
}
