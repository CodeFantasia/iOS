//
//  ProjectBoardVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/13/23.
//

import UIKit
import SnapKit

class ProjectBoardVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProjectBoardTableviewCell.self, forCellReuseIdentifier: "ProjectBoardCell")
        return tableView
    }()
    
    let mockData: [(image: UIImage?, title: String, detail: String, icons: [IconModel], status: String)] = [
        (UIImage(named: "digimon"), "Project A", "This is the detail for Project A,This is the detail for Project A, This is the detail for Project A,This is the detail for Project A, This is the detail for Project A,This is the detail for Project A", [IconModel(image: UIImage(named: "swift") ?? UIImage()), IconModel(image: UIImage(named: "javascript") ?? UIImage())], "모집 중"),
        (UIImage(named: "pokemon"), "Project B", "This is the detail for Project B", [IconModel(image: UIImage(named: "python") ?? UIImage())], "모집 완료"),
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigationBar()
        setupTableView()
        
        view.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setupNavigationBar() {
        let customTitleLabel = UILabel()
        customTitleLabel.text = "프로젝트 게시판"
        customTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        customTitleLabel.textColor = .black

        let customTitleBarItem = UIBarButtonItem(customView: customTitleLabel)
        navigationItem.leftBarButtonItem = customTitleBarItem
        
        let searchButtonView = UIButton(type: .system)
        searchButtonView.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButtonView.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)

        let bellButtonView = UIButton(type: .system)
        bellButtonView.setImage(UIImage(systemName: "bell"), for: .normal)
        bellButtonView.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)

        let pencilButtonView = UIButton(type: .system)
        pencilButtonView.setImage(UIImage(systemName: "pencil"), for: .normal)
        pencilButtonView.addTarget(self, action: #selector(pencilButtonTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [searchButtonView, bellButtonView, pencilButtonView])
        stackView.axis = .horizontal
        stackView.spacing = 10

        let stackBarButton = UIBarButtonItem(customView: stackView)
        navigationItem.rightBarButtonItem = stackBarButton
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectBoardCell", for: indexPath) as! ProjectBoardTableviewCell
        let dataItem = mockData[indexPath.row]
        cell.customImageView.image = dataItem.image
        cell.titleLabel.text = dataItem.title
        cell.detailLabel.text = dataItem.detail
        cell.icons = dataItem.icons
        cell.bindData(image: dataItem.image, title: dataItem.title, detail: dataItem.detail, icons: dataItem.icons, status: dataItem.status)
        
        cell.backgroundColor = .clear
        cell.layer.borderColor = UIColor.black.cgColor
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    // MARK: - Actions
    @objc func searchButtonTapped() {
        // TODO: Implement search action
    }
    
    @objc func bellButtonTapped() {
        // TODO: Implement bell action
    }
    
    @objc func pencilButtonTapped() {
        // TODO: Implement pencil action
    }
}
