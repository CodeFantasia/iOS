//
//  NewPageViewModel.swift
//  CodeFantasia
//
//  Created by t2023-m0049 on 2023/10/24.
//

import RxSwift
import RxCocoa

class NewPageViewModel {
    let title = BehaviorRelay<String?>(value: nil)
    let thumbnail = BehaviorRelay<String?>(value: nil)
    let platform = BehaviorRelay<String?>(value: nil)
    let techLanguage = BehaviorRelay<String?>(value: nil)
    let recruitmentField = BehaviorRelay<String?>(value: nil)
    let projectIntro = BehaviorRelay<String?>(value: nil)
//    let projectDate = BehaviorRelay<Date>(value: Date())

    func saveButtonTapped() {
        // 저장 로직을 이곳에 구현
    }
}
