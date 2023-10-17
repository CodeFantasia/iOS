
import UIKit
import Foundation

class TermsOfConditionsVC: UIViewController {

    private let termsOfConditionsString = "박현빈 죽어라"
    
    // MARK: Properties
    private let titleLabel = {
        let label = UILabel()
        label.text = "약관 정보 동의"
        label.font = UIFont.systemFont(ofSize: CGFloat.title, weight: .bold)
        
        return label
    }()
    
    private lazy var termsOfConditionsView = {
        let containerView = UIView()
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = CGFloat.cornerRadius
        
        let label = UILabel()
        label.text = termsOfConditionsString
        label.font = UIFont.systemFont(ofSize: CGFloat.content, weight: .regular)
        label.textColor = .black
        
        containerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(10)
        }
        
        return containerView
    }()
    
    private let profileRegisterButton = {
        let button = UIButton()
        button.customConfigure(title: "동의하고 프로필 등록하러가기")
        
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerConfiguration()
    }
    
    // MARK: Layer Configuration
    private func layerConfiguration() {
        view.addSubview(titleLabel)
        view.addSubview(termsOfConditionsView)
        view.addSubview(profileRegisterButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
        
        termsOfConditionsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing)
            make.bottom.equalToSuperview().offset(-100)
        }
        
        profileRegisterButton.snp.makeConstraints { make in
            make.top.equalTo(termsOfConditionsView.snp.bottom).offset(10)
            make.width.equalTo(termsOfConditionsView)
            make.leading.trailing.equalTo(termsOfConditionsView)
            make.height.equalTo(35)
        }
    }
}
