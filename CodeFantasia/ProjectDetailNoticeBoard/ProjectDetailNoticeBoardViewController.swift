//
//  ProjectDetailNoticeBoardViewController.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/13.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import FirebaseAuth
import Firebase

final class ProjectDetailNoticeBoardViewController: UIViewController {
    
    var writerID: String?
    private let viewModel: ProjectDetailNoticeBoardViewModel
    private let disposeBag = DisposeBag()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    init(viewModel: ProjectDetailNoticeBoardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = .spacing
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    private lazy var projectTitleAndTeamLeaderProfileImageStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    private lazy var projectTitleLabel = UILabel().then {
        $0.text = "프로젝트"
        $0.font = .title
    }
    private lazy var projectsubTitleLabel = UILabel().then {
        $0.text = ""
        $0.font = .body
    }
    private lazy var projectTeamLeaderProfileImageButton = UIButton().then {
        $0.layer.cornerRadius = .cornerRadius
        $0.clipsToBounds = true
        $0.setImage(.defaultProfileImage, for: .normal)
    }
    private lazy var projectImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .defaultProfileImage
        $0.roundCornersForAspectFit(radius: .cornerRadius)
    }
    private lazy var techStackStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = .spacing
    }
    private lazy var techStackStackViewTitleLabel = UILabel().then {
        $0.text = "기술 및 언어"
        $0.font = .subTitle
    }
    private lazy var techStackContextView = PaddingLabel(/*inset: .init(top: 10, left: 10, bottom: 10, right: 10)*/).then {
        $0.text = """
        """
        $0.font = .body
        $0.numberOfLines = 0
    }
    private lazy var recruitmentStatusStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = .spacing
    }
    private lazy var recruitmentStatusTitleLabel = UILabel().then {
        $0.text = "모집 현황"
        $0.font = .subTitle
    }
    private lazy var recruitmentStatusContextLabel = PaddingLabel(/*inset: .init(top: 10, left: 10, bottom: 10, right: 10)*/).then {
        $0.text = """
        """
        $0.numberOfLines = 0
    }
    private lazy var projectIntroduceStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = .spacing
    }
    private lazy var projectIntroduceTitleLabel = UILabel().then {
        $0.text = "프로젝트 소개"
        $0.font = .subTitle
    }
    private lazy var projectIntroduceContextLabel = PaddingLabel(/*inset: .init(top: 10, left: 10, bottom: 10, right: 10)*/).then {
        $0.text = """
        """
        $0.numberOfLines = 0
    }
    private lazy var projectPeriodStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = .spacing
    }
    private lazy var projectPeriodTitleLabel = UILabel().then {
        $0.text = "프로젝트 기간"
        $0.font = .subTitle
    }
    private lazy var projectPeriodContextLabel = PaddingLabel(/*inset: .init(top: 10, left: 10, bottom: 10, right: 10)*/).then {
        $0.text = "\(Date().yearMonthDate) ~ \(Date().yearMonthDate)"
        $0.numberOfLines = 0
    }
    private lazy var projectMeetingTypeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = .spacing
    }
    private lazy var projectMeetingTypeTitleLabel = UILabel().then {
        $0.text = "모임 유형"
        $0.font = .subTitle
    }

    private lazy var projectMeetingTypeContextLabel = PaddingLabel(/*inset: .init(top: 10, left: 10, bottom: 10, right: 10)*/).then {
        $0.text = ""
        $0.numberOfLines = 0
    }
    private lazy var projectApplyButton = UIHoverButton().then {
        $0.setTitle("신청하기", for: .normal)
        $0.titleLabel?.font = .buttonTitle
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .buttonPrimaryColor
        $0.layer.cornerRadius = .cornerRadius
        // color
        $0.layer.shadowColor = UIColor(hexCode: "#000000").cgColor
        // x, y
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        // opacity
        $0.layer.shadowOpacity = 0.25
        // blur
        $0.layer.shadowRadius = 4 / UIScreen.main.scale
        $0.layer.masksToBounds = false

    }
    private lazy var reportButton = UIBarButtonItem(image: .reportImage, style: .plain, target: self, action: nil)
    private var menuItems: [UIAction] {
        return [
            UIAction(title: "수정하기", image: .editImage, handler: { [weak self] _ in
                self?.alertViewAlert(title: "수정", message: "프로젝트를 수정하시겠습니까?", cancelText: "아니요", acceptCompletion: {
                    let editView = NewPageViewController(data: self?.viewModel.project)
                    editView.modalPresentationStyle = .fullScreen
                    self?.present(editView, animated: true)
                })
            }),
            UIAction(title: "삭제하기", image: .projectDeleteImage, attributes: .destructive, handler: { [weak self] _ in
                self?.alertViewAlert(title: "삭제", message: "프로젝트를 삭제하시겠습니까?", cancelText: "아니요", acceptCompletion: {
                    self?.viewModel.projectDeleteComplete.on(.next(()))
                    self?.navigationController?.popViewController(animated: true)
                })
            })
        ]
    }
    private lazy var editMenu = UIMenu(title: "",image: nil, identifier: nil, options: [], children: menuItems)
}

