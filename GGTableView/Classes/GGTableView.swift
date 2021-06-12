//
//  GGTableViewDelegateProxy.swift
//  IOSAppTest
//
//  Created by GaoXudong on 2021/3/8.
//

import Foundation
import UIKit

//MARK:- datasource
open class GGTableViewDelegateProxy: NSObject {
    open var dataSource: Array<GGTableViewSection> = []
    
    final private func findRow(at indexPath: IndexPath) -> GGTableViewRow {
        let section = dataSource[safe: indexPath.section]
        let row = section.rowsArray[safe: indexPath.row]
        return row
    }
}

extension GGTableViewDelegateProxy: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = findRow(at: indexPath)
        return row.cellHeight()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = findRow(at: indexPath)
        if let selectBlock = row.didSelectRow {
            selectBlock(indexPath)
        }
    }
}

extension GGTableViewDelegateProxy: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[safe: section].rowsArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = findRow(at: indexPath)
        let cell = row.getCell(for: tableView, at: indexPath)
        row.update(cell, at: indexPath)
        row.height = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return cell
    }
}

//MARK:- TableViewCell
open class GGTableViewCell: UITableViewCell {
    
    open func configSubviews() {
        fatalError("Must Override")
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configSubviews()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- section
open class GGTableViewRow {
    open var CellClass: UITableViewCell.Type {
        UITableViewCell.self
    }

    open func update(_ cell: UITableViewCell, at indexPath: IndexPath) {
        fatalError("Must Override")
    }

    open var height:CGFloat = 0.0
    open func cellHeight() -> CGFloat { height > 0 ? height : UITableView.automaticDimension }
    open func cellReuseIdentifier() -> String {
        String(describing: self)
    }
    
    open var didSelectRow: ((IndexPath) -> Void)?
    
    public init() {  }
    
    final fileprivate func getCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier()) {
            return cell
        } else {
            let cell = CellClass.init(style: .default, reuseIdentifier: cellReuseIdentifier())
            return cell
        }
    }
}

open class GGTableViewSection {
    open var rowsArray: Array<GGTableViewRow>
    public init() {
        rowsArray = []
    }
}

//MARK:- Array subscript extension
extension Array {
    subscript(safe index: Int) -> Element {
        (0..<count).contains(index) ? self[index] : self[0]
    }
}
