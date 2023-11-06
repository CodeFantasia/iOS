
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
    
    private var checkBtnChecked = false
    
    private let checkBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "square"), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(handleTermsOfConditionsCheck), for: .touchUpInside)
        return btn
    }()
    
    private lazy var termsOfConditionsView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.layer.cornerRadius = .cornerRadius
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.75
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.body
        label.textColor = .black
        label.textAlignment = .center
        label.text = """
Code Cocoond은(는) \"개인정보 보호법\"에 따라 아래와 같이 수집하는 개인정보의 항목, 수집 및 이용 목적, 보유 및 이용 기간을 안내드리고 동의를 받고자 합니다.

○ 개인정보 수집, 이용 내역

구분(업무명): 회원가입 및 관리
처리목적:
    - 본인 식별 인증
    - 회원자격 유지 관리
    - 각종 고지, 통지사항 전달
    - 서비스 부정가입 및 이용 방지
항목:
    - 이름, 이메일 주소, 아이디, 비밀번호, 닉네임, 휴대전화번호, 프로필 사진
보유 및 이용기간:
    - 회원 탈퇴시까지

구분(업무명): 고객 상담 및 문의
처리목적:
    - 고객 문의 접수 및 처리
    - 고객 불만 사항 처리
    - 문의 접수 및 처리 이력관리
항목:
    - 이름, 휴대전화번호, 이메일주소, 서비스 이용 내역, 문의 내용, 상담 내역, 아이디
보유 및 이용기간:
    - 회원 탈퇴시까지

정보주체는 위와 같이 개인정보를 처리하는 것에 대한 동의를 거부할 권리가 있습니다. 그러나 동의를 거부할 경우 [로그인이 필요한 Code Cocoon 서비스 이용]이 제한될 수 있습니다.
"""
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(CGFloat.spacing)
        }
        
        let checkLabel = UILabel()
        checkLabel.text = "본인은 Code Cocoon이(가) 위와 같이 개인정보를 수집 및 이용하는데 동의합니다."
        checkLabel.textColor = .black
        checkLabel.font = UIFont.body
        
        let stackview = UIStackView(arrangedSubviews: [checkBtn, checkLabel])
        stackview.axis = .horizontal
        stackview.spacing = 5
        stackview.distribution = .fillProportionally
        
        view.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalTo(label.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        let contentSize = CGSize(width: termsOfConditionsView.frame.size.width, height: stackview.frame.maxY + CGFloat.spacing)
        termsOfConditionsView.contentSize = contentSize


        return view
    }()
    
    private lazy var termsOfConditionsBtn: UIButton = {
        let btn = Utilities().attributedButton("Code Cocoon 이용 동의서", " 확인")
        btn.setTitle("Code Cocoon 서비스를 위한 개인정보 수집 및 이용 동의서", for: .normal)
        btn.addTarget(self, action: #selector(handleTermsOfConditionsBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        // setKeyboardObserver()
    }
    
    // MARK: - Selectors
    
    @objc func handleTermsOfConditionsCheck() {
        checkBtnChecked = !checkBtnChecked
        
        if checkBtnChecked {
            checkBtn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
    
    @objc func handleTermsOfConditionsBtn() {
        
        termsOfConditionsView.isHidden = !termsOfConditionsView.isHidden
        
        view.addSubview(termsOfConditionsView)
        termsOfConditionsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(CGFloat.spacing)
            make.height.equalTo(250)
            make.top.equalTo(termsOfConditionsBtn.snp.bottom).offset(2)
        }
    }
    
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
        
        view.addSubview(termsOfConditionsBtn)
        termsOfConditionsBtn.snp.makeConstraints { make in
            make.top.equalTo(nameContainerView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(termsOfConditionsBtn.snp.bottom).offset(45)
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
