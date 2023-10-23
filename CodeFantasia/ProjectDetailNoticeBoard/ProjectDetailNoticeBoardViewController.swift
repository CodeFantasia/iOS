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

final class ProjectDetailNoticeBoardViewController: UIViewController {

    private lazy var scrollView = UIScrollView()
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
//        $0.spacing = 20
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
    private lazy var techStackContextView = PaddingLabel(inset: .init(top: 10, left: 10, bottom: 10, right: 10)).then {
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
    private lazy var recruitmentStatusContextLabel = PaddingLabel(inset: .init(top: 10, left: 10, bottom: 10, right: 10)).then {
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
    private lazy var projectIntroduceContextLabel = PaddingLabel(inset: .init(top: 10, left: 10, bottom: 10, right: 10)).then {
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
    private lazy var projectPeriodContextLabel = PaddingLabel(inset: .init(top: 10, left: 10, bottom: 10, right: 10)).then {
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

    private lazy var projectMeetingTypeContextLabel = PaddingLabel(inset: .init(top: 10, left: 10, bottom: 10, right: 10)).then {
        $0.text = ""
        $0.numberOfLines = 0
    }
    private lazy var projectApplyButton = UIHoverButton().then {
        $0.setTitle("신청하기", for: .normal)
        $0.titleLabel?.font = .buttonTitle
        $0.setTitleColor(.black, for: .normal)
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
    private lazy var editButton = UIBarButtonItem(image: .projectEditImage, style: .plain, target: self, action: nil)
    private lazy var reportButton = UIBarButtonItem(image: .reportImage, style: .plain, target: self, action: nil)
    private let viewModel: ProjectDetailNoticeBoardViewModel
    private let disposeBag = DisposeBag()
    init(viewModel: ProjectDetailNoticeBoardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - View Life Cycle
extension ProjectDetailNoticeBoardViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // 파티장이라면
        navigationItem.rightBarButtonItems = [reportButton, editButton]
        // 아니면
//        navigationItem.rightBarButtonItems = [reportButton]
    }
}

//MARK: - UI Setting
extension ProjectDetailNoticeBoardViewController {
    private func configure() {
        view.backgroundColor = .backgroundColor
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
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
            editImageTapped: editButton.rx.tap.asObservable(),
            profileImageTapped: projectTeamLeaderProfileImageButton.rx.tap.asObservable(),
            projectApplyButtonTapped: projectApplyButton.rx.tap.asObservable(),
            projectReportButtonTapped: reportButton.rx.tap.asObservable()
        )
        let outputs = viewModel.transform(input: inputs)
        
        outputs.projectDataFetched
            .subscribe(onNext: { [weak self] project in
                guard let self else {return}
                DispatchQueue.main.async {
                    //TODO: project 모델 타이틀, 부 타이틀 없음
                    self.techStackContextView.text = project.platform.reduce("", {$0 + $1.rawValue + "\n"})
                    self.projectImageView.kf.setImage(with: URL(string: project.imageUrl ?? "")) { result in
                        switch result {
                        case .success(_):
                            self.projectImageView.roundCornersForAspectFit(radius: .cornerRadius)
                        case .failure(_):
                            self.alertViewAlert(title: "오류", message: "이미지 다운로드에 오류가 발생했습니다.", cancelText: nil)
                        }
                    }
                    self.recruitmentStatusContextLabel.text = project.recruitmentField ?? ""
                    self.projectIntroduceContextLabel.text = project.projectDescription ?? ""
                    self.projectMeetingTypeContextLabel.text = project.meetingType ?? ""
                    self.projectPeriodContextLabel.text = project.projectDuration ?? ""
                }
                
            }, onError: { error in
                self.alertViewActionSheet(
                    title: "오류 발생",
                    message: error.localizedDescription,
                    acceptText: "확인",
                    cancelText: nil
                )
            })
            .disposed(by: disposeBag)
        
        outputs.projectApplyButtonDidTap
            .withUnretained(self)
            .subscribe { _ in
                DispatchQueue.main.async {
                    self.alertViewAlert(title: "신청", message: "프로젝트에 신청하시겠습니까?", cancelText: "아니요", acceptCompletion:  {
                        self.viewModel.projectApplyComplete.on(.next(()))
                    })
                }
            }
            .disposed(by: disposeBag)
        
        outputs.projectLeaderProfileDidTap
            .withUnretained(self)
            .subscribe { _ in
                // 프로필 뷰로
            }
            .disposed(by: disposeBag)
        
        outputs.projectReportButtonDidTap
            .withUnretained(self)
            .subscribe { _ in
                DispatchQueue.main.async {
                    self.alertViewAlert(title: "신고", message: "프로젝트를 신고하시겠습니까?", cancelText: "아니요", acceptCompletion:  {
                        self.viewModel.projectReportComplete.on(.next(()))
                    })
                }
            }
            .disposed(by: disposeBag)
        
        outputs.projectEditButtonDidTap
            .withUnretained(self)
            .subscribe { _ in
                // 글 변경 뷰로
            }
            .disposed(by: disposeBag)
    }
}
