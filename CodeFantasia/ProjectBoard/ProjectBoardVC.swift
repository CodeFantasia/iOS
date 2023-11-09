//
// ProjectBoardVC.swift
// CodeFantasia
//
// Created by 서영덕 on 10/13/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import Firebase
import FirebaseAuth

class ProjectBoardVC: UIViewController {
    var blockIds: [String]?
    var writerID: String?
    private let tableView: UITableView = UITableView().then {
        $0.register(ProjectBoardTableviewCell.self, forCellReuseIdentifier: "ProjectBoardCell")
        $0.separatorStyle = .singleLine // 이 부분을 .none에서 .singleLine으로 변경합니다.
        $0.separatorColor = UIColor.gray // 구분선의 색상을 설정합니다.
        $0.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) // 구분선의 여백을 설정합니다.
        $0.backgroundColor = .clear
    }
    
    private let refreshControl = UIRefreshControl()
    private let projectRepository: ProjectRepositoryProtocol = ProjectRepository(firebaseBaseManager: FireBaseManager())
    private var projectsData: [(imageURL: URL?, title: String, detail: String, icons: [IconModel], status: String, projectID: UUID)] = []
    private var bag = DisposeBag()
    
    private func fetchDataFromFirebase() {
        ////////////////////
        if let currentUser = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            // Firestore에서 현재 사용자의 문서 가져오기
            let userDocumentReference = db.collection("User").document(currentUser)
            userDocumentReference.getDocument { (snapshot, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                } else if let snapshot = snapshot, snapshot.exists {
                    // 문서가 존재하면 필드 값을 가져올 수 있습니다.
                    if let data = snapshot.data(),
                       let blockIDs = data["blockIDs"] as? [String] {
                        // blockIDs 필드가 배열인 경우, [String]로 타입 캐스트
                        print("blockIDs: \(blockIDs)")
                        self.blockIds = blockIDs
                        // blockIDs 값을 projectRepository.readAll 함수로 전달
                    } else {
                        print("blockIDs field not found or has the wrong type")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        ///
        ///
        /////////////
        projectRepository.readBlockAll(blockIDs: blockIds ?? [])//현재 로그인한 유저의 블록아이디 문자열 배열
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] projects in
                self?.projectsData = projects.map { project in
                    let imageURL = URL(string: project.imageUrl ?? "")
                    let statusString = project.recruitingStatus ?? false ? "모집 중" : "모집 완료"
                    let icons: [IconModel] = project.techStack.flatMap { techStack in
                        techStack.technologies.map { techName in
                            return IconModel(image: UIImage(named: techName) ?? UIImage())
                        }
                    }
                    return (imageURL, project.projectTitle ?? "", project.projectDescription ?? "", icons, statusString, project.projectID)
                }
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }, onFailure: { [weak self] error in
                print("Error fetching data: \(error)")
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: bag)
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.fetchDataFromFirebase()
        setupNavigationBar()
        setupTableView()
        setupFloatingActionButton()
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
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
        cell.contentView.backgroundColor = .clear
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
        print(projectId)
        print(selectedProject.projectID)
    }
}

// MARK: - Actions & Event Handlers (추후에 분리)

extension ProjectBoardVC {
    @objc func searchButtonTapped() {
        _ = projectsData.map { (image: $0.0, title: $0.1, detail: $0.2, icons: $0.3, status: $0.4) }
        let searchVC = ProjectSearchViewVC(mockData: projectsData)
        navigationController?.pushViewController(searchVC, animated: true)
    }
    //  @objc func bellButtonTapped() {
    //    // TODO: Implement bell action
    //  }
    @objc func plusButtonTapped() {
        let newPageVC = NewPageViewController(data: nil)
        newPageVC.modalPresentationStyle = .fullScreen
        present(newPageVC, animated: true, completion: nil)
    }
}

// MARK: - UI Setup

private extension ProjectBoardVC {
    func setupNavigationBar() {
        let logoImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage(named: "AppIcon_long") // 에셋에서 "AppIcon" 이름의 이미지를 사용합니다.
            $0.widthAnchor.constraint(equalToConstant: 100).isActive = true // 로고 이미지의 너비를 설정합니다.
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true // 로고 이미지의 높이를 설정합니다.
        }
        
        let logoBarItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoBarItem
        let searchButtonView = UIButton(type: .system).then {
            $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            $0.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        }
        //    let bellButtonView = UIButton(type: .system).then {
        //      $0.setImage(UIImage(systemName: "bell"), for: .normal)
        //      $0.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        //    }
        //    let pencilButtonView = UIButton(type: .system).then {
        //      $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        //      $0.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        //    }
        let stackView = UIStackView(arrangedSubviews: [searchButtonView/*, bellButtonView, pencilButtonView*/]).then {
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
    
    func setupFloatingActionButton() {
        let plusButtonView = UIButton().then {
            $0.setImage(UIImage(systemName: "plus"), for: .normal)
            $0.tintColor = .white
            $0.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
            $0.primaryColorConfigure(title: "")
            $0.layer.cornerRadius = 30
            $0.backgroundColor = .black
        }
        
        view.addSubview(plusButtonView)
        plusButtonView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(60)
        }
    }
}
