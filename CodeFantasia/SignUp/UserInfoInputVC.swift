
import UIKit
import Foundation

class UserInfoInputVC: UIViewController {

    // MARK: titleLabel
    private let titleLabel = {
        let label = UILabel()
        label.text = "회원 정보 등록"
        label.font = UIFont.systemFont(ofSize: CGFloat.title, weight: .bold)
        
        return label
    }()
    
    // MARK: ScrollView Layout Configuration
    private lazy var scrollView = {
        let scrollView = UIScrollView()
        
        scrollView.addSubview(userProfileButton)
        scrollView.addSubview(nicknameLabel)
        scrollView.addSubview(nicknameTextField)
        scrollView.addSubview(verifyNickname)
        
        userProfileButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(scrollView)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileButton.snp.bottom).offset(30)
            make.leading.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
            make.height.equalTo(textfieldHeight)
            make.width.equalTo(scrollView)
        }
        
        verifyNickname.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(5)
            make.leading.equalTo(nicknameTextField)
        }
        
        scrollView.addSubview(techStackLabel)
        scrollView.addSubview(techStackTextField)
        
        techStackLabel.snp.makeConstraints { make in
            make.top.equalTo(verifyNickname.snp.bottom).offset(15)
            make.leading.equalTo(nicknameLabel)
        }
        
        techStackTextField.snp.makeConstraints { make in
            make.top.equalTo(techStackLabel.snp.bottom).offset(5)
            make.leading.equalTo(techStackLabel)
            make.height.equalTo(textfieldHeight)
            make.width.equalTo(scrollView)
        }
        
        scrollView.addSubview(interestedFieldLabel)
        scrollView.addSubview(interestedTextField)
        
        interestedFieldLabel.snp.makeConstraints { make in
            make.top.equalTo(techStackTextField.snp.bottom).offset(10)
            make.leading.equalTo(techStackLabel)
        }
        
        interestedTextField.snp.makeConstraints { make in
            make.top.equalTo(interestedFieldLabel.snp.bottom).offset(5)
            make.leading.equalTo(interestedFieldLabel)
            make.height.equalTo(textfieldHeight)
            make.width.equalTo(scrollView)
        }
        
        scrollView.addSubview(portfolioURLLabel)
        scrollView.addSubview(portfolioURLTextField)
        
        portfolioURLLabel.snp.makeConstraints { make in
            make.top.equalTo(interestedTextField.snp.bottom).offset(10)
            make.leading.equalTo(interestedFieldLabel)
        }
        
        portfolioURLTextField.snp.makeConstraints { make in
            make.top.equalTo(portfolioURLLabel.snp.bottom).offset(5)
            make.leading.equalTo(portfolioURLLabel)
            make.height.equalTo(textfieldHeight)
            make.width.equalTo(scrollView)
        }
        
        scrollView.addSubview(selfIntroductionLabel)
        scrollView.addSubview(selfIntroductionTextField)
        
        selfIntroductionLabel.snp.makeConstraints { make in
            make.top.equalTo(portfolioURLTextField.snp.bottom).offset(10)
            make.leading.equalTo(portfolioURLTextField)
        }
        
        selfIntroductionTextField.snp.makeConstraints { make in
            make.top.equalTo(selfIntroductionLabel.snp.bottom).offset(5)
            make.leading.equalTo(selfIntroductionLabel)
            make.height.equalTo(textfieldHeight * 2)
            make.width.equalTo(scrollView)
        }
        
        scrollView.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(selfIntroductionTextField.snp.bottom).offset(20)
            make.width.equalTo(scrollView)
            make.height.equalTo(30)
        }
        
        return scrollView
    }()
    
    // MARK: Sser Profile Button
    private let userProfileButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 100)
        let image = UIImage(systemName: "person.crop.circle.badge.plus", withConfiguration: imageConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        
        let highlightedImageConfig = UIImage.SymbolConfiguration(pointSize: 100)
        let highlightedImage = UIImage(systemName: "person.crop.circle.badge.plus", withConfiguration: highlightedImageConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        button.setImage(highlightedImage, for: .highlighted)
        
        return button
    }()
    
    // MARK: Height Size
    private let textfieldHeight = 45.0
    
    // MARK: Nickname
    private let nicknameLabel = {
        let label = UILabel()
        label.configureAttributedString(content: "*닉네임 (영어, 한글 3~12자 입력)", sectionLength: 4)
        
        return label
    }()
    
    private let nicknameTextField = {
        let textfield = UITextField()
        textfield.customConfigure(placeholder: "닉네임을 입력해주세요.")
        
        return textfield
    }()
    
    private let verifyNickname = {
        let label = UILabel()
        label.text = "사용할 수 있는 닉네임 입니다."
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .darkGray
        
        return label
    }()
    
    // MARK: Tech Stack
    private let techStackLabel = {
        let label = UILabel()
        label.configureAttributedString(content: "*기술스택 (1개 이상 선택)", sectionLength: 5)
        
        return label
    }()
    
    private let techStackTextField = {
        let textfield = UITextField()
        textfield.customConfigure(placeholder: "기술 스택을 선택해주세요.")
        
        return textfield
    }()
    
    // MARK: Interested Field
    private let interestedFieldLabel = {
        let label = UILabel()
        label.configureAttributedString(content: "*관심분야 (1개 이상 선택)", sectionLength: 5)
        
        return label
    }()
    
    private let interestedTextField = {
        let textfield = UITextField()
        textfield.customConfigure(placeholder: "관심분야를 입력해주세요.")
        
        return textfield
    }()
    
    // MARK: Portfolio URL
    private let portfolioURLLabel = {
        let label = UILabel()
        label.text = "포트폴리오 링크"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    private let portfolioURLTextField = {
        let textfield = UITextField()
        textfield.customConfigure(placeholder: "링크를 입력해주세요")
        
        return textfield
    }()
    
    // MARK: Self Introduction
    private let selfIntroductionLabel = {
        let label = UILabel()
        label.text = "자기소개"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    private let selfIntroductionTextField = {
        let textfield = UITextField()
        textfield.customConfigure(placeholder: "자기소개를 입력해주세요.")
        
        return textfield
    }()
    
    // MARK: Log in Button
    private let loginButton = {
        let button = UIButton()
        button.customConfigure(title: " Apple로 로그인")
        
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.trailing.leading.bottom.equalToSuperview().inset(20)
        }
    }
}
