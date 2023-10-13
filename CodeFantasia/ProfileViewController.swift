//
//  ProfileViewController.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/12.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 프로필"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let produceView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .green
        return view
    }()
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 50
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
    
    private let techTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "주요 사용 언어 및 기술 스택"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let techView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .green
        return view
    }()
    
    private let techLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let urlTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 포트폴리오"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let urlView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .green
        return view
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let interestTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 관심분야"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let interestView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .green
        return view
    }()
    
    private let interestLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 수정", for: .normal)
        return button
    }()
    
    private let logoutButton:  UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension ProfileViewController {
    private func setupLayout() {
        
        view.addSubview(titleLabel)
        view.addSubview(produceView)
        view.addSubview(profileImage)
        view.addSubview(nicknameLabel)
        view.addSubview(produceLabel)
        view.addSubview(produceContent)
        view.addSubview(techTitleLabel)
        view.addSubview(techView)
        view.addSubview(techLabel)
        view.addSubview(urlTitleLabel)
        view.addSubview(urlView)
        view.addSubview(urlLabel)
        view.addSubview(interestTitleLabel)
        view.addSubview(interestView)
        view.addSubview(interestLabel)
        view.addSubview(editButton)
        view.addSubview(logoutButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(46)
            $0.leading.equalToSuperview().inset(20)
        }
        
        produceView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
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
        techTitleLabel.snp.makeConstraints {
            $0.top.equalTo(produceView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        techView.snp.makeConstraints {
            $0.top.equalTo(techTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }
        techLabel.snp.makeConstraints {
            $0.leading.equalTo(techView.snp.leading).inset(16)
            $0.top.equalTo(techView.snp.top).inset(16)
        }
        urlTitleLabel.snp.makeConstraints {
            $0.top.equalTo(techView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        urlView.snp.makeConstraints {
            $0.top.equalTo(urlTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }
        urlLabel.snp.makeConstraints {
            $0.leading.equalTo(urlView.snp.leading).inset(16)
            $0.top.equalTo(urlView.snp.top).inset(16)
        }
        interestTitleLabel.snp.makeConstraints {
            $0.top.equalTo(urlView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        interestView.snp.makeConstraints {
            $0.top.equalTo(interestTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }
        interestLabel.snp.makeConstraints {
            $0.leading.equalTo(interestView.snp.leading).inset(16)
            $0.top.equalTo(interestView.snp.top).inset(16)
        }
        editButton.snp.makeConstraints {
            $0.top.equalTo(interestView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
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

