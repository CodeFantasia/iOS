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
        $0.text = "즐코팟 모집중"
        $0.font = .title
    }
    private lazy var projectsubTitleLabel = UILabel().then {
        $0.text = "나의 첫 사이드 프로젝트 여기서 시작해보세요"
        $0.font = .body
    }
    private lazy var projectTeamLeaderProfileImageButton = UIButton().then {
        $0.layer.cornerRadius = .cornerRadius
        $0.clipsToBounds = true
        $0.setImage(UIImage(systemName: "person.crop.circle.fill"), for: .normal)
    }
    private lazy var projectImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "person.crop.circle.fill")
    }
    private lazy var techStackStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = .spacing
    }
    private lazy var techStackStackViewTitleLabel = UILabel().then {
        $0.text = "기술 및 언어"
        $0.font = .subTitle
    }
    private lazy var techStackImagesView = PaddingLabel(inset: .init(top: 10, left: 10, bottom: 10, right: 10)).then {
        $0.text = "기술스택 기술스택"
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
        UI/UX 0/1
        iOS 1/2
        Backend 2/2
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
        우리는 모든 사용자에게 유용한 솔루션을 제공하기 위해 노력하고 있습니다. 이 앱은 사용자의 다양한 BedZERG를 해결하고, 새로운 경험을 제공하며, 다른 사용자와의 연결을 촉진합니다.
        
        원해요!

        모든 시간을 투자할 수 있는 분
        모르더라도 끝까지 방법을 찾아내시는 분
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
        $0.text = "2023.10.10 ~ 2023.10.25"
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
        $0.text = "온라인 (Zoom) 미팅"
        $0.numberOfLines = 0
    }
    private lazy var projectApplyButton = UIButton().then {
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
        [techStackStackViewTitleLabel, techStackImagesView].forEach {
            techStackStackView.addArrangedSubview($0)
        }
        [recruitmentStatusTitleLabel, recruitmentStatusContextLabel].forEach {
            recruitmentStatusStackView.addArrangedSubview($0)
        }
        [projectIntroduceTitleLabel, projectIntroduceContextLabel].forEach {
            projectIntroduceStackView.addArrangedSubview($0)
        }
        [projectMeetingTypeTitleLabel, projectMeetingTypeContextLabel].forEach {
            projectMeetingTypeStackView.addArrangedSubview($0)
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
