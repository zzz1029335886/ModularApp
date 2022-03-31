//
//  UITableViewCellExtension.swift
//  BrainBank
//
//  Created by Alvin on 2021/1/26.
//  Copyright © 2021 yoao. All rights reserved.
//

import Foundation

extension UITableViewCell {
    /// 获取父tableView
    func superTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
    
}
