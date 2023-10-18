//
//  ProjectBoardVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/13/23.
//

import UIKit
import SnapKit
import Then

class ProjectBoardVC: UIViewController {
    
    private let tableView: UITableView = UITableView().then {
        $0.register(ProjectBoardTableviewCell.self, forCellReuseIdentifier: "ProjectBoardCell")
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }
    
    let mockData: [(image: UIImage?, title: String, detail: String, icons: [IconModel], status: String)] = [
        (UIImage(named: "digimon"), "즐코팟 모집중!", "나의 첫 사이드 프로젝트 여기서 시작해보자!", [IconModel(image: UIImage(named: "swift") ?? UIImage()), IconModel(image: UIImage(named: "javascript") ?? UIImage())], "모집 중"),
        (UIImage(named: "pokemon"), "포켓몬 마스터 모집중!", "피카츄 라이츄 파이리 꼬북이 버터풀 야도란 피존투 또가스", [IconModel(image: UIImage(named: "python") ?? UIImage())], "모집 완료"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        
        view.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .black
    }
}

// MARK: - TableView DataSource & Delegate
extension ProjectBoardVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectBoardCell", for: indexPath) as! ProjectBoardTableviewCell
        let dataItem = mockData[indexPath.row]
        cell.titleImageView.image = dataItem.image
        cell.titleLabel.text = dataItem.title
        cell.subheadingLabel.text = dataItem.detail
        cell.icons = dataItem.icons
        cell.recruitmentLabelCheck(image: dataItem.image, title: dataItem.title, detail: dataItem.detail, icons: dataItem.icons, status: dataItem.status)
        
        cell.backgroundColor = .clear
        cell.layer.borderColor = UIColor.black.cgColor
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

// MARK: - Actions & Event Handlers (추후에 분리)
extension ProjectBoardVC {
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

// MARK: - UI Setup
private extension ProjectBoardVC {
    func setupNavigationBar() {
        let customTitleLabel = UILabel().then {
            $0.text = "프로젝트 게시판"
            $0.font = UIFont.boldSystemFont(ofSize: 24)
            $0.textColor = .black
        }

        let customTitleBarItem = UIBarButtonItem(customView: customTitleLabel)
        navigationItem.leftBarButtonItem = customTitleBarItem
        
        let searchButtonView = UIButton(type: .system).then {
            $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            $0.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        }

        let bellButtonView = UIButton(type: .system).then {
            $0.setImage(UIImage(systemName: "bell"), for: .normal)
            $0.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        }

        let pencilButtonView = UIButton(type: .system).then {
            $0.setImage(UIImage(systemName: "pencil"), for: .normal)
            $0.addTarget(self, action: #selector(pencilButtonTapped), for: .touchUpInside)
        }

        let stackView = UIStackView(arrangedSubviews: [searchButtonView, bellButtonView, pencilButtonView]).then {
            $0.axis = .horizontal
            $0.spacing = 10
        }

        let stackBarButton = UIBarButtonItem(customView: stackView)
        navigationItem.rightBarButtonItem = stackBarButton
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
