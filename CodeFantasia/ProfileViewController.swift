//
//  ProfileViewController.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/12.
//
import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 프로필"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let produceView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        view.layer.shadowColor = UIColor.black.cgColor
        view.backgroundColor = .white
        return view
    }()

    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 50
        image.backgroundColor = .gray
        return image
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let produceLabel: UILabel = {
        let label = UILabel()
        label.text = "내 소개"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let produceContent: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            produceView,
            infoLabel,
            separatorView1,
            techTitleLabel,
            techLabel,
            separatorView2,
            urlTitleLabel,
            urlLabel,
            separatorView3,
            interestTitleLabel,
            interestLabel,
            separatorView4,
            editButton,
            logoutButton
        ])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 스펙 정보"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    private let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray
        return view
    }()
    private let separatorView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray
        return view
    }()
    private let separatorView4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    private let techTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "주요 사용 언어 및 기술 스택"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let techLabel: UILabel = {
        let label = UILabel()
        label.text = "Swift"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private let urlTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 포트폴리오"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let urlLabel: UILabel = {
        let label = UILabel()
        label.text = "www.github.com"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private let interestTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 관심 분야"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let interestLabel: UILabel = {
        let label = UILabel()
        label.text = "앱개발"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private let editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("프로필 수정", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    private let logoutButton:  UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("로그아웃", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}
extension ProfileViewController {
    private func setupLayout() {

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        produceView.addSubview(profileImage)
        produceView.addSubview(nicknameLabel)
        produceView.addSubview(produceLabel)
        produceView.addSubview(produceContent)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        stackView.snp.makeConstraints {
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.top.equalTo(scrollView)
            $0.width.equalTo(view)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.top).offset(10)
            $0.leading.equalTo(stackView.snp.leading).offset(20)
        }
        produceView.snp.makeConstraints {
            $0.leading.equalTo(stackView.snp.leading).inset(20)
            $0.trailing.equalTo(stackView.snp.trailing).inset(20)
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
        separatorView1.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.equalTo(stackView.snp.leading).inset(20)
            $0.trailing.equalTo(stackView.snp.trailing).inset(20)
        }
        separatorView2 .snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(separatorView1)
        }
        separatorView3.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(separatorView1)
        }
        separatorView4.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(separatorView1)
        }
        editButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(separatorView1)
        }
        logoutButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(separatorView1)
            $0.bottom.equalTo(scrollView.snp.bottom).inset(20)
        }
    }
}

//화면별 Title 폰트 크기 -> Bold, 30
//소제목 폰트 크기 -> semi bold, 20
//디테일 폰트 크기 -> regular, 16
//
//뷰들 전부 ->  SafeLayoutArea
//왼쪽에서 20 오른쪽에서 20
//
//Title -> 위에서부터 10
//뷰들 간 간격 16
//
//extension 으로 빼놔서 통일감 줍시다
//뷰 네모네모 radius -> 10
//뷰 네모네모 그림자 주기
//
//얘도 extension으로 custom 버튼 만듭시다
//버튼들 높이 50, 가로는 Width 꽉 채워서 왼오 여백 20
//버튼 안 글씨 크기 20, regular  프로필 아이콘: 50*50
//기술 및 언어 아이콘 25*25  버튼 아이콘 20*20
//

