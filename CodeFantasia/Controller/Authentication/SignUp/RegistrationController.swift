
import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrationController: UIViewController {

    // MARK: - Properties
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Log in")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "mail")!, textField: emailTextField)
        return view
    }()
    
    private let emailCheckFailed: UILabel = {
        let label = UILabel()
        label.font = UIFont.smallTitle
        label.text = "올바른 이메일 형식이 아닙니다."
        label.textColor = .systemRed
        return label
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_lock_outline_white_2x")!, textField: passwordTextField)
        return view
    }()
    
    private let passwordCheckFailed: UILabel = {
        let label = UILabel()
        label.font = UIFont.smallTitle
        label.text = "영문과 숫자를 사용하여 6~20자로 작성해주세요."
        label.textColor = .systemRed
        return label
    }()

    private lazy var passwordCheckContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_lock_outline_white_2x")!, textField: passwordCheckTextField)
        return view
    }()
    
    private let passwordDoNotMatch: UILabel = {
        let label = UILabel()
        label.font = UIFont.smallTitle
        label.text = "비밀번호가 일치하지 않습니다."
        label.textColor = .systemRed
        return label
    }()
    
    private lazy var nameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_person_outline_white_2x")!, textField: nameTextField)
        return view
    }()
    
    private let nameCheckFailed: UILabel = {
        let label = UILabel()
        label.font = UIFont.smallTitle
        label.text = "영어와 한국어로 이름을 작성해 주세요."
        label.textColor = .systemRed
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceholder: "Email")
        return textfield
    }()
    
    private let passwordTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceholder: "Password")
        textfield.textContentType = .oneTimeCode
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    private let nameTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceholder: "Name")
        return textfield
    }()
    
    private let passwordCheckTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceholder: "Re-enter your password")
        textfield.isSecureTextEntry = true
        textfield.textContentType = .oneTimeCode
        return textfield
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.primaryColor, for: .normal)
        button.backgroundColor = .white
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.buttonTitle
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        // setKeyboardObserver()
    }
    
    // MARK: - Selectors
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextButton() {

        guard let email = emailTextField.text, emailVerify(email: email) else { return }
        guard let password = passwordTextField.text, let passwordCheck = passwordCheckTextField.text, passwordVerify(password: password, passwordMatch: passwordCheck) else { return }
        guard let name = nameTextField.text, nameVerify(name: name) else { return }

        let newUser = UserAuth(email: email, password: password, name: name)
        AuthManager.shared.registerUser(crudentials: newUser)
        
        print("계정 등록 완료!")
        
        navigationController?.pushViewController(UserDataManageController(), animated: true)
    
//        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
//        guard let tab = window.rootViewController as? TabBarController else { return }
//
//        tab.configureUI()
//
//        self.dismiss(animated: true)

//        AuthManager.shared.registerUser(crudentials: newUser) { (error, ref) in
//            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
//            guard let tab = window.rootViewController as? TabBarController else { return }
//
//            tab.configureUI()
//
//            self.dismiss(animated: true)
//        }
    }

    
    // MARK: - Helpers
    
    func emailVerify(email: String) -> Bool {
        if !emailCheck(email) {
            checkFailed(shakeView: emailContainerView, alertLabel: emailCheckFailed)
            return false
        } else {
            emailCheckFailed.isHidden = true
            return true
        }
    }
    
    func passwordVerify(password: String, passwordMatch: String) -> Bool {
        if !passwordCheck(password: password) {
            checkFailed(shakeView: passwordContainerView, alertLabel: passwordCheckFailed)
            return false
        } else {
            passwordCheckFailed.isHidden = true
        }

        if password != passwordMatch {
            checkFailed(shakeView: passwordCheckContainerView, alertLabel: passwordDoNotMatch)
            return false
        } else {
            passwordDoNotMatch.isHidden = true
        }

        return true
    }
    
    func nameVerify(name: String) -> Bool {
        if !containsOnlyEnglishAndKorean(name) || name.count < 1 {
            checkFailed(shakeView: nameContainerView, alertLabel: nameCheckFailed)
            return false
        } else {
            nameCheckFailed.isHidden = true
            return true
        }
    }
    
    func checkFailed(shakeView: UIView, alertLabel: UILabel) {
        shakeView.shake()
        alertLabel.isHidden = false
    }
    
    func configureUI() {
        view.backgroundColor = .primaryColor
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }

        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, passwordCheckContainerView, nameContainerView])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview().inset(8)
        }
        
        emailCheckFailed.isHidden = true
        view.addSubview(emailCheckFailed)
        emailCheckFailed.snp.makeConstraints { make in
            make.top.equalTo(emailContainerView.snp.bottom).offset(5)
            make.left.equalTo(emailContainerView).offset(5)
        }
        
        passwordCheckFailed.isHidden = true
        view.addSubview(passwordCheckFailed)
        passwordCheckFailed.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(5)
            make.left.equalTo(passwordContainerView).offset(5)
        }
        
        passwordDoNotMatch.isHidden = true
        view.addSubview(passwordDoNotMatch)
        passwordDoNotMatch.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckContainerView.snp.bottom).offset(5)
            make.left.equalTo(passwordCheckContainerView).offset(5)
        }
        
        nameCheckFailed.isHidden = true
        view.addSubview(nameCheckFailed)
        nameCheckFailed.snp.makeConstraints { make in
            make.top.equalTo(nameContainerView.snp.bottom).offset(5)
            make.left.equalTo(nameContainerView).offset(5)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(nameContainerView.snp.bottom).offset(45)
            make.left.right.equalTo(stack)
        }
    }
    
    // MARK: - Email, Password, Name check
    func passwordCheck(password: String) -> Bool {
        if (password.count < 6 || password.count > 20) || !containsAlphanumeric(password) {
                return false
        }

        return true
    }
    
    func containsAlphanumeric(_ input: String) -> Bool {
        let alphanumericPattern = "^(?=.*[A-Za-z])(?=.*\\d).{6,20}$"
        return NSPredicate(format: "SELF MATCHES %@", alphanumericPattern).evaluate(with: input)
    }
    
    func emailCheck(_ input: String) -> Bool {
        let emailPattern = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
        return NSPredicate(format: "SELF MATCHES %@", emailPattern).evaluate(with: input)
    }
    
    func containsOnlyEnglishAndKorean(_ input: String) -> Bool {
        let pattern = "^[a-zA-Z가-힣]*$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: input)
    }
}
