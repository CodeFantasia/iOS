//
//  ProjectBoardVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/13/23.
//

import UIKit
import SnapKit
import Then
import RxSwift

class ProjectBoardVC: UIViewController {
    
    private let tableView: UITableView = UITableView().then {
        $0.register(ProjectBoardTableviewCell.self, forCellReuseIdentifier: "ProjectBoardCell")
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }
    
    private let projectRepository: ProjectRepositoryProtocol = ProjectRepository(firebaseBaseManager: FireBaseManager())
    private var projectsData: [(image: UIImage?, title: String, detail: String, icons: [IconModel], status: String)] = []
    private var bag = DisposeBag()

    private func fetchDataFromFirebase() {
        projectRepository.readAll()
          .observe(on: MainScheduler.instance)
          .subscribe(onSuccess: { [weak self] projects in
            self?.projectsData = projects.map { project in
              let image = UIImage(named: project.imageUrl ?? "")
              let statusString = project.recruitingStatus ?? false ? "모집 중" : "모집 완료"
              let icons: [IconModel] = project.techStack.map { tech in
                return IconModel(image: UIImage(named: tech.techForCategory(.frontendDevelopment)?.first ?? "") ?? UIImage())
              }
              return (image, project.projectTitle ?? "", project.projecSubtitle ?? "", icons, statusString)
            }
            self?.tableView.reloadData()
          }, onFailure: { error in
            print("Error fetching data: \(error)")
          })
          .disposed(by: bag)
      }



    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchDataFromFirebase()

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
        return projectsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectBoardCell", for: indexPath) as! ProjectBoardTableviewCell
        let dataItem = projectsData[indexPath.row]
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
        let searchVC = ProjectSearchViewVC(mockData: projectsData)
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func bellButtonTapped() {
        // TODO: Implement bell action
    }
    
    @objc func pencilButtonTapped() {
        let newPageViewController = NewPageViewController()
        navigationController?.pushViewController(newPageViewController, animated: true)
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
