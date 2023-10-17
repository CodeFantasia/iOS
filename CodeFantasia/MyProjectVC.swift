//
//  MyProjectVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/13/23.

import UIKit
import SnapKit
import Then

class MyProjectVC: UITableViewController {
    
    let barTitle = UILabel().then {
        $0.text = "내 프로젝트"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.textColor = .black
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationbarTitle()
        
        tableView.register(MyProjectTableViewCell.self, forCellReuseIdentifier: MyProjectTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MyProjectVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProjectTableViewCell.identifier, for: indexPath) as? MyProjectTableViewCell else { return UITableViewCell() }
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
    
    func navigationbarTitle() {
        let barTitleItem = UIBarButtonItem(customView: barTitle)
        navigationItem.leftBarButtonItem = barTitleItem
    }
}


