//
//  GGTableViewDelegateProxy.swift
//  IOSAppTest
//
//  Created by GaoXudong on 2021/3/8.
//

import Foundation
import UIKit
import Swift

public typealias GGTableViewProxyBlock = (UITableView, UITableViewCell?, IndexPath) -> Void
public typealias GGTableViewScrollBlock = (UIScrollView, Bool?) -> Void

//MARK:- datasource
open class GGTableViewDelegateProxy: NSObject {
    open var dataSource = GGTableViewDataSource()
    
    public var enableForwardScrollMsg = false
    
    public weak var tableView: UITableView? {
        didSet {
            dataSource.tableView = self.tableView
        }
    }
    
    final public func findRow(at indexPath: IndexPath) -> GGTableViewRow {
        let section = dataSource[indexPath.section]
        let row = section[indexPath.row]
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
            selectBlock(tableView, nil, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let row = findRow(at: indexPath)
        if let deselectBlock = row.didDeselectRow {
            deselectBlock(tableView, nil, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = findRow(at: indexPath)
        if !row.isVisiable {
            row.isVisiable = true
        }
        if let willDisplayBlock = row.willDisplayCell {
            willDisplayBlock(tableView, cell, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = findRow(at: indexPath)
        if row.isVisiable {
            row.isVisiable = false
        }
        if let endDisplayingBlock = row.didEndDisplayingCell {
            endDisplayingBlock(tableView, cell, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sec = dataSource[section]
        return sec.sectionHeaderView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sec = dataSource[section]
        if let headerView = sec.sectionHeaderView, sec.headerHeight <= CGFloat.zero {
            sec.headerHeight = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        }
        return sec.headerHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sec = dataSource[section]
        return sec.sectionFooterView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sec = dataSource[section]
        if let footerView = sec.sectionFooterView, sec.footerHeight <= CGFloat.zero {
            sec.footerHeight = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        }
        return sec.footerHeight
    }
}

extension GGTableViewDelegateProxy: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = findRow(at: indexPath)
        let cell = row.getCell(for: tableView, at: indexPath)
        row.update(cell, at: indexPath)
        if row.height <= 0 {
            row.height = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        }
        return cell
    }
}

extension GGTableViewDelegateProxy {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard enableForwardScrollMsg else {
            return
        }
        if let tv = scrollView as? UITableView, let proxy = tv.delegate as? GGTableViewDelegateProxy {
            let _ = proxy.dataSource.allRows
                        .compactMap { $0.isVisiable ? $0.scrollViewDidScroll?(scrollView, nil) : nil }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard enableForwardScrollMsg else {
            return
        }
        if let tv = scrollView as? UITableView, let proxy = tv.delegate as? GGTableViewDelegateProxy {
            let _ = proxy.dataSource.allRows
                        .compactMap { $0.isVisiable ? $0.scrollViewWillBeginDragging?(scrollView, nil) : nil }
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard enableForwardScrollMsg else {
            return
        }
        if let tv = scrollView as? UITableView, let proxy = tv.delegate as? GGTableViewDelegateProxy {
            let _ = proxy.dataSource.allRows
                        .compactMap { $0.isVisiable ? $0.scrollViewDidEndDragging?(scrollView, nil) : nil }
        }
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard enableForwardScrollMsg else {
            return
        }
        if let tv = scrollView as? UITableView, let proxy = tv.delegate as? GGTableViewDelegateProxy {
            let _ = proxy.dataSource.allRows
                        .compactMap { $0.isVisiable ? $0.scrollViewWillBeginDecelerating?(scrollView, nil) : nil }
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard enableForwardScrollMsg else {
            return
        }
        if let tv = scrollView as? UITableView, let proxy = tv.delegate as? GGTableViewDelegateProxy {
            let _ = proxy.dataSource.allRows
                        .compactMap { $0.isVisiable ? $0.scrollViewDidEndDecelerating?(scrollView, nil) : nil }
        }
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



//MARK:- base class GGNode
public protocol GGNodeProtocol {
    var indexPath: IndexPath { get set }
    var tableView: UITableView? { get set }
    
}

open class GGNode<Element>: GGNodeProtocol where Element: GGNodeProtocol {
    
    private var semaphore = DispatchSemaphore(value: 1)
    
    /*
     * indexPath.section will be meaningless when GGNode self is GGTableViewSection.
     * In other words, indexPath indicates that it has the same meaning with UITableViewCell's indexPath when current node is a GGTableViewRow,
     * while GGTableViewSection only use indexPath.row (indexPath.section would always be zero)
     */
    public var indexPath = IndexPath(row: 0, section: 0)
    
    public weak var tableView: UITableView? {
        didSet {
            semaphore.wait()
            for idx in 0..<items.count {
                items[safe: idx].tableView = self.tableView
            }
            semaphore.signal()
        }
    }
    
    private var items = [Element]()
    
    public var count: Int {
        items.count
    }
    
    public init() {  }
    
    public subscript(_ index: Int) -> Element {
        get {
            items[safe: index]
        }
        set {
            items[safe: index] = newValue
        }
    }
}

extension GGNode {
    
    var allItems: [Element] {
        items
    }
    
    func add(item: Element) {
        semaphore.wait()
        let index = items.count
        items.append(item)
        var temp = items[safe: index]
        temp.indexPath = IndexPath(row: index, section: self.indexPath.row)
        temp.tableView = tableView
        semaphore.signal()
    }
    
    func add(items: Array<Element>) {
        for idx in 0..<items.count {
            add(item: items[safe: idx])
        }
    }
    
    func remove(item: Element) {
        semaphore.wait()
        items.remove(safe: item.indexPath.row)
        semaphore.signal()
    }
    
    public func removeAll() {
        semaphore.wait()
        items.removeAll()
        semaphore.signal()
    }
}

//MARK:- row
open class GGTableViewRow: GGNodeProtocol {
    public weak var tableView: UITableView?
    
    open var CellClass: UITableViewCell.Type {
        UITableViewCell.self
    }

    open func update(_ cell: UITableViewCell, at indexPath: IndexPath) {
        fatalError("Must Override")
    }

    public var height = CGFloat.zero
    open func cellHeight() -> CGFloat { height > 0 ? height : UITableView.automaticDimension }
    open func cellReuseIdentifier() -> String {
        String(describing: self)
    }
    
    public var didSelectRow: GGTableViewProxyBlock?
    public var didDeselectRow: GGTableViewProxyBlock?
    public var willDisplayCell: GGTableViewProxyBlock?
    public var didEndDisplayingCell: GGTableViewProxyBlock?
    
    public var scrollViewDidScroll: GGTableViewScrollBlock?
    public var scrollViewWillBeginDragging: GGTableViewScrollBlock?
    public var scrollViewDidEndDragging: GGTableViewScrollBlock?
    public var scrollViewWillBeginDecelerating: GGTableViewScrollBlock?
    public var scrollViewDidEndDecelerating: GGTableViewScrollBlock?
    
    public var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    public init() {  }
    
    final fileprivate func getCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier()) {
            return cell
        } else {
            let cell = CellClass.init(style: .default, reuseIdentifier: cellReuseIdentifier())
            return cell
        }
    }
    
    public var isVisiable = false {
        didSet {
            print(indexPath, "====", isVisiable)
        }
    }
}

//MARK:- section
open class GGTableViewSection: GGNode<GGTableViewRow> {
    
    open var sectionHeaderView: UIView?
    public var headerHeight = CGFloat.zero
    open var sectionFooterView: UIView?
    public var footerHeight = CGFloat.zero
    
    public var allRows: [GGTableViewRow] {
        super.allItems
    }
    
    public func add(row: GGTableViewRow) {
        super.add(item: row)
    }
    
    public func add(rows: Array<GGTableViewRow>) {
        super.add(items: rows)
    }
    
    public func remove(row: GGTableViewRow) {
        super.remove(item: row)
    }
}

open class GGTableViewDataSource: GGNode<GGTableViewSection> {
    public var allRows: [GGTableViewRow] {
        var ret = [GGTableViewRow]()
        for sec in allSections {
            ret.append(contentsOf: sec.allRows)
        }
        return ret
    }
    
    public var allSections: [GGTableViewSection] {
        allItems
    }
    
    public func add(section: GGTableViewSection) {
        super.add(item: section)
    }
    
    public func add(sections: Array<GGTableViewSection>) {
        super.add(items: sections)
    }
    
    public func remove(section: GGTableViewSection) {
        super.remove(item: section)
    }
}

//MARK:- Array subscript extension
extension Array {
    subscript(safe index: Int) -> Element {
        get {
            (0..<count).contains(index) ? self[index] : self[0]
        }
        set {
            if (0..<count).contains(index) {
                self[index] = newValue
            } else {
                assertionFailure("Array out of bounds")
            }
        }
    }
    
    mutating func remove(safe index: Int) {
        if (0..<count).contains(index) {
            remove(at: index)
        } else {
            assertionFailure("Array out of bounds")
        }
    }
}
