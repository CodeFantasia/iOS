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
        
        tableView.register(MyProjectTableViewCell.self, forCellReuseIdentifier: MyProjectTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MyProjectVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
               header.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 30)
               header.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
               header.textLabel?.textColor = UIColor.black
               header.textLabel?.sizeToFit()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "내 프로젝트"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyProjectTableViewCell.identifier, for: indexPath) as! MyProjectTableViewCell
        
        cell.projectTitle.text = "즐코팟 모집중"
        cell.projectSubtitle.text = """
                                    나의 첫 사이드 프로젝트 여기서 시작해보
                                    자!
                                    """
        cell.dateLabel.text = "D-17"
        cell.projectImage.backgroundColor = .gray
        cell.dateView.backgroundColor = .black
   
        return cell
    }
}

