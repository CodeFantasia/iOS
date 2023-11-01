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
        return projectDataArray.count
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
        cell.dateLabel.text = "D-17"
        cell.projectImage.kf.setImage(with: URL(string: project.imageUrl ?? ""))
        cell.dateView.backgroundColor = UIColor.buttonPrimaryColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moveDetail = ProjectDetailNoticeBoardViewController(viewModel: ProjectDetailNoticeBoardViewModel(projectRepository: ProjectRepository(firebaseBaseManager: FireBaseManager()), projectId: viewModel.projectId))
        self.navigationController?.pushViewController(moveDetail, animated: true)
    }
    
    func navigationbarTitle() {
        let barTitleItem = UIBarButtonItem(customView: barTitle)
        navigationItem.leftBarButtonItem = barTitleItem
    }
}
