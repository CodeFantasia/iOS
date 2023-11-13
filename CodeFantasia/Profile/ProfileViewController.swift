//
//  ProfileViewController.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/12.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {

    private lazy var scrollView = UIScrollView()
    
    private lazy var barTitle = UILabel().then {
        $0.text = "내 프로필"
        $0.font = UIFont.title
        $0.textColor = .black
    }

    private lazy var produceView = UIView().then {
        $0.layer.masksToBounds = false
        $0.backgroundColor = .white
    }

    private lazy var profileImage = UIImageView().then {
        $0.backgroundColor = .gray
    }

    private lazy var nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.subTitle
    }
    private lazy var produceStackView: UIStackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .horizontal
        $0.spacing = .spacing
    }
    
    private lazy var followingUserBtn = UIButton().then {
        $0.setTitle("팔로잉\n0", for: .normal)
        $0.titleLabel?.lineBreakMode = .byWordWrapping
        $0.titleLabel?.textAlignment = .center
        $0.backgroundColor = UIColor.white
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private lazy var followersUserBtn = UIButton().then {
        $0.setTitle("팔로워\n0",for: .normal)
        $0.titleLabel?.lineBreakMode = .byWordWrapping
        $0.titleLabel?.textAlignment = .center
        $0.backgroundColor = UIColor.white
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.setTitleColor(.black, for: .normal)
    }
    
    
    private lazy var followersLabel = UILabel().then {
        $0.font = UIFont.smallTitle
    }
    private lazy var followingLabel = UILabel().then {
        $0.font = UIFont.smallTitle
    }

    private lazy var produceLabel = UILabel().then {
        $0.text = "소개"
        $0.font = UIFont.body
    }

    private lazy var produceContent = UILabel().then {
        $0.numberOfLines = 3
        $0.font = UIFont.systemFont(ofSize: .content)
    }

    private lazy var infoLabel = UILabel().then {
        $0.text = "나의 스펙 정보"
        $0.font = UIFont.subTitle
    }

    private lazy var infoUnderline = UIView().then {
        $0.backgroundColor = UIColor.black
    }
    private lazy var introUnderline = UIView().then {
        $0.backgroundColor = UIColor.systemGray
    }
    
    private lazy var techUnderline = UIView().then {
        $0.backgroundColor = UIColor.systemGray
    }
    
    private lazy var urlUnderline = UIView().then {
        $0.backgroundColor = UIColor.systemGray
    }
    
    private lazy var interestUnderline = UIView().then {
        $0.backgroundColor = UIColor.black
    }
    
    private lazy var techTitleLabel = UILabel().then {
        $0.text = "주요 사용 언어 및 기술 스택"
        $0.font = UIFont.body
    }

    private lazy var techLabel = UILabel().then {
        $0.text = "Swift"
        $0.font = UIFont.systemFont(ofSize: .content)
    }

    private lazy var urlTitleLabel = UILabel().then {
        $0.text = "포트폴리오"
        $0.font = UIFont.body
    }

    private lazy var urlLabel = UILabel().then {
        $0.text = "www.github.com"
        $0.font = UIFont.systemFont(ofSize: .content)
    }

    private lazy var interestTitleLabel = UILabel().then {
        $0.text = "관심 분야"
        $0.font = UIFont.body
    }

    private lazy var interestLabel = UILabel().then {
        $0.text = "앱개발"
        $0.font = UIFont.systemFont(ofSize: .content)
    }

    private lazy var editButton = UIHoverButton().then {
        $0.backgroundColor = UIColor.buttonPrimaryColor
        $0.setTitle("프로필 수정", for: .normal)
        $0.titleLabel?.font = UIFont.buttonTitle
        $0.layer.cornerRadius = .cornerRadius
        $0.layer.shadowColor = UIColor(hexCode: "#000000").cgColor
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 4 / UIScreen.main.scale
        $0.layer.masksToBounds = false
    }

    private lazy var logoutButton =  UIHoverButton().then {
        $0.backgroundColor = UIColor.buttonSecondaryColor
        $0.setTitle("로그아웃", for: .normal)
        $0.titleLabel?.font = UIFont.buttonTitle
        $0.layer.cornerRadius = .cornerRadius
        $0.layer.shadowColor = UIColor(hexCode: "#000000").cgColor
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 4 / UIScreen.main.scale
        $0.layer.masksToBounds = false
    }
    private lazy var followButton = UIHoverButton().then {
        $0.backgroundColor = UIColor.buttonPrimaryColor
        $0.setTitle("팔로우 하기", for: .normal)
        $0.titleLabel?.font = UIFont.buttonTitle
        $0.layer.cornerRadius = .cornerRadius
        $0.layer.shadowColor = UIColor(hexCode: "#000000").cgColor
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 4 / UIScreen.main.scale
        $0.layer.masksToBounds = false
    }
    private lazy var buttonSpacer = UIView()
    
    private lazy var withdrawSpacer = UIView()
    
    private lazy var withdrawView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private lazy var withdrawButton = UIButton().then {
        $0.setTitle("회원 탈퇴", for: .normal)
        $0.backgroundColor = UIColor.white
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    private lazy var stackView: UIStackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: .spacing, left: 20, bottom: 20, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.spacing = .spacing
    }
    private let viewModel: ProfileViewModel
    private let disposeBag = DisposeBag()
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
     //   NotificationCenter.default.addObserver(self, selector: #selector(handleFollowUpdate(_:)), name: NSNotification.Name("followUpdate"), object: nil)
        view.backgroundColor = UIColor.white
        navigationbarTitle()
        setupLayout()
    }
}