//MARK: - View Life Cycle
extension ProjectDetailNoticeBoardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        activityIndicator.startAnimating()
    }
}

//MARK: - UI Setting
extension ProjectDetailNoticeBoardViewController {
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        [projectTitleAndTeamLeaderProfileImageStackView, projectsubTitleLabel, projectImageView, techStackStackView, recruitmentStatusStackView, projectIntroduceStackView, projectPeriodStackView, projectMeetingTypeStackView, projectApplyButton].forEach {
            contentStackView.addArrangedSubview($0)
        }
        [projectTitleLabel, projectTeamLeaderProfileImageButton].forEach {
            projectTitleAndTeamLeaderProfileImageStackView.addArrangedSubview($0)
        }
        [techStackStackViewTitleLabel, techStackContextView].forEach {
            techStackStackView.addArrangedSubview($0)
        }
        [recruitmentStatusTitleLabel, recruitmentStatusContextLabel].forEach {
            recruitmentStatusStackView.addArrangedSubview($0)
        }
        [projectIntroduceTitleLabel, projectIntroduceContextLabel].forEach {
            projectIntroduceStackView.addArrangedSubview($0)
        }
        [projectPeriodTitleLabel, projectPeriodContextLabel].forEach {
            projectPeriodStackView.addArrangedSubview($0)
        }
        [projectMeetingTypeTitleLabel, projectMeetingTypeContextLabel].forEach {
            projectMeetingTypeStackView.addArrangedSubview($0)
        }

        techStackContextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(CGFloat.minimumFormHeight)
        }
        recruitmentStatusContextLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(CGFloat.minimumFormHeight)
        }
        projectIntroduceContextLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(CGFloat.minimumFormHeight)
        }
        projectPeriodContextLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(CGFloat.minimumFormHeight)
        }
        projectMeetingTypeContextLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(CGFloat.minimumFormHeight)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        projectTeamLeaderProfileImageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        projectImageView.snp.makeConstraints { make in
            make.height.equalTo(243)
        }
    }
}

//MARK: - binding
extension ProjectDetailNoticeBoardViewController {
    private func bind() {
        let inputs = ProjectDetailNoticeBoardViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable(),
            profileImageTapped: projectTeamLeaderProfileImageButton.rx.tap.asDriver(),
            projectApplyButtonTapped: projectApplyButton.rx.tap.asDriver(),
            projectReportButtonTapped: reportButton.rx.tap.asDriver()
        )
        let outputs = viewModel.transform(input: inputs)
        
        outputs.projectDataFetched
            .withUnretained(self)
            .subscribe(onNext: { owner, project in
                DispatchQueue.main.async {
                    owner.activityIndicator.stopAnimating()
                    owner.techStackContextView.text = project.platform.reduce("", {$0 + $1.rawValue + "\n"})
                    owner.projectImageView.kf.setImage(with: URL(string: project.imageUrl ?? "")) { result in
                        switch result {
                        case .success(_):
                            owner.projectImageView.roundCornersForAspectFit(radius: .cornerRadius)
                        case .failure(_):
                            owner.alertViewAlert(title: "오류 발생", message: "이미지 다운로드에 오류가 발생했습니다.", cancelText: nil)
                        }
                    }
                    owner.projectTitleLabel.text = project.projectTitle ?? ""
                    owner.recruitmentStatusContextLabel.text = project.recruitmentField ?? ""
                    owner.projectIntroduceContextLabel.text = project.projectDescription ?? ""
                    owner.projectMeetingTypeContextLabel.text = project.meetingType ?? ""
                    owner.projectPeriodContextLabel.text = project.projectDuration ?? ""
                    owner.writerID = project.writerID ?? ""
                }
            }, onError: { [weak self] error in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.alertViewActionSheet(
                        title: "이미 삭제된 게시물입니다.",
                        message: "",
                        acceptText: "확인",
                        cancelText: nil,
                        acceptCompletion: {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    )
                }
            })
            .disposed(by: disposeBag)
        
