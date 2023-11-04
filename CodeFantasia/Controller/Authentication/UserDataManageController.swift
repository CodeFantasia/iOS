
import UIKit
import Firebase
import FirebaseStorage

class UserDataManageController: UIViewController {
    
    // MARK: - Properties
    
    private let scrollview: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.isScrollEnabled = true
        scrollview.showsVerticalScrollIndicator = true
        return scrollview
    }()
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var nicknameView: UIView = {
        let view = Utilities().inputFormView(withLabel: "*닉네임 (영어, 한글 3~12자 입력)", firstSectionLength: 4, textview: nicknameTextView, textviewHeight: nil)
        return view
    }()
    
    private lazy var techStackView: UIView = {
        let (view, dropdownButton) = Utilities().dropdownInputFormView(withLabel: "*기술스택 (1개 이상 선택)", firstSectionLength: 5, textview: techStackTextView, textviewHeight: nil)
        dropdownButton.addTarget(self, action: #selector(handleTechStackButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var interestFieldView: UIView = {
        let (view, dropdownButton) = Utilities().dropdownInputFormView(withLabel: "*관심분야 (1개 이상 선택)", firstSectionLength: 5, textview: interestTextView, textviewHeight: nil)
        dropdownButton.addTarget(self, action: #selector(handleInterestFieldButton), for: .touchUpInside)
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
    
    private lazy var nicknameTextView: UITextView = {
        let textview = TextView()
        textview.placeholder(withPlaceholder: "닉네임을 입력해주세요.")
        return textview
    }()
    
    private let techStackTextView: UITextView = {
        let textview = TextView()
        textview.isEditable = false  // Disable editing
        textview.isSelectable = false  // Disable selection
        textview.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)  // Add some padding
        textview.placeholder(withPlaceholder: "기술스택을 선택해주세요.")
        return textview
    }()
    
    private let interestTextView: UITextView = {
        let textview = TextView()
        textview.placeholder(withPlaceholder: "관심분야를 선택해주세요.")
        return textview
    }()
    
    private let portfolioTextView: UITextView = {
        let textview = TextView()
        textview.placeholder(withPlaceholder: "포트폴리오 링크를 입력해주세요.")
        return textview
    }()
    
    private let selfIntroductionTextView: UITextView = {
        let textview = TextView()
        textview.placeholder(withPlaceholder: "자기 소개를 입력해주세요.")
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
    
    private let techstackTableview: DropDownTableView = {
        let tableview = DropDownTableView()
        let techstack = TechStack().technologies
        tableview.createDropdownTableView(withList: techstack)
        return tableview
    }()
    
    private let interestTableview: DropDownTableView = {
        let tableview = DropDownTableView()
        let allAreasOfInterest = AreasOfInterest().areasOfInterest
        tableview.createDropdownTableView(withList: allAreasOfInterest)
        return tableview
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureUI()
        configureDropdownUI()
//        self.hideKeyboard()
    }
    
    // MARK: - Selectors
    
    @objc func handleDoneButton() {
        print("Done button tapped!")
        
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
    
    @objc func backBarButton() {
        navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.isHidden = true 
    }
    
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleTechStackButton() {
        techstackTableview.isHidden = !techstackTableview.isHidden
        interestTableview.isHidden = true
        print("기술 스택")
    }
    
    @objc func handleInterestFieldButton() {
        interestTableview.isHidden = !interestTableview.isHidden
        techstackTableview.isHidden = true 
        print("관심 분야")
    }

    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor.primaryColor
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(scrollview)
        scrollview.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(CGFloat.spacing)
        }

        scrollview.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }

        let stackview = UIStackView(arrangedSubviews: [nicknameView, techStackView, interestFieldView, portfolioUrlView, selfIntroductionView, doneButton])
        stackview.axis = .vertical
        stackview.spacing = 20
        stackview.distribution = .fillProportionally

        scrollview.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(20)
            make.left.right.width.equalToSuperview().inset(CGFloat.spacing)
            make.bottom.equalToSuperview().inset(CGFloat.spacing)
        }

    }
    
    func configureDropdownUI() {
        view.addSubview(techstackTableview)
        techstackTableview.isHidden = true
        techstackTableview.snp.makeConstraints { make in
            make.left.right.equalTo(techStackView)
            make.top.equalTo(techStackView.snp.bottom).offset(2)
            make.height.equalTo(250)
        }
        
        view.addSubview(interestTableview)
        interestTableview.isHidden = true
        interestTableview.snp.makeConstraints { make in
            make.left.right.equalTo(interestFieldView)
            make.top.equalTo(interestFieldView.snp.bottom).offset(2)
            make.height.equalTo(250)
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

// MARK: - UIImagePickerControllerDelegate

extension UserDataManageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        addPhotoButton.layer.cornerRadius = 130 / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.imageView?.contentMode = .scaleToFill
        addPhotoButton.imageView?.clipsToBounds = true
        addPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
}
