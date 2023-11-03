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
    
    private let refreshControl = UIRefreshControl()
    private let projectRepository: ProjectRepositoryProtocol = ProjectRepository(firebaseBaseManager: FireBaseManager())
    private var projectsData: [(imageURL: URL?, title: String, detail: String, icons: [IconModel], status: String, projectID: UUID)] = []
    private var bag = DisposeBag()
    
    
    private func fetchDataFromFirebase() {
        projectRepository.readAll()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] projects in
                self?.projectsData = projects.map { project in
                    let imageURL = URL(string: project.imageUrl ?? "")
                    let statusString = project.recruitingStatus ?? false ? "모집 중" : "모집 완료"
                    let icons: [IconModel] = project.techStack.map { tech in
                        return IconModel(image: UIImage(named: tech.techForCategory(.frontendDevelopment)?.first ?? "") ?? UIImage())
                    }

                    return (imageURL, project.projectTitle ?? "", project.projecSubtitle ?? "", icons, statusString, project.projectID)
                }
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }, onFailure: { error in
                print("Error fetching data: \(error)")
                self.refreshControl.endRefreshing()
            })
            .disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        self.fetchDataFromFirebase()
        
        setupNavigationBar()
        setupTableView()
        
        view.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc private func handleRefresh() {
        fetchDataFromFirebase()
        refreshControl.endRefreshing()
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
        
        if let imageURL = dataItem.imageURL {
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.titleImageView.image = image
                    }
                }
            }.resume()
        }
        
        cell.titleLabel.text = dataItem.title
        cell.subheadingLabel.text = dataItem.detail
        cell.icons = dataItem.icons
        cell.recruitmentLabelCheck(imageURL: dataItem.imageURL, title: dataItem.title, detail: dataItem.detail, icons: dataItem.icons, status: dataItem.status)
        
        cell.backgroundColor = .clear
        cell.layer.borderColor = UIColor.black.cgColor
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 10
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedProject = projectsData[indexPath.row]
        
        let projectId = selectedProject.5.uuidString
        
        let viewModel = ProjectDetailNoticeBoardViewModel(projectRepository: projectRepository, projectId: projectId)
        
        let detailVC = ProjectDetailNoticeBoardViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: - Actions & Event Handlers (추후에 분리)
extension ProjectBoardVC {
    @objc func searchButtonTapped() {
        _ = projectsData.map { (image: $0.0, title: $0.1, detail: $0.2, icons: $0.3, status: $0.4) }
        let searchVC = ProjectSearchViewVC(mockData: projectsData)
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
//    @objc func bellButtonTapped() {
//        // TODO: Implement bell action
//    }
    
    @objc func pencilButtonTapped() {
        let newPageViewController = NewPageViewController()
        newPageViewController.modalPresentationStyle = .fullScreen
        present(newPageViewController, animated: true, completion: nil)
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
        
//        let bellButtonView = UIButton(type: .system).then {
//            $0.setImage(UIImage(systemName: "bell"), for: .normal)
//            $0.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
//        }
        
        let pencilButtonView = UIButton(type: .system).then {
            $0.setImage(UIImage(systemName: "pencil"), for: .normal)
            $0.addTarget(self, action: #selector(pencilButtonTapped), for: .touchUpInside)
        }
        
        let stackView = UIStackView(arrangedSubviews: [searchButtonView/*, bellButtonView*/, pencilButtonView]).then {
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