extension ProfileViewController {
    
    private func navigationbarTitle() {
        let logoImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage(named: "AppIcon_long")
            $0.widthAnchor.constraint(equalToConstant: 100).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        let logoBarItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoBarItem
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        produceView.addSubview(profileImage)
        produceView.addSubview(nicknameLabel)
        
        [produceView,
         followingUserBtn,
         followersUserBtn
        ].forEach {
            produceStackView.addArrangedSubview($0)
        }

        [ produceStackView,
          infoLabel,
          infoUnderline,
          produceLabel,
          produceContent,
          introUnderline,
          techTitleLabel,
          techLabel,
          techUnderline,
          urlTitleLabel,
          urlLabel,
          urlUnderline,
          interestTitleLabel,
          interestLabel,
          interestUnderline,
          followButton,
          editButton,
          logoutButton,
          buttonSpacer,
          withdrawView
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [withdrawSpacer,
         withdrawButton
        ].forEach {
            withdrawView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        produceView.snp.makeConstraints {
            $0.height.equalTo(130)
            $0.width.equalTo(130)
        }
        profileImage.snp.makeConstraints {
            $0.centerX.equalTo(produceView)
            $0.width.height.equalTo(100)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(16)
            $0.centerX.equalTo(produceView)
        }
        infoUnderline.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        introUnderline.snp.makeConstraints {
            $0.height.equalTo(infoUnderline)
        }
        techUnderline .snp.makeConstraints {
            $0.height.equalTo(infoUnderline)
        }
        urlUnderline.snp.makeConstraints {
            $0.height.equalTo(infoUnderline)
        }
        interestUnderline.snp.makeConstraints {
            $0.height.equalTo(infoUnderline)
        }
        withdrawSpacer.snp.makeConstraints {
            $0.width.equalTo(270)
        }
        withdrawButton.snp.makeConstraints {
            $0.height.equalTo(16)
        }
    }
}

//MARK: - binding
extension ProfileViewController {
    private func bind() {
        let inputs = ProfileViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable(),
            profileEditTapped: editButton.rx.tap.asDriver(),
            logoutTapped: logoutButton.rx.tap.asDriver(),
            withdrawTapped: withdrawButton.rx.tap.asDriver(),
            followTapped: followButton.rx.tap.asDriver()
        )
        let outputs = viewModel.transform(input: inputs)

        outputs.userDataFetched
            .withUnretained(self)
            .subscribe(onNext: { owner, user in
                DispatchQueue.main.async {
                    owner.profileImage.kf.setImage(with: URL(string: user.profileImageURL ?? ""))  { result in
                        switch result {
                        case .success(_):
                            owner.profileImage.contentMode = .scaleAspectFill
                            owner.profileImage.clipsToBounds = true
                            owner.profileImage.layer.cornerRadius = 50
                        case .failure(_):
                            owner.alertViewAlert(title: "오류", message: "이미지 다운로드에 오류가 발생했습니다.", cancelText: nil)
                        }
                    }
                   owner.followersUserBtn.setTitle("팔로워\n\(user.followers?.count ?? 0)", for: .normal)
                    owner.followingUserBtn.setTitle("팔로잉\n\(user.following?.count ?? 0)", for: .normal)
                    owner.techLabel.text = user.techStack.joined(separator: ", ")
                    owner.interestLabel.text = user.areasOfInterest.joined(separator: ", ")
                    owner.nicknameLabel.text = user.nickname
                    owner.produceContent.text = user.selfIntroduction ?? ""
                    owner.urlLabel.text = user.portfolioURL ?? ""
                }
            }, onError: { [weak self] error in
                DispatchQueue.main.async {
                    self?.alertViewActionSheet(
                        title: "작성된 프로필이 없습니다",
                        message: "프로필 수정 버튼을 클릭하여 프로필을 등록해주세요.",
                        acceptText: "확인",
                        cancelText: nil
                    )
                }
            })
            .disposed(by: disposeBag)

        outputs.userAuthConfirmed
            .drive (onNext: { [weak self] _ in
                guard let self = self, let user = viewModel.userProfile, let currentAuthor = Auth.auth().currentUser?.uid else {
                    return
                }
                if user.userID == currentAuthor {
                    self.followButton.isHidden = true
                } else {
                    self.editButton.isHidden = true
                    self.logoutButton.isHidden = true
                    self.buttonSpacer.isHidden = true
                    self.withdrawView.isHidden = true
                    self.infoLabel.text = "\(user.nickname)님의 프로필 정보"
                }
            })
            .disposed(by: disposeBag)
        
        outputs.profileEditDidTap
            .drive(with: self, onNext: { owner, user in
                let profileViewController = UserDataManageController(data: owner.viewModel.userProfile)
                owner.present(profileViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        outputs.logoutDidTap
            .drive(with: self, onNext: { owner, _ in
                owner.alertViewAlert(title: "로그아웃", message: "로그아웃 하시겠습니까?", cancelText: "아니요", acceptCompletion:  {
                    owner.viewModel.logoutComplete.on(.next(()))
                })
            })
            .disposed(by: disposeBag)

        outputs.withdrawDidTap
            .drive(with: self, onNext: { owner, current in
                print("Withdraw button tapped!")
                if let user = Auth.auth().currentUser {
                    owner.alertViewAlert(title: "회원 탈퇴", message: """
                                                                       정말 탈퇴 하시겠습니까?
                                                                       기존의 정보들이 모두 삭제됩니다.
                                                                       """, cancelText: "아니요", acceptCompletion:  {
                        self.deleteEmail()
                        user.delete { [self] error in
                            if let error = error {
                                owner.alertViewAlert(title: "로그인 정보가 일치하지 않습니다", message: """
                                                                               다시 로그인 후 탈퇴해주세요.
                                                                               확인 버튼을 누르면 자동으로 로그아웃 됩니다.
                                                                               """, cancelText: nil, acceptCompletion:  {
                                    owner.viewModel.logoutComplete.on(.next(()))
                                })
                            } else {
                                owner.viewModel.deleteComplete.on(.next(()))
                                self.alertViewAlert(title: "탈퇴 완료", message: """
                                                                                       탈퇴가 완료 되었습니다.
                                                                                       서비스를 이용하려면 다시 가입해주세요.
                                                                                       로그인 화면으로 돌아갑니다.
                                                                                       """, cancelText: nil, acceptCompletion:  {
                                    DispatchQueue.main.async {
                                        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                                            fatalError("could not get scene delegate ")
                                        }
                                        sceneDelegate.window?.rootViewController = TabBarController()
                                    }
                                })
                            }
                        }
                    })
                }
            })
            .disposed(by: disposeBag)
        
        outputs.followDidTap
            .withLatestFrom(viewModel.isFollowing.asDriver(onErrorJustReturn: false))
            .drive(onNext: { [weak self] isFollowing in
                DispatchQueue.main.async {
                    guard let self = self else { return }

                    if isFollowing {
                        self.alertViewAlert(title: "언팔로우 하시겠습니까?", message: nil, cancelText: "아니오", acceptCompletion: {
                            self.viewModel.unfollowComplete.on(.next(()))
                            self.alertViewAlert(title: "언팔로우 되었습니다.", message: nil, cancelText: nil)
                        })
                    } else {
                        self.alertViewAlert(title: "팔로우 하시겠습니까?", message: nil, cancelText: "아니오", acceptCompletion: {
                            self.viewModel.followComplete.on(.next(()))
                            self.alertViewAlert(title: "팔로우 되었습니다.", message: nil, cancelText: nil)
                        })
                    }
                }
            })
            .disposed(by: disposeBag)
        viewModel.followUpdate
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] userArray in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    userArray.forEach { userProfile in
                        self.followersUserBtn.setTitle("팔로워\n\(userProfile.followers?.count ?? 0)", for: .normal)
                        self.followingUserBtn.setTitle("팔로잉\n\(userProfile.following?.count ?? 0)", for: .normal)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isFollowing
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isFollowing in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    print("isFollowing value: \(isFollowing)")
                    let title = isFollowing ? "언팔로우" : "팔로우"
                    self.followButton.setTitle(title, for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController {
    func deleteEmail() {
        guard let email = getCurrentUserEmail() else { return }
        AuthManager().deleteAccountWithEmail(email) { error in
            if error == nil {
                print("이메일 지우기 성공!")
            } else {
                print("이메일 지우기 실패!")
            }
        }
    }
    
    func getCurrentUserEmail() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.email
        } else {
            return nil
        }
    }
}

