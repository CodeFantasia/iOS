//
//  NewPageViewController.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/16.
//

import Firebase
import FirebaseAuth
import FirebaseStorage
import Kingfisher
import SnapKit
import Then
import UIKit

class NewPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    // MARK: - 변수선언

    private var isButtonEnabled = true
    private var buttonDebounceTimer: Timer?
    private let debounceInterval: TimeInterval = 3.0
    
    let data: Project?
    
    init(data: Project?) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 데이터가있는지 판별
    func setUp() {
        if let project = data {
            // 기존 프로젝트를 편집하는 경우
            titleTextField.text = project.projectTitle
            // 'platformTextField'를 선택된 플랫폼으로 채웁니다.
            platformTextField.text = project.platform.map { $0.rawValue }.joined(separator: "/")
            
            // 'techLanguageTextField'을 채우기 위해서는 'TechStack' 배열을 문자열로 변환해야 합니다.
            // 기존 프로젝트의 'techStack' 배열을 문자열로 변환하는 코드입니다.
            let techStackText = project.techStack.map { $0.technologies.joined(separator: ", ") }.joined(separator: " / ")
            techLanguageTextField.text = techStackText
            
            recruitmentFieldTextField.text = project.recruitmentField
            projectIntroTextView.text = project.projectDescription
            
            projectStartDatePicker.date = project.projectStartDate
            projectEndDatePicker.date = project.projectEndDate
            
            thumbnailImageView.kf.setImage(with: URL(string: project.imageUrl ?? ""))
            
            // 모임 유형과 연락 수단을 설정
            meetingTypeTextField.text = project.meetingType
            contactMethodTextField.text = project.contactMethod
            
            // 작성완료 버튼을 수정완료버튼으로 변경한다
            completeButton.setTitle("수정 완료", for: .normal)
        } else {
            // 새 프로젝트를 생성하는 경우
        }
    }
    
    let writerId = Auth.auth().currentUser?.uid
    
    // firebase 선언
    private let projectRepository: ProjectRepositoryProtocol = ProjectRepository(firebaseBaseManager: FireBaseManager())
    
    // 스크롤 뷰
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true // 수직 스크롤바 표시 여부
        return scrollView
    }()
    
    let navbar: UIView = {
        let (navBtn, view) = NewpostUtilities().createNavbar()
        navBtn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return view
    }()
    
    // 썸네일 이미지 뷰
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.shadow()
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "AddPhoto")
        imageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        return imageView
    }()
    
    let plusIconImageView: UIImageView = {
        let iconImageView = UIImageView(image: UIImage(named: "plus_icon"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isHidden = true // 초기에는 숨김
        return iconImageView
    }()
    
    // MARK: - Input View
    
    private lazy var titleView: UIView = {
        let view = NewpostUtilities().createInputView(title: "글 제목", textfield: titleTextField)
        return view
    }()

    private let titleTextField: UITextField = {
        let textfield = NewpostUtilities().createTextField(placeholder: "제목을 입력해주세요.")
        return textfield
    }()
    
    private lazy var platformView: UIView = {
        let view = NewpostUtilities().createInputView(title: "출시 플랫폼", textfield: platformTextField)
        return view
    }()
    
    private let platformTextField: UITextField = {
        let textfield = NewpostUtilities().createTextField(placeholder: "출시 플랫폼 선택해 주세요.")
        return textfield
    }()
    
    private lazy var techLanguageView: UIView = {
        let view = NewpostUtilities().createInputView(title: "모집 기술 및 언어", textfield: techLanguageTextField)
        return view
    }()

    private let techLanguageTextField: UITextField = {
        let textfield = NewpostUtilities().createTextField(placeholder: "모집 기술 및 언어를 선택해 주세요.")
        return textfield
    }()
    
    private lazy var recruitmentView: UIView = {
        let view = NewpostUtilities().createInputView(title: "모집 분야", textfield: recruitmentFieldTextField)
        return view
    }()

    private let recruitmentFieldTextField: UITextField = {
        let textfield = NewpostUtilities().createTextField(placeholder: "모집 분야를 입력해주세요.")
        return textfield
    }()
    
    private lazy var projectIntroView: UIView = {
        let view = NewpostUtilities().createTextviewInput(title: "프로젝트 소개", textview: projectIntroTextView, textviewHeight: 200)
        return view
    }()
    
    private let projectIntroTextView: UITextView = {
        let textview = NewpostUtilities().createTextView(placeholder: "프로젝트 소개를 해주세요!")
        return textview
    }()
    
    private lazy var datepickerView: UIView = {
        let view = NewpostUtilities().createDatePicker(startdate: projectStartDatePicker, enddate: projectEndDatePicker)
        return view
    }()

    let projectStartDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

    let projectEndDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private lazy var meetingTypeView: UIView = {
        let view = NewpostUtilities().createInputView(title: "모임 유형", textfield: meetingTypeTextField)
        return view
    }()

    private let meetingTypeTextField: UITextField = {
        let textField = NewpostUtilities().createTextField(placeholder: "모임 유형을 입력해주세요.")
        return textField
    }()
    
    private lazy var contactMethodView: UIView = {
        let view = NewpostUtilities().createInputView(title: "연락처", textfield: contactMethodTextField)
        return view
    }()
    
    private let contactMethodTextField: UITextField = {
        let textField = NewpostUtilities().createTextField(placeholder: "연락 수단을 적어주세요.")
        return textField
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("작성 완료", for: .normal)
        button.backgroundColor = UIColor(hex: 0x000000)
        button.layer.cornerRadius = .cornerRadius
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
    
    private let autoCompleteManager = AutoCompleteManager()
    private var filteredTechStacks: [String] = []
    
    // MARK: - 뷰 컨트롤러 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        print(data)
        
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

        view.addSubview(navbar)
        navbar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(2)
            $0.height.equalTo(40)
        }
        
        let contentView = UIView()
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(CGFloat.spacing)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(200)
        }
        
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(20)
            make.left.right.equalTo(thumbnailImageView)
        }
        
        contentView.addSubview(techLanguageView)
        techLanguageView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.left.right.equalTo(titleView)
        }
        
        contentView.addSubview(platformView)
        platformView.snp.makeConstraints { make in
            make.top.equalTo(techLanguageView.snp.bottom).offset(20)
            make.left.right.equalTo(titleView)
        }

        let subviews = [recruitmentView, projectIntroView, datepickerView, meetingTypeView, contactMethodView]
        
        let stack = UIStackView(arrangedSubviews: subviews)
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillProportionally
        
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(platformView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(CGFloat.spacing)
        }

        contentView.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.top.equalTo(stack.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(CGFloat.spacing)
            $0.height.equalTo(50)
        }
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navbar.snp.bottom)
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
            $0.height.equalTo(200) // 필요에 따라 조정
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
        //    let projectInfo = Project(projectTitle: "", projecSubtitle: "",techStack: [], recruitmentCount: 1,projectDescription: "", projectID: UUID(), platform: [], teamMember: [])
        //    projectRepository.create(project: projectInfo)
        //    print("aaa")
        if isButtonEnabled {
            isButtonEnabled = false
            // 버튼을 비활성화하고 디바운스 타이머 시작
            completeButton.isEnabled = false
            buttonDebounceTimer = Timer.scheduledTimer(timeInterval: debounceInterval, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
            let projectTitle = titleTextField.text
            let techLanguage = techLanguageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let recruitmentField = recruitmentFieldTextField.text
            let projectDescription = projectIntroTextView.text
            let meetingType = meetingTypeTextField.text
            let contactMethod = contactMethodTextField.text
            
            // TechStack 배열을 생성합니다.
            let techStacks = techLanguage?.components(separatedBy: CharacterSet(charactersIn: "[]"))
                .filter { !$0.isEmpty && $0 != "," }
                .map { TechStack(technologies: [$0]) } ?? []
            
            // 생성된 TechStack 배열을 출력합니다.
            print("TechStacks: \(techStacks)")
            
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
            
            if projectTitle?.isEmpty ?? true ||
                techLanguage?.isEmpty ?? true ||
                recruitmentField?.isEmpty ?? true ||
                projectDescription?.isEmpty ?? true ||
                meetingType?.isEmpty ?? true ||
                contactMethod?.isEmpty ?? true ||
                platformInput?.isEmpty ?? true
            {
                // 어떤 필드라도 비어 있다면 경고를 표시합니다.
                let alertController = UIAlertController(title: "Warning!", message: "Complete your mission", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Copy that.", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                return
            }
            // Firebase에 데이터 업로드
            
            let imageStorage = ImageStorageManager()
            let filename = UUID().uuidString
            let path = "images/" + filename
            
            if let imageData = thumbnailImageView.image?.jpegData(compressionQuality: 0.3) {
                imageStorage.upload(imageData: imageData, path: path) { [self] imageUrl in
                    if let imageUrl = imageUrl {
                        print("이미지 업로드 성공")
                        
                        let projectInfo = Project(
                            projectTitle: projectTitle,
                            projecSubtitle: nil,
                            techStack: techStacks, // 여기에 techStacks 배열을 할당합니다.
                            recruitmentCount: 1,
                            projectDescription: projectDescription,
                            projectDuration: "\(projectStartDate) - \(projectEndDate)",
                            meetingType: meetingType,
                            imageUrl: imageUrl,
                            projectID: self.data?.projectID ?? UUID(),
                            platform: selectedPlatforms,
                            recruitmentField: recruitmentField,
                            recruitingStatus: true,
                            teamMember: [],
                            contactMethod: contactMethod,
                            writerID: self.writerId,
                            projectStartDate: self.projectStartDatePicker.date,
                            projectEndDate: self.projectEndDatePicker.date
                        )
                        self.dismissNewPageViewController()
                        
                        if self.data?.projectID.uuidString == nil {
                            self.projectRepository.create(project: projectInfo)
                            // 프로젝트게시판테이블뷰페이지 최신화 코드
                            NotificationCenter.default.post(name: NSNotification.Name("RefreshDataNotification"), object: nil)
                            
                        } else {
                            self.projectRepository.update(project: projectInfo, projectId: self.data?.projectID.uuidString ?? "")
                            NotificationCenter.default.post(name: NSNotification.Name("RefreshDataNotification"), object: nil)
                        }
                    } else {
                        print("이미지 업로드 실패!")
                    }
                }
            } else {
                print("이미지 데이터가 유효하지 않습니당. 흠..")
            }
        }
    }
    
    @objc func enableButton() {
            isButtonEnabled = true
            completeButton.isEnabled = true
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
        // 텍스트 필드의 현재 텍스트와 변경될 텍스트를 결합합니다.
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
     
        // 새로운 텍스트를 사용하여 자동완성 수행
        let components = newText.components(separatedBy: ",")
        let lastComponent = components.last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        updateSuggestions(for: lastComponent)
     
        // 라벨에 표시될 내용을 출력합니다.
        print("TextField is changing to: \(newText)")
     
        // 텍스트 필드에 대한 직접 변경을 허용합니다.
        return true
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTechName = filteredTechStacks[indexPath.row]
     
        // 현재 텍스트필드의 텍스트를 가져옵니다.
        let currentText = techLanguageTextField.text ?? ""
     
        // 마지막 콤마로 분할하여 마지막 입력된 텍스트를 제외한 나머지를 가져옵니다.
        var components = currentText.components(separatedBy: ",")
        if !components.isEmpty {
            components.removeLast() // 마지막 입력된 텍스트를 제거
        }
     
        // 새로운 태그를 추가합니다.
        let newTag = "[\(selectedTechName)]"
     
        // 새로운 태그를 기존 텍스트에 추가합니다. 여기서 끝에 콤마와 공백을 추가하지 않습니다.
        let newText = (components + [newTag]).joined(separator: "") + ","
        techLanguageTextField.text = newText
     
        // 라벨에 표시될 내용을 출력합니다.
        print("Selected technology: \(selectedTechName), New TextField content: \(newText)")
     
        tableView.isHidden = true
    }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == techLanguageTextField {
            // 현재 텍스트 필드의 텍스트를 가져와서 쉼표로 분리한 후, 공백을 제거합니다.
            var techStacks = textField.text?
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []
       
            // 마지막 입력값이 자동완성 목록에 없으면 "etc"로 대체합니다.
            if let lastTech = techStacks.last, !lastTech.isEmpty {
                let allTechStacks = getAllTechStacks()
                if !allTechStacks.contains(where: { $0.lowercased() == lastTech.lowercased() }) {
                    techStacks[techStacks.count - 1] = "[etc]"
                }
            }
       
            // 변경된 배열을 다시 쉼표로 조합하여 텍스트 필드에 설정합니다.
            let newText = techStacks.joined(separator: "")
            textField.text = newText
            if !techStacks.isEmpty {
                // 마지막에 쉼표와 공백을 추가합니다.
                textField.text?.append(",")
            }
       
            // 라벨에 표시될 내용을 출력합니다.
            print("TextField did end editing with content: \(newText)")
        }
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
   
    // 사용자 입력을 기반으로 제안을 업데이트하는 도우미 함수
    private func updateSuggestions(for text: String) {
        filteredTechStacks = autoCompleteManager.generateSuggestions(for: text)
     
        suggestionsTableView.reloadData()
        suggestionsTableView.isHidden = filteredTechStacks.isEmpty
    }
   
    // TechStack의 모든 기술 스택을 하나의 배열로 반환하는 함수
    private func getAllTechStacks() -> [String] {
        let techStackInstance = TechStack()
        // 이미 'technologies'는 모든 기술을 포함하는 배열이므로, 그대로 반환합니다.
        return techStackInstance.technologies
    }
}
