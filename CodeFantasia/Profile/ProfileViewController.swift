//
//  ProfileViewController.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/12.
//
import UIKit
import SnapKit
import Then

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

    override func viewDidLoad() {
        super.viewDidLoad()
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
}
