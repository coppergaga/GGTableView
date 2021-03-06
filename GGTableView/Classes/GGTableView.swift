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

// MARK:- datasource
open class GGTableViewDelegateProxy: NSObject {
    open var dataSource = GGTableViewDataSource()
    
    public var enableForwardScrollMsg = false
    
    public weak var tableView: UITableView? {
        didSet {
            dataSource.tableView = tableView
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
        if !row.isVisible {
            row.isVisible = true
        }
        if let willDisplayBlock = row.willDisplayCell {
            willDisplayBlock(tableView, cell, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = findRow(at: indexPath)
        if row.isVisible {
            row.isVisible = false
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

    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let row = findRow(at: indexPath)
        return row.titleForDeleteConfirmationButton
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

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = findRow(at: indexPath)
        return row.canEditRow
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let row = findRow(at: indexPath)
        row.commitEditingStyle?(tableView, editingStyle, indexPath)
    }
}

extension GGTableViewDelegateProxy {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard enableForwardScrollMsg else {
            return
        }
        if let tv = scrollView as? UITableView, let proxy = tv.delegate as? GGTableViewDelegateProxy {
            _ = proxy.dataSource.allRows
                        .compactMap { $0.isVisible ? $0.scrollViewDidScroll?(scrollView, nil) : nil }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard enableForwardScrollMsg else {
            return
        }
        if let tv = scrollView as? UITableView, let proxy = tv.delegate as? GGTableViewDelegateProxy {
            _ = proxy.dataSource.allRows
                        .compactMap { $0.isVisible ? $0.scrollViewWillBeginDragging?(scrollView, nil) : nil }
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard enableForwardScrollMsg else {
            return
        }
        if let tv = scrollView as? UITableView, let proxy = tv.delegate as? GGTableViewDelegateProxy {
            _ = proxy.dataSource.allRows
                        .compactMap { $0.isVisible ? $0.scrollViewDidEndDragging?(scrollView, nil) : nil }
        }
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard enableForwardScrollMsg else {
            return
        }
        if let tv = scrollView as? UITableView, let proxy = tv.delegate as? GGTableViewDelegateProxy {
            _ = proxy.dataSource.allRows
                        .compactMap { $0.isVisible ? $0.scrollViewWillBeginDecelerating?(scrollView, nil) : nil }
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard enableForwardScrollMsg else {
            return
        }
        if let tv = scrollView as? UITableView, let proxy = tv.delegate as? GGTableViewDelegateProxy {
            _ = proxy.dataSource.allRows
                        .compactMap { $0.isVisible ? $0.scrollViewDidEndDecelerating?(scrollView, nil) : nil }
        }
    }
}

// MARK:- TableViewCell
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



// MARK:- base class GGNode
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
    
    public weak var tableView: UITableView?
    
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
    
    func add(element: Element) {
        add(elements: [element])
    }
    
    func add(elements: [Element]) {
        semaphore.wait()
        let index = count
        items.append(contentsOf: elements)
        var temp: Element
        for i in 0..<elements.count {
            let rowIdx = i + index
            temp = self[rowIdx]
            temp.indexPath = IndexPath(row: rowIdx, section: indexPath.row)
            temp.tableView = tableView
        }
        semaphore.signal()
    }
    
    func remove(element: Element) {
        semaphore.wait()
        let indexPath = element.indexPath
        items.remove(safe: indexPath.row)
        var temp: Element
        for i in 0..<(count - indexPath.row) {
            let rowIdx = indexPath.row + i
            temp = self[rowIdx]
            temp.indexPath = IndexPath(row: rowIdx, section: indexPath.row)
        }
        semaphore.signal()
    }
    
    public func removeAll() {
        semaphore.wait()
        items.removeAll()
        semaphore.signal()
    }
    
    func insert(elements: [Element], at idx: Int) {
        semaphore.wait()
        items.insert(contentsOf: elements, at: idx)
        var temp: Element
        for i in 0..<(count - idx) {
            temp = self[idx]
            temp.indexPath = IndexPath(row: idx + i, section: indexPath.row)
            temp.tableView = tableView
        }
        semaphore.signal()
    }
}

// MARK:- row
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
    public var canEditRow = false
    public var commitEditingStyle: ((UITableView, UITableViewCell.EditingStyle, IndexPath) -> Void)?
    public var titleForDeleteConfirmationButton: String?
    
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
    
    public var isVisible = false
}

// MARK:- section
open class GGTableViewSection: GGNode<GGTableViewRow> {
    
    open var sectionHeaderView: UIView?
    public var headerHeight = CGFloat.zero
    open var sectionFooterView: UIView?
    public var footerHeight = CGFloat.zero
    
    public var allRows: [GGTableViewRow] {
        super.allItems
    }
    
    public func add(row: GGTableViewRow) {
        super.add(element: row)
    }
    
    public func add(rows: [GGTableViewRow]) {
        super.add(elements: rows)
    }
    
    public func remove(row: GGTableViewRow) {
        super.remove(element: row)
    }
    
    public func insert(rows: [GGTableViewRow], at idx: Int) {
        super.insert(elements: rows, at: idx)
    }
    
    public func insert(row: GGTableViewRow, at idx: Int) {
        insert(rows: [row], at: idx)
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
        super.add(element: section)
    }
    
    public func add(sections: [GGTableViewSection]) {
        super.add(elements: sections)
    }
    
    public func remove(section: GGTableViewSection) {
        super.remove(element: section)
    }
    
    public func insert(sections: [GGTableViewSection], at idx: Int) {
        super.insert(elements: sections, at: idx)
    }
    
    public func insert(section: GGTableViewSection, at idx: Int) {
        insert(sections: [section], at: idx)
    }
}

// MARK:- Array subscript extension
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
