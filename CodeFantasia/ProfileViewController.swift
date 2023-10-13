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
        label.text = "주요 사용 언어 및 기술 스택"
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
        label.text = "주요 사용 언어 및 기술 스택"
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

