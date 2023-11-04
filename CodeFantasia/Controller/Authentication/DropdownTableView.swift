//
//  DropdownTableView.swift
//  CodeFantasia
//
//  Created by Daisy Hong on 2023/11/04.
//

import UIKit

class DropDownTableView: UITableView {
    
    // MARK: - init
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    var list = [String]()
    
    // MARK: - Helpers

    func createDropdownTableView(withList list: [String]) {
        self.list = list
        self.register(DropdownTableViewCell.classForCoder(), forCellReuseIdentifier: "dropdownTableViewIdentifier")
    }

}

// MARK: - Delegate, DataSource

extension DropDownTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "dropdownTableViewIdentifier", for: indexPath) as! DropdownTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}

// MARK: - Cell

class DropdownTableViewCell: UITableViewCell {
    
}
