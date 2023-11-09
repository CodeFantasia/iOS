//
//
//  MyProjectVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/13/23.

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import Firebase

class MyProjectVC: UITableViewController {
    
    var projectDataArray: [Project] = []
    
    private lazy var emptyView: UIStackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: .spacing, left: 20, bottom: 20, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.spacing = .spacing
    }

    let emptyButton = UIHoverButton().then {
        $0.primaryColorConfigure(title: "새글작성")
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.buttonTitle
        $0.layer.cornerRadius = .cornerRadius
        $0.layer.shadowColor = UIColor(hexCode: "#000000").cgColor
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 4 / UIScreen.main.scale
        $0.layer.masksToBounds = false
        $0.addTarget(self, action: #selector(emptyButtonTapped), for: .touchUpInside)
    }
    
    let emptyTitleLabel = UILabel().then {
        $0.text = "작성된 글이 없습니다."
        $0.textAlignment = .center
        $0.font = .title
    }
    
    let emptySubtitleLabel = UILabel().then {
        $0.text = """
                  아래의 버튼을 눌러 글을 작성하고
                  팀원을 모집하세요!
                  """
        $0.font = .subTitle
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    let barTitle = UILabel().then {
        $0.text = "내 프로젝트"
        $0.font = UIFont.title
        $0.textColor = .black
    }
    
    private let viewModel: MyProjectViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MyProjectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData() // 데이터를 새로 고치는 메서드를 호출합니다.
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationbarTitle()
        ifEmptyViewLayout()
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: .spacing)
        tableView.separatorInsetReference = .fromAutomaticInsets
        tableView.separatorColor = .black
        tableView.register(MyProjectTableViewCell.self, forCellReuseIdentifier: MyProjectTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MyProjectVC {
    
    private func bind() {
        // 이 부분은 그대로 유지
        let inputs = MyProjectViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable()
        )
        let outputs = viewModel.transform(input: inputs)

        // outputs에서 projectDataFetched를 구독합니다.
        // Observable 배열을 받기 때문에 각 프로젝트를 배열에 추가하는 대신,
        // projectDataArray에 할당합니다.
        viewModel.projectDataFetched
            .withUnretained(self)
            .subscribe(onNext: { owner, projects in
                DispatchQueue.main.async {
                    owner.projectDataArray = projects // 배열 전체를 할당합니다.
                    owner.tableView.reloadData() // 테이블 뷰를 새로 고칩니다.
                    if owner.projectDataArray.isEmpty {
                        owner.showEmptyView()
                    } else {
                        owner.hideEmptyView()
                    }
                }
            })
            .disposed(by: disposeBag)
    }

}

extension MyProjectVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if projectDataArray.isEmpty {
            return 0
        } else {
            return projectDataArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProjectTableViewCell.identifier, for: indexPath) as? MyProjectTableViewCell else { return UITableViewCell() }
        let project = projectDataArray[indexPath.row]
        cell.backgroundColor = UIColor.backgroundColor
        cell.projectTitle.text = project.projectTitle
        cell.projectDescription.text = project.projectDescription
        DispatchQueue.main.async {
            cell.projectImage.kf.setImage(with: URL(string: project.imageUrl ?? ""))
        }
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let enddate = project.projectEndDate
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: currentDate, to: enddate)
        if let days = components.day {
            if days > 0 {
                cell.dateLabel.text = "D-\(days)"
            } else if days == 0 {
                cell.dateLabel.text = "D-day"
            } else {
                cell.dateLabel.text = "종료"
            }
        } else {
    }
        cell.dateView.backgroundColor = UIColor.buttonPrimaryColor
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projectDataArray[indexPath.row]
        let projectId = project.projectID.uuidString
        let moveDetail = ProjectDetailNoticeBoardViewController(viewModel: ProjectDetailNoticeBoardViewModel(projectRepository: ProjectRepository(firebaseBaseManager: FireBaseManager()), projectId: projectId))
        self.navigationController?.pushViewController(moveDetail, animated: true)
    }
}

extension MyProjectVC {
    
    func ifEmptyViewLayout() {
        view.addSubview(emptyView)
        [emptyTitleLabel,
         emptySubtitleLabel,
         emptyButton
        ].forEach {
            emptyView.addArrangedSubview($0)
        }
        emptyView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func emptyButtonTapped() {
        let newProject = NewPageViewController(data: nil)
        newProject.modalPresentationStyle = .fullScreen
        self.present(newProject, animated: true)
    }
    
    func navigationbarTitle() {
        let barTitleItem = UIBarButtonItem(customView: barTitle)
        navigationItem.leftBarButtonItem = barTitleItem
    }
    
    func showEmptyView() {
        emptyView.isHidden = false
    }
    
    func hideEmptyView() {
        emptyView.isHidden = true
    }
    
}

