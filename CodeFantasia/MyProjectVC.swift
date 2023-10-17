//
//  MyProjectVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/13/23.

import UIKit
import SnapKit

class MyProjectVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MyProjectVC {
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

