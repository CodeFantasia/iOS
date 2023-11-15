//
//  FollowViewController.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/11/15.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import Firebase

class FollowTableVC: UITableViewController {
    
    var followDataArry: [UserProfile] = []
    private let viewModel: FollowViewModel
    private let disposeBag = DisposeBag()
 
    init(viewModel: FollowViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 15)
        tableView.separatorInsetReference = .fromAutomaticInsets
        tableView.separatorColor = .gray
        tableView.register(FollowViewCell.self, forCellReuseIdentifier: FollowViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        navigationbarTitle()
    }
}

extension FollowTableVC {
    private func bind() {
        
        let inputs = FollowViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable()
        )
        let outputs = viewModel.transform(input: inputs)
        
        outputs.userDataFetched
            .withUnretained(self)
            .subscribe(onNext: { owner, user in
                owner.followDataArry = user
                owner.tableView.reloadData()
                if owner.followDataArry.isEmpty {
                } else {
                }
            }
            )
            .disposed(by: disposeBag)
        
    }
}

extension FollowTableVC {
    
    func navigationbarTitle() {
        let logoImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage(named: "AppIcon_long")
            $0.widthAnchor.constraint(equalToConstant: 100).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
}

extension FollowTableVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followDataArry.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowViewCell.identifier, for: indexPath) as? FollowViewCell else { return UITableViewCell() }
        let follow = followDataArry[indexPath.row]
        cell.backgroundColor = UIColor.backgroundColor
        DispatchQueue.main.async {
//            cell.userId = follow.userID
            cell.followName.text = follow.nickname
            cell.followTech.text = follow.techStack.joined(separator: ", ")
            cell.followImage.kf.setImage(with: URL(string: follow.profileImageURL ?? "")) { result in
                switch result {
                case .success(_):
                    cell.followImage.contentMode = .scaleToFill
                    cell.followImage.clipsToBounds = true
                    cell.followImage.layer.cornerRadius = 50
                case .failure(_):
                    self.alertViewAlert(title: "오류", message: "이미지 다운로드에 오류가 발생했습니다.", cancelText: nil)
                }
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let follow = followDataArry[indexPath.row]
        let profileViewModel = ProfileViewModel(userRepository: UserRepository(firebaseBaseManager: FireBaseManager()), userId: follow.userID ?? "")
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        present(profileViewController, animated: true)
    }
}
