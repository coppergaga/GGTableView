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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        return tableView
    }()
    var proxy = GGTableViewDelegateProxy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        let section = GGTableViewSection()
        for _ in 0..<10 {
            let row = GGTestRow()
            row.didSelectRow = {[unowned self] idxPath in
                self.navigationController?.pushViewController(GGTestViewController(), animated: true)
            }
            section.rowsArray.append(row)
        }
        
        proxy.dataSource.append(section)
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

