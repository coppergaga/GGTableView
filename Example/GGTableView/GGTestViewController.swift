//
//  GGTestViewController.swift
//  GGTableView_Example
//
//  Created by 高旭东 on 2021/6/12.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import GGTableView

class GGTestViewController: UIViewController {
    override func viewDidLoad() {
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 50))
        label.backgroundColor = .black
        
        view.backgroundColor = .white
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.top.equalTo(120)
            make.right.equalTo(-20)
            make.height.equalTo(50)
        }
    }
}


class GGTestCell: GGTableViewCell {
    lazy var leftLabel = { () -> UILabel in
        var label = UILabel()
        label.text = "left labelleft labelleft\n\n labelleft labelleft labelleft labelleft\n\n label"
        label.textColor = .blue
        label.numberOfLines = 0
        return label
    }()
    lazy var rightLabel = UILabel()
    
    override func configSubviews() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        
        rightLabel.text = "right label"
        rightLabel.textColor = .red
        rightLabel.font = UIFont.systemFont(ofSize: 25)
        
        leftLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.width.equalTo(200)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(leftLabel.snp.right).offset(20);
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView)
        }
    }
}

class GGTestRow: GGTableViewRow {
    override var CellClass: UITableViewCell.Type {
        GGTestCell.self
    }
    override func update(_ cell: UITableViewCell, at indexPath: IndexPath) {
        
    }
}
