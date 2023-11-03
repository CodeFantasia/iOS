//
//  NewPageViewController.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/16.
//

import Firebase
import FirebaseStorage
import Kingfisher
import SnapKit
import Then
import UIKit

class NewPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    // MARK: - 변수선언
    
    // firebase 선언
    private let projectRepository: ProjectRepositoryProtocol = ProjectRepository(firebaseBaseManager: FireBaseManager())
    
    // 스크롤 뷰
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    // 뒤로가기 버튼 생성
    let backButton = UIButton().then {
        $0.setTitle("뒤로가기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // 임시저장 버튼
    private let saveButton = UIButton().then {
        $0.setTitle("임시저장", for: .normal)
        $0.backgroundColor = UIColor(hex: 0x000000)
        $0.layer.cornerRadius = 15
        $0.setTitleColor(.white, for: .normal)
    }
    
    // 제목 라벨
    private let titleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = UIColor(hex: 0x000000)
        $0.sizeToFit()
    }
    
    // 제목 텍스트필드
    private let titleTextField = UITextField().then {
        $0.placeholder = "제목"
        $0.borderStyle = .roundedRect
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.backgroundColor = .white
    }
    
    // 썸네일 라벨
    private let thumbnailLabel: UILabel = {
        let label = UILabel()
        label.text = "썸네일"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()
    
    // 썸네일 이미지 뷰
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.backgroundColor = .white
        return imageView
    }()
    
    let plusIconImageView: UIImageView = {
        let iconImageView = UIImageView(image: UIImage(named: "plus_icon"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isHidden = true
        return iconImageView
    }()
    
    // 출시 플랫폼 라벨
    private let platformLabel: UILabel = {
        let label = UILabel()
        label.text = "출시 플랫폼"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()
    
    // 출시 플랫폼 텍스트 필드
    private let platformTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "출시 플랫폼"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        //        textField.addTarget(self, action: #selector(showPlatformSelection), for: .touchDown) //
        return textField
    }()
    
    // 모집 기술 및 언어 라벨
    private let techLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 기술 및 언어"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()
    
    // 모집 기술 및 언어 텍스트 필드
    private let techLanguageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "모집 기술 및 언어"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        return textField
    }()
    
    // 모집 분야 라벨
    private let recruitmentFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 분야"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()
    
    // 모집 분야 텍스트 필드
    private let recruitmentFieldTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "모집 분야"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        return textField
    }()
    
    // 프로젝트 소개 라벨
    private let projectIntroLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 소개"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()
    
    // 프로젝트 소개 텍스트뷰
    private let projectIntroTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.backgroundColor = .white
        return textView
    }()
    
    // 프로젝트 시작 기간 라벨
    let projectStartDateLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 시작일"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()
    
    // 프로젝트 종료 기간 라벨
    let projectEndDateLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 종료일"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()
    
    // 프로젝트 기간 데이트 피커1
    let projectStartDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    // 프로젝트 기간 데이트 피커2
    let projectEndDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    // 모임 유형 라벨
    let meetingTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 유형"
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()
    
    // 모임 유형 텍스트 필드
    let meetingTypeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "모임 유형"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        return textField
    }()
    
    // 신청 시 연락 방법 라벨
    let contactMethodLabel: UILabel = {
        let label = UILabel()
        label.text = "연락 수단을 적어주세요."
        label.textColor = UIColor(hex: 0x000000)
        label.sizeToFit()
        return label
    }()
    
    // 신청 시 연락 방법 텍스트 필드
    let contactMethodTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "신청 시 연락 방법"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        return textField
    }()
    
    // 작성 완료 버튼
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("작성 완료", for: .normal)
        //        button.frame = CGRect(x: 10, y: 1000, width: UIScreen.main.bounds.width - 20, height: 40)
        button.backgroundColor = UIColor(hex: 0x000000)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 자동완성을 위한 코드
    
    // 자동완성을 위한 제안 테이블 뷰
    private let suggestionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        return tableView
    }()
    
    private var filteredTechStacks: [String] = []
    
    // MARK: - 뷰 컨트롤러 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        techLanguageTextField.delegate = self
        
        setupUI()
        
        // 출시 플랫폼 텍스트 필드를 탭할 때 모달 페이지를 표시
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(platformTextFieldTapped))
        platformTextField.addGestureRecognizer(tapGesture)
        platformTextField.isUserInteractionEnabled = true
        
        // 썸네일 이미지 뷰를 탭할 때 이미지 선택 기능을 호출
        let thumbnailTapGesture = UITapGestureRecognizer(target: self, action: #selector(thumbnailImageViewTapped))
        thumbnailImageView.addGestureRecognizer(thumbnailTapGesture)
        thumbnailImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - 레이아웃설정
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(saveButton)
            $0.left.equalTo(view).offset(10)
        }
        
        let contentView = UIView()
        
        // 제목 라벨
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        // 제목 텍스트 필드
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }
        
        contentView.addSubview(thumbnailLabel)
        thumbnailLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(200)
        }
        
        // 출시 플랫폼 라벨와 텍스트 필드
        contentView.addSubview(platformLabel)
        platformLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(platformTextField)
        platformTextField.snp.makeConstraints {
            $0.top.equalTo(platformLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }
        
        // 모집 기술 및 언어 라벨와 텍스트 필드
        contentView.addSubview(techLanguageLabel)
        techLanguageLabel.snp.makeConstraints {
            $0.top.equalTo(platformTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(techLanguageTextField)
        techLanguageTextField.snp.makeConstraints {
            $0.top.equalTo(techLanguageLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }
        
        // 모집 분야 라벨와 텍스트 필드
        contentView.addSubview(recruitmentFieldLabel)
        recruitmentFieldLabel.snp.makeConstraints {
            $0.top.equalTo(techLanguageTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(recruitmentFieldTextField)
        recruitmentFieldTextField.snp.makeConstraints {
            $0.top.equalTo(recruitmentFieldLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }
        
        // 프로젝트 소개 라벨와 텍스트뷰
        contentView.addSubview(projectIntroLabel)
        projectIntroLabel.snp.makeConstraints {
            $0.top.equalTo(recruitmentFieldTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(projectIntroTextView)
        projectIntroTextView.snp.makeConstraints {
            $0.top.equalTo(projectIntroLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(100)
        }
        
        // 프로젝트 시작 기간 라벨과 데이트 피커
        contentView.addSubview(projectStartDateLabel)
        projectStartDateLabel.snp.makeConstraints {
            $0.top.equalTo(projectIntroTextView.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        contentView.addSubview(projectStartDatePicker)
        projectStartDatePicker.snp.makeConstraints {
            $0.top.equalTo(projectStartDateLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(100)
        }
        
        // 프로젝트 종료 기간 라벨 2와 데이트 피커 2
        contentView.addSubview(projectEndDateLabel)
        projectEndDateLabel.snp.makeConstraints {
            $0.top.equalTo(projectIntroTextView.snp.bottom).offset(20)
            $0.left.equalTo(projectStartDatePicker.snp.right).offset(150)
        }
        contentView.addSubview(projectEndDatePicker)
        projectEndDatePicker.snp.makeConstraints {
            $0.top.equalTo(projectEndDateLabel.snp.bottom).offset(10)
            $0.left.equalTo(projectStartDatePicker.snp.right).offset(150)
            $0.height.equalTo(100)
        }
        
        // 모집유형 라벨과 텍스트필드
        contentView.addSubview(meetingTypeLabel)
        meetingTypeLabel.snp.makeConstraints {
            $0.top.equalTo(projectEndDatePicker.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
        }
        
        contentView.addSubview(meetingTypeTextField)
        meetingTypeTextField.snp.makeConstraints {
            $0.top.equalTo(meetingTypeLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }
        // 연락방법 라벨과 텍스트필드
        contentView.addSubview(contactMethodLabel)
        contactMethodLabel.snp.makeConstraints {
            $0.top.equalTo(meetingTypeTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        
        contentView.addSubview(contactMethodTextField)
        contactMethodTextField.snp.makeConstraints {
            $0.top.equalTo(contactMethodLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(30)
        }
        
        // 작성 완료 버튼
        contentView.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.top.equalTo(contactMethodTextField.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(10)
            $0.width.equalTo(UIScreen.main.bounds.width - 20)
            $0.height.equalTo(30)
        }
        scrollView.addSubview(contentView)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(saveButton.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
            $0.bottom.equalTo(completeButton.snp.bottom).offset(20)
        }
        
        // 자동완성 테이블 뷰 설정
        view.addSubview(suggestionsTableView)
        suggestionsTableView.snp.makeConstraints {
            $0.top.equalTo(techLanguageTextField.snp.bottom)
            $0.left.right.equalTo(techLanguageTextField)
            $0.height.equalTo(200)
        }
        suggestionsTableView.dataSource = self
        suggestionsTableView.delegate = self
        suggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "suggestionCell")
        
    }
    
    // MARK: - 뒤로가기 버튼 함수
    
    @objc func backButtonTapped() {
        dismissNewPageViewController()
    }
    
    @objc func dismissNewPageViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 데이터 이동 함수
    
    @objc func completeButtonTapped() {
        //        let projectInfo = Project(projectTitle: "", projecSubtitle: "",techStack: [], recruitmentCount: 1,projectDescription: "", projectID: UUID(), platform: [], teamMember: [])
        //        projectRepository.create(project: projectInfo)
        //        print("aaa")
        let projectTitle = titleTextField.text
        let techLanguage = techLanguageTextField.text
        let recruitmentField = recruitmentFieldTextField.text
        let projectDescription = projectIntroTextView.text
        let meetingType = meetingTypeTextField.text
        let contactMethod = contactMethodTextField.text
        
        // 출시 플랫폼 텍스트 필드에서 사용자 입력을 가져옵니다.
        let platformInput = platformTextField.text
        
        // 사용자 입력을 쉼표로 분할하여 문자열 배열로 만듭니다.
        let platformsArray = platformInput?.components(separatedBy: "/").map { $0.trimmingCharacters(in: .whitespaces) } ?? []
        
        // 각 텍스트를 enum 값으로 변환하여 배열에 추가합니다.
        var selectedPlatforms: [Platform] = []
        for platformText in platformsArray {
            if let platform = Platform(rawValue: platformText) {
                selectedPlatforms.append(platform)
            }
        }
        
        // DateFormatter를 사용하여 문자열로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let projectStartDate = dateFormatter.string(from: projectStartDatePicker.date)
        let projectEndDate = dateFormatter.string(from: projectEndDatePicker.date)
        
        let thumbnailImageURL = ""
        
        // Project 구조체에 데이터 할당
        let projectInfo = Project(
            projectTitle: projectTitle,
            projecSubtitle: nil,
            techStack: [],
            recruitmentCount: 1,
            projectDescription: projectDescription,
            projectDuration: "\(projectStartDate) - \(projectEndDate)",
            meetingType: meetingType,
            imageUrl: thumbnailImageURL,
            projectID: UUID(),
            platform: selectedPlatforms,
            recruitmentField: recruitmentField,
            recruitingStatus: true,
            teamMember: [],
            contactMethod: contactMethod
        )
        // 작성폼이 비어있는지 판별한다는 느낌적인 느낌
        if projectTitle?.isEmpty ?? true ||
            techLanguage?.isEmpty ?? true ||
            recruitmentField?.isEmpty ?? true ||
            projectDescription?.isEmpty ?? true ||
            meetingType?.isEmpty ?? true ||
            contactMethod?.isEmpty ?? true ||
            platformInput?.isEmpty ?? true {
            // 어떤 필드라도 비어 있다면 반드시 경고 표시
            let alertController = UIAlertController(title: "Warning!", message: "Complete your mission", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Copy that.", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        // Firebase에 데이터 업로드
        dismissNewPageViewController()
        projectRepository.create(project: projectInfo)
    }
    
    func convertToEnum(rawValue: String) -> Platform? {
        return Platform(rawValue: rawValue)
    }
    
    // MARK: - 모달페이지함수
    
    @objc func platformTextFieldTapped() {
        // 출시 플랫폼 선택 뷰 컨트롤러를 표시
        let platformSelectionVC = PlatformSelectionViewController()
        platformSelectionVC.onPlatformSelected = { [weak self] platform in
            self?.platformTextField.text = platform
        }
        present(platformSelectionVC, animated: true, completion: nil)
    }
    
    // MARK: - 썸네일이미지피커
    
    @objc func thumbnailImageViewTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
        // 이미지피커가 열릴 때 + 아이콘 숨김
        plusIconImageView.isHidden = true
    }
    
    // 이미지를 선택한 후 호출되는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            thumbnailImageView.image = selectedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        // 이미지 선택 후 + 아이콘 다시 표시
        plusIconImageView.isHidden = false
    }
    
    
    
    // MARK: - UITextFieldDelegate
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 콤마를 기준으로 문자열 분할
        let components = newText.components(separatedBy: ",")
        
        // 마지막 구성 요소를 가져옵니다 (현재 입력 중인 텍스트)
        let lastComponent = components.last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // 이 텍스트를 사용하여 자동완성 수행
        updateSuggestions(for: lastComponent)
        
        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTechName = filteredTechStacks[indexPath.row]
        
        let currentText = techLanguageTextField.text ?? ""
        
        var components = currentText.components(separatedBy: ",")
        
        components[components.count - 1] = selectedTechName
        
        let newText = components.joined(separator: ",")
        
        techLanguageTextField.text = newText
        
        tableView.isHidden = true
    }
    
    // MARK: - UITableViewDataSource
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTechStacks.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath)
        let techName = filteredTechStacks[indexPath.row]
        
        if let originalImage = UIImage(named: techName) {
            let resizedImage = originalImage.resize(to: CGSize(width: 30, height: 30))
            cell.imageView?.image = resizedImage
        }
        
        cell.textLabel?.text = techName
        
        return cell
    }
    

    // MARK: - UITableViewDelegate
    
    private func updateSuggestions(for text: String) {
        let allTechStacks = getAllTechStacks()
        filteredTechStacks = allTechStacks.filter { $0.lowercased().contains(text.lowercased()) }

        suggestionsTableView.reloadData()
        suggestionsTableView.isHidden = filteredTechStacks.isEmpty
    }

    private func getAllTechStacks() -> [String] {
        let techStackInstance = TechStack()
        var allTechs: [String] = []
        for category in TechCategory.allCases {
            if let techs = techStackInstance.techForCategory(category) {
                allTechs.append(contentsOf: techs)
            }
        }
        return allTechs
    }
}



//     //MARK: - 미리보기

// struct NewPageViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPageViewControllerReprsentable().edgesIgnoringSafeArea(.all)
//    }
// }
//
// struct NewPageViewControllerReprsentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UIViewController {
//        return UINavigationController(rootViewController: NewPageViewController())
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//    typealias UIViewControllerType = UIViewController
// }

//
// extension UIColor {
//    convenience init(hex: Int, alpha: CGFloat = 1.0) {
//        self.init(
//            red: CGFloat((hex & 0xff0000) >> 16) / 255.0,
//            green: CGFloat((hex & 0x00ff00) >> 8) / 255.0,
//            blue: CGFloat(hex & 0x0000ff) / 255.0,
//            alpha: alpha
//        )
//    }
// }

// import UIKit
// import RxSwift
// import RxCocoa
//
// class NewPageViewController: UIViewController {
//    private let disposeBag = DisposeBag()
//    private let viewModel = NewPageViewModel()
//
////     뒤로가기 버튼
//        private let backButton = UIButton().then {
//            $0.setImage(UIImage(named: "backbutton"), for: .normal)
//            $0.imageView?.contentMode = .scaleAspectFit
//        }
//
//        // 임시저장 버튼
//        private let saveButton = UIButton().then {
//            $0.setTitle("임시저장", for: .normal)
//            $0.backgroundColor = UIColor(hex: 0x000000)
//            $0.layer.cornerRadius = 15
//            $0.setTitleColor(.white, for: .normal)
//        }
//
//        // 제목 라벨
//        private let titleLabel = UILabel().then {
//            $0.text = "제목"
//            $0.textColor = UIColor(hex: 0x000000)
//            $0.sizeToFit()
//        }
//
//        // 제목 텍스트필드
//        private let titleTextField = UITextField().then {
//            $0.placeholder = "제목"
//            $0.borderStyle = .roundedRect
//            $0.layer.cornerRadius = 8
//            $0.layer.borderWidth = 1
//            $0.layer.borderColor = UIColor.black.cgColor
//            $0.backgroundColor = .white
//        }
//
//        // 썸네일 라벨
//        private let thumbnailLabel: UILabel = {
//            let label = UILabel()
//            label.text = "썸네일"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 200)
//            return label
//        }()
//
//        // 썸네일 텍스트뷰
//        private let thumbnailTextView: UITextView = {
//            let textView = UITextView()
//            textView.layer.cornerRadius = 8
//            textView.layer.borderWidth = 1
//            textView.layer.borderColor = UIColor.black.cgColor
//            textView.backgroundColor = .white
//            textView.frame = CGRect(x: 20, y: 250, width: UIScreen.main.bounds.width - 40, height: 100)
//            return textView
//        }()
//
//        // 출시 플랫폼 라벨
//        private let platformLabel: UILabel = {
//            let label = UILabel()
//            label.text = "출시 플랫폼"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 380)
//            return label
//        }()
//
//        // 출시 플랫폼 텍스트 필드
//        private let platformTextField: UITextField = {
//            let textField = UITextField()
//            textField.placeholder = "출시 플랫폼"
//            textField.borderStyle = .roundedRect
//            textField.layer.cornerRadius = 8
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = UIColor.black.cgColor
//            textField.backgroundColor = .white
//            textField.frame = CGRect(x: 20, y: 430, width: UIScreen.main.bounds.width - 40, height: 30)
////            textField.addTarget(self, action: #selector(showPlatformSelection), for: .touchDown) //
//            return textField
//        }()
//
//        // 모집 기술 및 언어 라벨
//        private let techLanguageLabel: UILabel = {
//            let label = UILabel()
//            label.text = "모집 기술 및 언어"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 560)
//            return label
//        }()
//
//        // 모집 기술 및 언어 텍스트 필드
//        private let techLanguageTextField: UITextField = {
//            let textField = UITextField()
//            textField.placeholder = "모집 기술 및 언어"
//            textField.borderStyle = .roundedRect
//            textField.layer.cornerRadius = 8
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = UIColor.black.cgColor
//            textField.backgroundColor = .white
//            textField.frame = CGRect(x: 20, y: 610, width: UIScreen.main.bounds.width - 40, height: 30)
//            return textField
//        }()
//
//        // 모집 분야 라벨
//        private let recruitmentFieldLabel: UILabel = {
//            let label = UILabel()
//            label.text = "모집 분야"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 660)
//            return label
//        }()
//
//        // 모집 분야 텍스트 필드
//        private let recruitmentFieldTextField: UITextField = {
//            let textField = UITextField()
//            textField.placeholder = "모집 분야"
//            textField.borderStyle = .roundedRect
//            textField.layer.cornerRadius = 8
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = UIColor.black.cgColor
//            textField.backgroundColor = .white
//            textField.frame = CGRect(x: 20, y: 710, width: UIScreen.main.bounds.width - 40, height: 30)
//            return textField
//        }()
//
//        // 프로젝트 소개 라벨
//        private let projectIntroLabel: UILabel = {
//            let label = UILabel()
//            label.text = "프로젝트 소개"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 760)
//            return label
//        }()
//
//        // 프로젝트 소개 텍스트뷰
//        private let projectIntroTextView: UITextView = {
//            let textView = UITextView()
//            textView.layer.cornerRadius = 8
//            textView.layer.borderWidth = 1
//            textView.layer.borderColor = UIColor.black.cgColor
//            textView.backgroundColor = .white
//            textView.frame = CGRect(x: 20, y: 810, width: UIScreen.main.bounds.width - 40, height: 100)
//            return textView
//        }()
//
//        // 프로젝트 기간 라벨
//        private let projectDateLabel: UILabel = {
//            let label = UILabel()
//            label.text = "프로젝트 기간"
//            label.textColor = UIColor(hex: 0x000000)
//            label.sizeToFit()
//            label.frame.origin = CGPoint(x: 20, y: 940)
//            return label
//        }()
//
//        // 프로젝트 기간 데이트 피커
//        private let projectDatePicker: UIDatePicker = {
//            let datePicker = UIDatePicker()
//            datePicker.datePickerMode = .date
//            datePicker.frame = CGRect(x: 20, y: 990, width: UIScreen.main.bounds.width - 40, height: 100)
//            return datePicker
//        }()
//
//        // 작성 완료 버튼
//        private let completeButton: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitle("작성 완료", for: .normal)
//            button.frame = CGRect(x: 10, y: 1000, width: UIScreen.main.bounds.width - 20, height: 30)
//            button.backgroundColor = UIColor(hex: 0x000000)
//            button.layer.cornerRadius = 15
//            button.setTitleColor(.white, for: .normal)
//            return button
//        }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        bindViewModel()
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .white
//
//        // UI 요소들을 SnapKit을 사용하여 추가 및 레이아웃 설정 (생략)
//    }
//
//    private func bindViewModel() {
//        titleTextField.rx.text.orEmpty.bind(to: viewModel.title).disposed(by: disposeBag)
//        thumbnailTextView.rx.text.orEmpty.bind(to: viewModel.thumbnail).disposed(by: disposeBag)
//        platformTextField.rx.text.orEmpty.bind(to: viewModel.platform).disposed(by: disposeBag)
//        techLanguageTextField.rx.text.orEmpty.bind(to: viewModel.techLanguage).disposed(by: disposeBag)
//        recruitmentFieldTextField.rx.text.orEmpty.bind(to: viewModel.recruitmentField).disposed(by: disposeBag)
//        projectIntroTextView.rx.text.orEmpty.bind(to: viewModel.projectIntro).disposed(by: disposeBag)
//
//        // 프로젝트 날짜를 DatePicker에서 ViewModel로 바인딩
////        projectDatePicker.rx.date.bind(to: viewModel.projectDate).disposed(by: disposeBag)
//
//        // 저장 버튼 액션
//        saveButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.viewModel.saveButtonTapped()
//            })
//            .disposed(by: disposeBag)
//    }
// }

// extension UIColor {
//    convenience init(hex: Int, alpha: CGFloat = 1.0) {
//        self.init(
//            red: CGFloat((hex & 0xff0000) >> 16) / 255.0,
//            green: CGFloat((hex & 0x00ff00) >> 8) / 255.0,
//            blue: CGFloat(hex & 0x0000ff) / 255.0,
//            alpha: alpha
//        )
//    }
// }
