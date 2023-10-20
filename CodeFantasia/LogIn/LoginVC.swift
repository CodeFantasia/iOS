
import Foundation
import UIKit

class LoginVC: UIViewController {
    private let textfieldHeight = 40
    
    // MARK: Properties
    private let iconImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "AppIcon")
        imageview.contentMode = .scaleAspectFit
        imageview.layer.cornerRadius = CGFloat.cornerRadius
        
        return imageview
    }()
    
    private lazy var loginView = {
        let containerView = UIView()
        
        let idLabel = UILabel()
        idLabel.text = "아이디"
        idLabel.textColor = .black
        idLabel.font = UIFont.subTitle
        
        let idTextField = UITextField()
        idTextField.customConfigure(placeholder: "아이디를 입력해주세요.")
        
        let passwordLabel = UILabel()
        passwordLabel.text = "비밀번호"
        passwordLabel.textColor = .black
        passwordLabel.font = UIFont.subTitle
        
        let passwordTextField = UITextField()
        passwordTextField.customConfigure(placeholder: "비밀번호를 입력해주세요.")
        
        let loginButton = UIButton()
        loginButton.primaryColorConfigure(title: "로그인")
        
        containerView.addSubview(idLabel)
        containerView.addSubview(idTextField)
        containerView.addSubview(passwordLabel)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(loginButton)
        
        idLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(containerView)
        }
        
        idTextField.snp.makeConstraints { make in
            make.leading.equalTo(idLabel)
            make.top.equalTo(idLabel.snp.bottom).offset(2)
            make.height.equalTo(textfieldHeight)
            make.width.equalTo(containerView)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.leading.equalTo(idTextField)
            make.top.equalTo(idTextField.snp.bottom).offset(2)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(passwordLabel)
            make.top.equalTo(passwordLabel.snp.bottom).offset(2)
            make.height.equalTo(textfieldHeight)
            make.width.equalTo(containerView)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.equalTo(containerView)
        }
        
        return containerView
    }()
    
    private let signupView = {
        let containerView = UIView()

        let label = UILabel()
        label.text = "아이디가 없으신가요?"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: CGFloat.subTitle)
        
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        
        containerView.addSubview(label)
        containerView.addSubview(button)
        
        label.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(3)
            make.centerY.equalTo(label)
        }
        
        return containerView
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerConfiguration()
    }
    
    // MARK: Layer Configuration
    private func layerConfiguration() {
        view.addSubview(iconImageView)
        view.addSubview(loginView)
        view.addSubview(signupView)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(50)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing)
            make.height.equalTo(400)
        }
        
        loginView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing)
            make.height.equalTo(200)
        }
        
        signupView.snp.makeConstraints { make in
            make.top.equalTo(loginView.snp.bottom).offset(0)
            make.leading.trailing.equalTo(loginView)
            make.height.equalTo(200)
        }
    }
}
