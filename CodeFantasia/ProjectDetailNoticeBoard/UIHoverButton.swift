//
//  UIHoverButton.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/17.
//

import UIKit
import RxSwift
import RxCocoa

class UIHoverButton: UIButton {

    private let disposeBag: DisposeBag
    private var buttonColor: UIColor? {
        backgroundColor
    }
    
    init(_ disposeBag: DisposeBag = .init()) {
        self.disposeBag = disposeBag
        super.init(frame: .zero)
        bind()
    }
    
    private func bind() {
        
        rx.controlEvent(.touchDown)
            .observe(on: MainScheduler.instance)
            .bind { _ in
                self.layer.opacity = 0.3
            }
            .disposed(by: disposeBag)
        
        Observable.merge(
            rx.controlEvent(.touchCancel).map {},
            rx.controlEvent(.touchUpInside).map {},
            rx.controlEvent(.touchUpOutside).map {}
        )
        .observe(on: MainScheduler.instance)
        .bind { _ in
            self.layer.opacity = 1.0
        }
        .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
