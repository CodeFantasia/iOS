//
//  FilterBottomSheetVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 11/1/23.
//

import UIKit
import SnapKit
import Then

protocol FilterBottomSheetDelegate: AnyObject {
    func didApplyFilter(showOngoingProjectsOnly: Bool)
}

class FilterBottomSheetVC: UIViewController {

    var isRecruiting: Bool = false
    weak var delegate: FilterBottomSheetDelegate?

    private let recruitingSwitch = UISwitch()
    private let applyButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        setupUI()
    }

    func setupUI() {
        let label = UILabel()
        label.text = "모집 중만 보기"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
        }

        view.addSubview(recruitingSwitch)
        recruitingSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(label)
            make.right.equalTo(view.snp.right).offset(-20)
        }

        applyButton.primaryColorConfigure(title: "적용")
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    @objc func applyButtonTapped() {
        isRecruiting = recruitingSwitch.isOn
        delegate?.didApplyFilter(showOngoingProjectsOnly: isRecruiting)
        dismiss(animated: true, completion: nil)
    }
}
