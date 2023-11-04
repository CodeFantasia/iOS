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
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    var list = [String]()
    var selectedItems: [String] = []
    
    // MARK: - Helpers
    
    func configure() {
        self.delegate = self
        self.dataSource = self
        
        self.layer.cornerRadius = .cornerRadius
        self.layer.borderWidth = 0.75
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = .white
        self.clipsToBounds = true

        self.allowsMultipleSelection = true
        
    }

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
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItems.append(list[indexPath.row])
        print("cell 선택했음. selectedItems: \(selectedItems)")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //selectedItems.remove(list[indexPath.row])
        print("deselect!")
    }
}

// MARK: - Cell

class DropdownTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
    }
}
