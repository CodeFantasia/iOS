//
//  MyProjectVC.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/13/23.
//  탭바를 위해 임시로 만든 파일 추후에 프로필 페이지 완성 시 삭제 후 탭바 수정 필요

import UIKit
import SnapKit


class MyProjectVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "첫 번째 탭"
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
