//
//  FilterBottomSheetVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 11/1/23.
//

import UIKit
import SnapKit
import Then

// MARK: - FilterBottomSheetDelegate
// 필터 적용에 대한 델리게이트 프로토콜입니다.

protocol FilterBottomSheetDelegate: AnyObject {
    func didApplyFilter(showOngoingProjectsOnly: Bool)
}

// MARK: - FilterBottomSheetVC
// 사용자가 프로젝트를 필터링 할 수 있는 바텀 시트 뷰 컨트롤러입니다.

class FilterBottomSheetVC: UIViewController {

    // MARK: - Properties
    // 바텀 시트의 상태 및 델리게이트를 정의합니다.
    
    var isRecruiting: Bool = false
    weak var delegate: FilterBottomSheetDelegate?

    // MARK: - UI Components
    // 바텀 시트의 UI 컴포넌트를 정의합니다.
    
    private let recruitingSwitch = UISwitch()
    private let applyButton = UIButton()

    // MARK: - Lifecycle Methods
    // 뷰 컨트롤러의 생명주기 관련 메소드입니다.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        setupUI()
    }

    // MARK: - Setup
    // UI 구성 및 레이아웃 설정 메소드입니다.
    
    func setupUI() {
        // 레이블 및 스위치 설정
        let label = UILabel()
        label.text = "모집 중만 보기"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
        }

        // 모집 중 스위치 설정
        view.addSubview(recruitingSwitch)
        recruitingSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(label)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
//        // "기술 및 언어" 라벨 설정
//        let skillsAndLanguagesLabel = UILabel()
//        skillsAndLanguagesLabel.text = "기술 및 언어"
//        view.addSubview(skillsAndLanguagesLabel)
//        skillsAndLanguagesLabel.snp.makeConstraints { make in
//            make.top.equalTo(recruitingSwitch.snp.bottom).offset(20)
//            make.left.equalTo(view.snp.left).offset(20)
//        }
//
//        // 텍스트 필드 설정
//        let skillsAndLanguagesTextField = UITextField()
//        skillsAndLanguagesTextField.borderStyle = .roundedRect
//        view.addSubview(skillsAndLanguagesTextField)
//        skillsAndLanguagesTextField.snp.makeConstraints { make in
//            make.top.equalTo(skillsAndLanguagesLabel.snp.bottom).offset(10)
//            make.left.right.equalToSuperview().inset(20)
//            make.height.equalTo(40)
//        }


        // 적용 버튼 설정
        applyButton.primaryColorConfigure(title: "적용")
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    // MARK: - Actions
    // 사용자 인터랙션에 대한 액션 메소드입니다.
    
    @objc func applyButtonTapped() {
        isRecruiting = recruitingSwitch.isOn
        delegate?.didApplyFilter(showOngoingProjectsOnly: isRecruiting)
        dismiss(animated: true, completion: nil)
    }
}

