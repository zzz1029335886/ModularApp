//
//  BBBaseTableViewController.swift
//  Base
//
//  Created by zerry on 2022/4/1.
//

import UIKit
import SnapKit

open class BBBaseTableViewController: BBBaseViewController {
    
    private lazy var groupedTableView = UITableView.init(frame: view.bounds, style: .grouped)
    private lazy var plainTableView = UITableView.init(frame: view.bounds, style: .plain)
    
    func setTableView(_ tableView: UITableView) {
        if isSeparatorStyle == false {
            tableView.separatorStyle = .none
        }
        tableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0.1, height: 0.1))
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0.1, height: 0.1))
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        
        if isViewLoaded {
            self.view.addSubview(tableView)
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = isPlainTableView ? plainTableView : groupedTableView
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        setTableView(tableView)
        return tableView
    }()
    
    var isPlainTableView = true
    
    var isSeparatorStyle : Bool = false
}

class BBBaseScrollViewController: BBBaseViewController {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(self.snpSafeAreaTop)
        }
        return scrollView
    }()
}