        outputs.projectApplyButtonDidTap
            .drive(with: self, onNext: { owner, applyMethod in
                owner.alertViewAlert(title: "신청", message: applyMethod ?? "", cancelText: nil, acceptCompletion:  {
                    owner.viewModel.projectApplyComplete.on(.next(()))
                })
            })
            .disposed(by: disposeBag)
        
        outputs.projectLeaderProfileDidTap
            .drive(with: self, onNext: { owner, leaderUserId in
                if let leaderUserId {
                    let profileViewController = ProfileViewController(viewModel: ProfileViewModel(userRepository: UserRepository(firebaseBaseManager: FireBaseManager()), userId: String(leaderUserId)))
                    owner.present(profileViewController, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        outputs.projectReportButtonDidTap
            .drive(with: self, onNext: { owner, _ in
                owner.alertViewAlert(title: "신고", message: "프로젝트를 신고하시겠습니까?", cancelText: "아니요", acceptCompletion: {
                    // 사용자에게 신고 성공 메시지 표시
                    let alert = UIAlertController(title: "신고 완료", message: "해당 게시글을 신고하였습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        let db = Firestore.firestore()
                        let currentUser = Auth.auth().currentUser?.uid
                        db.collection("User").document(currentUser!).getDocument { (document, error) in
                        if let document = document, document.exists {
                        if var blockIDs = document.data()?["blockIDs"] as? [String] {
                        // blockIDs 필드가 이미 배열인 경우, selfWriterID를 추가합니다.
                            if !blockIDs.contains(self.writerID ?? "") {
                                blockIDs.append(self.writerID ?? "")
                        db.collection("User").document(currentUser!).setData(["blockIDs": blockIDs], merge: true) { error in
                        if let error = error {
                        print("데이터를 업데이트하는 동안 오류가 발생했습니다: \(error)")
                        } else {
                        print("데이터가 성공적으로 업데이트되었습니다.")
                        }
                        }
                        } else {
                        // 이미 추가된 경우에 대한 처리 (예: 이미 포함되어 있음을 알릴 수 있음)
                        }
                        } else {
                        // blockIDs 필드가 없는 경우, 새로운 배열을 만들어서 selfWriterID를 추가합니다.
                        db.collection("User").document(currentUser!).setData(["blockIDs": [self.writerID]], merge: true) { error in
                        if let error = error {
                        print("데이터를 설정하는 동안 오류가 발생했습니다: \(error)")
                        } else {
                        print("데이터가 성공적으로 설정되었습니다.")
                        }
                        }
                        }
                        } else {
                        print("문서를 찾을 수 없습니다.")
                        }
                        }
                    }))
                    owner.present(alert, animated: true, completion: nil)
                })
            })
            .disposed(by: disposeBag)
        
        outputs.userAuthConfirmed
            .drive(onNext: { [weak self] _ in
                guard let self = self, let project = viewModel.project, let currentAuthor = Auth.auth().currentUser?.uid else {
                    return
                }
                
                if project.writerID == currentAuthor {
                    self.projectTeamLeaderProfileImageButton.isHidden = true
                    self.projectApplyButton.isHidden = true
                    self.navigationController?.navigationBar.tintColor = UIColor.black
                    if #available(iOS 13.0, *) {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                                                 image: .menuImage,
                                                                               primaryAction: nil,
                                                                               menu: self.editMenu)
                          } else {
                              self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .menuImage,
                                                                                       style: .plain,
                                                                                       target: self,
                                                                                       action: #selector(showActionSheet))
                          }
                } else {
                    self.navigationItem.rightBarButtonItem = self.reportButton
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func showActionSheet(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil,
                                      message: "액션시트",
                                      preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정하기",
                                         style: .default,
                                         handler: { [weak self] _ in
            self?.alertViewAlert(title: "수정",
                                 message: "프로젝트를 수정하시겠습니까?",
                                 cancelText: "아니요",
                                 acceptCompletion: {
                let editView = NewPageViewController(data: self?.viewModel.project)
                editView.modalPresentationStyle = .fullScreen
                self?.present(editView, animated: true)
            })
        })
        let deleteAction = UIAlertAction(title: "삭제하기",
                                       style: .default,
                                       handler: { [weak self] _ in
                                       self?.alertViewAlert(
                                 title: "삭제",
                                 message: "프로젝트를 삭제하시겠습니까?",
                                 cancelText: "아니요",
                                 acceptCompletion: {self?.viewModel.projectDeleteComplete.on(.next(()))
                                     self?.navigationController?.popViewController(animated: true)
            })
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            self.dismiss(animated: true)
        })

        [editAction, deleteAction, cancelAction].forEach { alert.addAction($0) }

        self.present(alert, animated: true, completion: nil)
    }
}
