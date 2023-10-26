import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private let logoImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        imageview.image = UIImage(named: "AppIcon")
        return imageview
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "mail")!, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_lock_outline_white_2x")!, textField: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceholder: "Email")
        return textfield
    }()
    
    private let passwordTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceholder: "Password")
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.primaryColor, for: .normal)
        button.backgroundColor = .white
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.buttonTitle
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Don't have an account?", " Sign up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setKeyboardObserver()
    }
    
    // MARK: - Selectors
    
    @objc func handleLogin() {
        print("Login!")
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .primaryColor
        navigationController?.navigationBar.barStyle = .black // 시간 등 안 내용의 tintColor가 흰색으로 바뀐다
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(150)
        }
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom)
            make.left.right.equalToSuperview().inset(CGFloat.spacing)
        }
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }

    }

}

