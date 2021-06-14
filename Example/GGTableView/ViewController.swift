//
//  ViewController.swift
//  GGTableView
//
//  Created by coppergaga on 06/12/2021.
//  Copyright (c) 2021 coppergaga. All rights reserved.
//

import UIKit
import SnapKit
import GGTableView

class ViewController: UIViewController {
        
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = proxy
        tableView.dataSource = proxy
        tableView.estimatedRowHeight = 44.0
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        return tableView
    }()
    
    let proxy: GGTableViewDelegateProxy = GGTableViewDelegateProxy()
    var section = GGTableViewSection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        proxy.tableView = tableView
        proxy.enableForwardScrollMsg = true
        
        let headerView = GGTestHeaderView(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        headerView.eventClouse = {
            self.section.headerHeight = CGFloat.zero
            self.section.tableView?.performBatchUpdates(nil, completion: nil)
        }
        section.sectionHeaderView = headerView
        
        for idx in 0..<10 {
            let row: GGTableViewRow = GGTestRow()
            if idx != 0 {
                row.scrollViewDidScroll = { (scrollView, decelerate) in
                    print("receive scrollview did scroll msg")
                }
            }
            row.didSelectRow = {[unowned self] (tv, cell, idxPath) in
                self.navigationController?.pushViewController(ViewController(), animated: true)
            }
            section.add(row: row)
        }
        
        proxy.dataSource.add(section: section)
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class GGTestHeaderView: UIView {
    var eventClouse: (() -> Void)?
    
    let btn1 = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
        
        btn1.backgroundColor = UIColor.red
        btn1.setTitle("higher", for: .normal)
        btn1.addTarget(self, action: #selector(higherEvent), for: .touchUpInside)
        btn1.setTitleColor(UIColor.black, for: .normal)
        let btn2 = UIButton()
        btn2.backgroundColor = UIColor.yellow
        btn2.setTitle("shorter", for: .normal)
        btn2.addTarget(self, action: #selector(shorterEvent), for: .touchUpInside)
        btn2.setTitleColor(UIColor.black, for: .normal)
        
        self.addSubview(btn1)
        self.addSubview(btn2)
        btn1.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-30).priority(.high)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        btn2.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.greaterThanOrEqualTo(btn1).offset(10)
            make.right.equalTo(self).offset(-10).priority(.high)
            make.width.equalTo(100)

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func higherEvent() {
        btn1.snp.updateConstraints { make in
            make.top.equalTo(40)
        }
        eventClouse?()
    }
    @objc
    func shorterEvent() {
        btn1.snp.updateConstraints { make in
            make.top.equalTo(0)
        }
        eventClouse?()
    }
}
