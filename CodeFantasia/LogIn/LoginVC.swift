
import Foundation
import UIKit

class LoginVC: UIViewController {
    // MARK: Properties
    private let iconImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "AppIcon")
        imageview.contentMode = .scaleAspectFit
        imageview.layer.cornerRadius = CGFloat.cornerRadius
        
        return imageview
    }()
    
    private let signupView = {
        let containerView = UIView()

        let label = UILabel()
        label.text = "애플 계정으로 가입하고 이용하세요."
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: CGFloat.subTitle)
        
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        
        let imageview = UIImageView()
        imageview.image = UIImage(named: "AppleSignUp")
        imageview.contentMode = .scaleAspectFill
        
        containerView.addSubview(label)
        containerView.addSubview(button)
        containerView.addSubview(imageview)
        
        label.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(2)
            make.centerY.equalTo(label)
        }
        
        imageview.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(button.snp.bottom).offset(5)
            make.width.equalToSuperview()
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
        view.addSubview(signupView)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(50)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing)
            make.height.equalTo(500)
        }
        
        signupView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(200)
        }
    }
}
