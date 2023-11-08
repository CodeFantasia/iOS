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
        $0.layer.cornerRadius = .cornerRadius
        $0.layer.shadowColor = UIColor(hexCode: "#000000").cgColor
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 4 / UIScreen.main.scale
        $0.layer.masksToBounds = false
        $0.backgroundColor = .white
    }

    private lazy var profileImage = UIImageView().then {
        $0.layer.cornerRadius = 50
        $0.backgroundColor = .gray
    }

    private lazy var nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.subTitle
    }

    private lazy var produceLabel = UILabel().then {
        $0.text = "내 소개"
        $0.font = UIFont.subTitle
    }

    private lazy var produceContent = UILabel().then {
        $0.numberOfLines = 3
        $0.font = UIFont.body
    }

    private lazy var infoLabel = UILabel().then {
        $0.text = "나의 스펙 정보"
        $0.font = UIFont.subTitle
    }

    private lazy var infoUnderline = UIView().then {
        $0.backgroundColor = UIColor.black
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
        $0.text = "나의 포트폴리오"
        $0.font = UIFont.body
    }

    private lazy var urlLabel = UILabel().then {
        $0.text = "www.github.com"
        $0.font = UIFont.systemFont(ofSize: .content)
    }

    private lazy var interestTitleLabel = UILabel().then {
        $0.text = "나의 관심 분야"
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
        ifShowWriter()
        
        view.backgroundColor = UIColor.backgroundColor
        navigationbarTitle()
        setupLayout()
    }
}

extension ProfileViewController {

    private func navigationbarTitle() {
        let barTitleItem = UIBarButtonItem(customView: barTitle)
        navigationItem.leftBarButtonItem = barTitleItem
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        produceView.addSubview(profileImage)
        produceView.addSubview(nicknameLabel)
        produceView.addSubview(produceLabel)
        produceView.addSubview(produceContent)
        
        [ produceView,
          infoLabel,
          infoUnderline,
          techTitleLabel,
          techLabel,
          techUnderline,
          urlTitleLabel,
          urlLabel,
          urlUnderline,
          interestTitleLabel,
          interestLabel,
          interestUnderline,
          editButton,
          logoutButton].forEach {
            stackView.addArrangedSubview($0)
        }

        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        produceView.snp.makeConstraints {
            $0.height.equalTo(250)
        }
        profileImage.snp.makeConstraints {
            $0.top.equalTo(produceView.snp.top).inset(16)
            $0.leading.equalTo(produceView.snp.leading).inset(16)
            $0.width.height.equalTo(100)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage)
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
        }
        produceLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(16)
            $0.leading.equalTo(profileImage)
        }
        produceContent.snp.makeConstraints {
            $0.top.equalTo(produceLabel.snp.bottom).offset(16)
            $0.leading.equalTo(produceLabel)
        }
        infoUnderline.snp.makeConstraints {
            $0.height.equalTo(1)
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
    }
    private func ifShowWriter() {
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser?.uid
        db.collection("User").document(currentUser!).getDocument { (document, error) in
            if let document = document, document.exists {
                if var userid = document.data()?["userID"] as? String {
                    if let currentUser = self.viewModel.userProfile?.userID.uuidString {
                        if currentUser == userid {
                        } else {
                            self.logoutButton.isHidden = true
                            self.editButton.isHidden = true
                            self.barTitle.text = "작성자 프로필"
                        }
                    }
                }
            }
        }
    }
}

//MARK: - binding
extension ProfileViewController {
    private func bind() {
        let inputs = ProfileViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable(),
            profileEditTapped: editButton.rx.tap.asDriver(),
            logoutTapped: logoutButton.rx.tap.asDriver()
        )
        let outputs = viewModel.transform(input: inputs)
        
        outputs.userDataFetched
            .withUnretained(self)
            .subscribe(onNext: { owner, user in
                DispatchQueue.main.async {
                    owner.profileImage.kf.setImage(with: URL(string: user.profileImageURL ?? "")) { result in
                        switch result {
                        case .success(_):
                            owner.profileImage.roundCornersForAspectFit(radius: 50)
                        case .failure(_):
                            owner.alertViewAlert(title: "오류", message: "이미지 다운로드에 오류가 발생했습니다.", cancelText: nil)
                        }
                    }
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
        
        outputs.profileEditDidTap
            .drive (with: self, onNext: { owner, user in
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
            }
    }
