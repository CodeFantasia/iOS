//
//  ProjectDetailNoticeBoardViewController.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/13.
//

import UIKit
import Then
import SnapKit

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
//        $0.backgroundColor = .clear
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
    private lazy var rightButton = UIBarButtonItem(image: .projectEditImage, style: .plain, target: self, action: #selector(editImageTapped))

}

//MARK: - View Life Cycle
extension ProjectDetailNoticeBoardViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // 파티장이라면
        navigationItem.rightBarButtonItem = rightButton
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
            make.height.greaterThanOrEqualTo(32)
        }
        recruitmentStatusContextLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(32)
        }
        projectIntroduceContextLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(32)
        }
        projectPeriodContextLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(32)
        }
        projectMeetingTypeContextLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(32)
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
    @objc private func editImageTapped() {}
}
