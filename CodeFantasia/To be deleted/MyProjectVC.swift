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
    
    private var projectDataArray: [Project] = []
    
    let emptyButton = UIButton().then {
        $0.primaryColorConfigure(title: "새글작성")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationbarTitle()
        ifEmpty()
        ifEmptyViewLayout()
        
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.separatorStyle = .none
        tableView.register(MyProjectTableViewCell.self, forCellReuseIdentifier: MyProjectTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MyProjectVC {
    private func bind() {
        let inputs = MyProjectViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable()
        )
        let outputs = viewModel.transform(input: inputs)
        
        outputs.projectDataFetched
            .withUnretained(self)
            .subscribe(onNext: { owner, project in
                DispatchQueue.main.async {
                    owner.projectDataArray.append(project)
                    self.tableView.reloadData()
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
        cell.projectSubtitle.text = project.projecSubtitle
        cell.dateLabel.text = "D-\(String(describing: project.projectDuration))"
        cell.projectImage.kf.setImage(with: URL(string: project.imageUrl ?? ""))
        cell.dateView.backgroundColor = UIColor.buttonPrimaryColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moveDetail = ProjectDetailNoticeBoardViewController(viewModel: ProjectDetailNoticeBoardViewModel(projectRepository: ProjectRepository(firebaseBaseManager: FireBaseManager()), projectId: viewModel.projectId))
        self.navigationController?.pushViewController(moveDetail, animated: true)
    }
}

extension MyProjectVC {

    func ifEmpty() {
        if projectDataArray.isEmpty {
            tableView.backgroundView = emptyTitleLabel
            tableView.backgroundView = emptySubtitleLabel
            tableView.backgroundView = emptyButton
        } else {
            tableView.backgroundView = nil
        }
    }
    
    func ifEmptyViewLayout() {
        view.addSubview(emptyTitleLabel)
        view.addSubview(emptySubtitleLabel)
        view.addSubview(emptyButton)

        emptyTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(200)
        }
        emptySubtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyTitleLabel.snp.bottom).offset(20)
        }
        emptyButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptySubtitleLabel.snp.bottom).offset(20)
            $0.width.equalTo(200)
        }
    }
    
    @objc func emptyButtonTapped() {
        let newProject = NewPageViewController()
        newProject.modalPresentationStyle = .fullScreen
        self.present(newProject, animated: true)
    }
    
    func navigationbarTitle() {
        let barTitleItem = UIBarButtonItem(customView: barTitle)
        navigationItem.leftBarButtonItem = barTitleItem
    }
}
