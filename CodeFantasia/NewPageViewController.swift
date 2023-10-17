//
//  NewPageViewController.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/16.
//

import UIKit

class NewPageViewController: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // 배경색을 하얀색으로 설정
        view.backgroundColor = UIColor.white

        // 뒤로가기 버튼 생성
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backbutton"), for: .normal) // 이미지 설정
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.frame = CGRect(x: 10, y: 40, width: 30, height: 30) // Adjusted position and size
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)


        // 임시저장 버튼 생성
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("임시저장", for: .normal)
        saveButton.frame = CGRect(x: view.bounds.width - 110, y: 60, width: 100, height: 30) // Adjusted y position
        saveButton.backgroundColor = UIColor(hex: 0x000000) // 색상 변경
        saveButton.layer.cornerRadius = 15 // 버튼 모서리 둥글게
        saveButton.setTitleColor(.white, for: .normal) // 글씨색을 하얀색으로 설정
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)


        // 스크롤뷰 생성
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height - 130))
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000) // ContentSize 조절
        view.addSubview(scrollView)

        // 스택뷰 생성
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill

        // 레이블과 입력 요소들 생성 및 설정
        func createLabel(text: String) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = UIColor(hex: 0x000000) // 색상 코드 67C99D에 해당하는 색으로 변경
            return label
        }
        //  텍스트필드 생성함수
        func createTextField() -> UITextField {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.layer.cornerRadius = 8
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.black.cgColor
            textField.backgroundColor = UIColor.white
            return textField
        }
        // 텍스트뷰 생성함수
        func createTextView() -> UITextView {
            let textView = UITextView()
            textView.layer.cornerRadius = 8
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.black.cgColor
            textView.backgroundColor = UIColor.white
            textView.heightAnchor.constraint(equalToConstant: 100).isActive = true // Set the height here
            return textView
        }
        // 콤보박스 텍스트필드 생성함수
        func areateTextField() -> UITextField {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.layer.cornerRadius = 8
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.black.cgColor
            textField.backgroundColor = UIColor.white
            return textField
        }
        // 데이트피커 생성 함수
        func createDatePicker() -> UIDatePicker {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            return datePicker
        }
        // 이 텍스트필드를 건드리면
        func createTextFieldWithAction(placeholder: String, action: Selector) -> UITextField {
             let textField = UITextField()
             textField.borderStyle = .roundedRect
             textField.layer.cornerRadius = 8
             textField.layer.borderWidth = 1
             textField.layer.borderColor = UIColor.black.cgColor
             textField.backgroundColor = UIColor.white
             textField.placeholder = placeholder
             textField.addTarget(self, action: action, for: .editingDidBegin) // 연락 방법 텍스트 필드에 대한 액션 추가
             return textField
         }

        let elements: [(String, UIView)] = [
            ("제목", createTextField()),
            ("썸네일", createTextView()),
            ("출시 플랫폼", createTextField()),
            ("모집 기술 및 언어", createTextField()),
            ("모집 분야", createTextField()),
            ("프로젝트 소개", createTextView()),
            ("프로젝트 기간", createDatePicker()),
            ("", createDatePicker()),
            ("모임 유형", createTextField()),
            ("신청 시 연락 방법", createTextField())
        ]

        elements.forEach { labelText, element in
            let label = createLabel(text: labelText)
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(element)
        }

        // 작성 완료 버튼 생성
        let completeButton = UIButton(type: .system)
        completeButton.setTitle("작성 완료", for: .normal)
        completeButton.frame = CGRect(x: 10, y: scrollView.contentSize.height + 20, width: view.bounds.width - 20, height: 30) // 좌우 여백 수정
        completeButton.backgroundColor = UIColor(hex: 0x000000) // 색상 변경
        completeButton.layer.cornerRadius = 15 // 버튼 모서리 둥글게
        completeButton.setTitleColor(.white, for: .normal) // 글씨색을 하얀색으로 설정
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(completeButton) // stackView에 추가

        stackView.addArrangedSubview(completeButton) // stackView에 추가

        stackView.addArrangedSubview(completeButton)

        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -20)
        ])
    }

    @objc private func backButtonTapped() {
        // 뒤로가기 버튼이 눌렸을 때의 동작
    }

    @objc private func saveButtonTapped() {
        // 임시저장 버튼이 눌렸을 때의 동작
    }

    @objc private func completeButtonTapped() {
        // 작성 완료 버튼이 눌렸을 때의 동작
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
