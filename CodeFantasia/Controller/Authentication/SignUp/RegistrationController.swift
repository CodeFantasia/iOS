
import UIKit
import FirebaseAuth
import FirebaseDatabase
import WebKit

class RegistrationController: UIViewController {

    // MARK: - Properties

    private var isDuplicate = true
    private var isTermsOfConditionsViewHidden = true
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "REGISTER"
        label.font = UIFont.title
        label.textColor = .black
        return label
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Log in")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let (view, btn) = Utilities().duplicateCheckView(withImage: UIImage(named: "mail")!, textField: emailTextField)
        btn.addTarget(self, action: #selector(handleEmailDuplicateCheck), for: .touchUpInside)
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
        let view = Utilities().inputContainerView(withImage: UIImage(systemName: "lock")!, textField: passwordTextField)
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
        let view = Utilities().inputContainerView(withImage: UIImage(systemName: "lock")!, textField: passwordCheckTextField)
        return view
    }()
    
    private let passwordDoNotMatch: UILabel = {
        let label = UILabel()
        label.font = UIFont.smallTitle
        label.text = "비밀번호가 일치하지 않습니다."
        label.textColor = .systemRed
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceholder: "Email")
        textfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textfield
    }()
    
    private let passwordTextField: UITextField = {
        let textfield = Utilities().textField(withPlaceholder: "Password")
        textfield.textContentType = .oneTimeCode
        textfield.isSecureTextEntry = true
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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.buttonTitle
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var termsOfConditionsView: UIView = {
        let view = TermsOfConditionsView()
        return view
    }()
    
    private lazy var termsOfConditionsBtn: UIButton = {
        let btn = Utilities().attributedButton("Code Cocoon 이용 약관", " 확인하기")
        btn.addTarget(self, action: #selector(handleTermsOfConditionsBtn), for: .touchUpInside)
        return btn
    }()
    
    private lazy var  privacyPolicyUrlBtn: UIButton = {
        let btn = Utilities().attributedButton("개인 정보 및 처리 방침", " 확인하기")
        btn.addTarget(self, action: #selector(handlePrivatePolicyBtn), for: .touchUpInside)
        return btn
    }()
    
    private let agreeBtn: UIButton = {
        let checkBtn = UIButton(type: .system)
        checkBtn.setImage(UIImage(systemName: "square"), for: .normal)
        checkBtn.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkBtn.imageView?.contentMode = .scaleAspectFill
        checkBtn.layer.masksToBounds = true
        checkBtn.tintColor = .black
        checkBtn.addTarget(self, action: #selector(handleTermsOfConditionsAgree), for: .touchUpInside)
        // checkBtn.adjustsImageWhenHighlighted = false
        return checkBtn
    }()
    
    private lazy var termsOfConditionsAgree: UIView = {
        let view = UIView()
        
        view.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
//            make.width.height.equalTo(25)
        }
        
        let label = UILabel()
        label.text = "위를 확인했으며 이에 동의합니다."
        label.textColor = .black
        label.font = UIFont.body
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(agreeBtn.snp.right).offset(2)
            make.centerY.equalToSuperview()
            make.right.height.equalToSuperview()
        }
    
        return view
    }()
    
    // MARK: - Life Cycle
      override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        hideTextView()
        setKeyboardObserver()
      }
      deinit {
        removeKeyboardObserver()
      }
    
    // MARK: - Selectors
    
    @objc func textFieldDidChange() {
        isDuplicate = true 
    }
    
    @objc func handleEmailDuplicateCheck() {
        guard let email = emailTextField.text, emailVerify(email: email) else { return }

        AuthManager().checkDuplicate(email: email) { result in
            if result {
                let alert = UIAlertController(title: "Yes!", message: "사용 가능한 아이디입니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
                self.isDuplicate = false
            } else {
                let alert = UIAlertController(title: "No!", message: "다른 이메일을 입력해주세요.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
                self.isDuplicate = true
            }
        }
    }
    
    @objc func handleTermsOfConditionsAgree() {
        agreeBtn.isSelected = !agreeBtn.isSelected
    }
    
    let navbar = UIView()
    let webView = WKWebView()
    
    @objc func handlePrivatePolicyBtn() {
        navbar.isHidden = false
        webView.isHidden = false

        
        view.addSubview(navbar)
        navbar.backgroundColor = .white
        navbar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("Close", for: .normal)
        closeBtn.setTitleColor(.black, for: .normal)
        closeBtn.addTarget(self, action: #selector(handleCloseBtn), for: .touchUpInside)
        navbar.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(navbar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        let url = "https://plip.kr/pcc/e06614ca-9e2f-40ad-9e1e-4c154598dc80/privacy/1.html"
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc func handleCloseBtn() {
        navbar.isHidden = true
        webView.isHidden = true
    }
    
    @objc func handleTermsOfConditionsBtn() {
        navbar.isHidden = false
        webView.isHidden = false

        
        view.addSubview(navbar)
        navbar.backgroundColor = .white
        navbar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("Close", for: .normal)
        closeBtn.setTitleColor(.black, for: .normal)
        closeBtn.addTarget(self, action: #selector(handleCloseBtn), for: .touchUpInside)
        navbar.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(navbar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        let url = "https://field-father-166.notion.site/a7e802a5c4904aeb8fb20ddc6d21e4b5?pvs=4"
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextButton() {

        if isDuplicate == true {
            emailContainerView.shake()
            return
        }
        
        if agreeBtn.isSelected == false {
            termsOfConditionsBtn.shake()
            return
        }

        guard let email = emailTextField.text, emailVerify(email: email) else { return }
        guard let password = passwordTextField.text, let passwordCheck = passwordCheckTextField.text, passwordVerify(password: password, passwordMatch: passwordCheck) else { return }
        
        let newUser = UserAuth(email: email, password: password)
        
        AuthManager().registerUser(crudentials: newUser) { error, data in
            if let error = error {
                print("회원가입 실패! error: \(error)")
            } else {
                print("회원가입 성공!")
            }
        }

        let userId = Auth.auth().currentUser?.uid
        let data = ProfileViewModel(userRepository:UserRepository(firebaseBaseManager: FireBaseManager()), userId: userId ?? "").userProfile
        let vc = UserDataManageController(data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissTextView() {
        termsOfConditionsView.isHidden = true
    }

    
    // MARK: - Helpers
    
    func hideTextView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissTextView))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
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

    func checkFailed(shakeView: UIView, alertLabel: UILabel) {
        shakeView.shake()
        alertLabel.isHidden = false
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }

        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, passwordCheckContainerView])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(CGFloat.authSpacing)
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
        
        let termsStack = UIStackView(arrangedSubviews: [termsOfConditionsBtn, privacyPolicyUrlBtn, termsOfConditionsAgree])
        termsStack.axis = .vertical
        termsStack.alignment = .center
        termsStack.spacing = 2
        termsStack.distribution = .fillEqually
        
        view.addSubview(termsStack)
        termsStack.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom).offset(25)
            make.left.right.equalTo(stack)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(termsStack.snp.bottom).offset(15)
            make.left.right.equalTo(stack)
        }
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
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
        return NSPredicate(format: "SELF MATCHES %@", emailPattern.lowercased()).evaluate(with: input)
    }
    
    func containsOnlyEnglishAndKorean(_ input: String) -> Bool {
        let pattern = "^[a-zA-Z가-힣]*$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: input)
    }
}
