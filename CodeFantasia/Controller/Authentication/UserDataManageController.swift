
import UIKit
import Firebase
import FirebaseStorage

class UserDataManageController: UIViewController {
    
    // MARK: - Properties

    private lazy var nicknameView: UIView = {
        let view = Utilities().inputFormView(withLabel: "*닉네임 (영어, 한글 3~12자 입력)", firstSectionLength: 4, textview: nicknameTextView, textviewHeight: nil)
        return view
    }()
    
    private lazy var techStackView: UIView = {
        let view = Utilities().inputFormView(withLabel: "*기술스택 (1개 이상 선택)", firstSectionLength: 5, textview: techStackTextView, textviewHeight: nil)
        return view
    }()
    
    private lazy var interestFieldView: UIView = {
        let view = Utilities().inputFormView(withLabel: "*관심분야 (1개 이상 선택)", firstSectionLength: 5, textview: interestTextView, textviewHeight: nil)
        return view
    }()
    
    private lazy var portfolioUrlView: UIView = {
        let view = Utilities().inputFormView(withLabel: "포트폴리오 링크", firstSectionLength: 0, textview: portfolioTextView, textviewHeight: nil)
        return view
    }()
    
    private lazy var selfIntroductionView: UIView = {
        let view = Utilities().inputFormView(withLabel: "자기소개", firstSectionLength: 0, textview: selfIntroductionTextView, textviewHeight: 100)
        return view
    }()
    
    private let nicknameTextView: UITextView = {
        let textview = UITextView()
        return textview
    }()
    
    private let techStackTextView: UITextView = {
        let textview = UITextView()
        return textview
    }()
    
    private let interestTextView: UITextView = {
        let textview = UITextView()
        return textview
    }()
    
    private let portfolioTextView: UITextView = {
        let textview = UITextView()
        return textview
    }()
    
    private let selfIntroductionTextView: UITextView = {
        let textview = UITextView()
        return textview
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.backgroundColor = UIColor.white
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.layer.cornerRadius = CGFloat.cornerRadius
        button.titleLabel?.font = UIFont.buttonTitle
        button.setTitleColor(.primaryColor, for: .normal)
        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        return button
    }()
    

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleDoneButton() {
        print("Done button tapped!")
    }
    
    @objc func backBarButton() {
        navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.isHidden = true 
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor.primaryColor

        let stackview = UIStackView(arrangedSubviews: [nicknameView, techStackView, interestFieldView, portfolioUrlView, selfIntroductionView, doneButton])
        stackview.axis = .vertical
        stackview.spacing = 20
        stackview.distribution = .fillProportionally
        
        view.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.right.equalToSuperview().inset(CGFloat.spacing)
        }

    }
    
    func configureNavBar() {
        navigationController?.navigationBar.isHidden = false
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backBarButton))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = "회원 정보 입력"
        navigationItem.titleView?.tintColor = .white
    }
    
}

