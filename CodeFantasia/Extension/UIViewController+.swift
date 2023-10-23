//
//  UIViewController+.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/23.
//

import UIKit

extension UIViewController {
    func alertViewActionSheet(
        title: String?,
        message: String?,
        acceptText: String? = "확인",
        cancelText: String?,
        acceptCompletion: (()->Void)? = nil,
        cancelCompletion: (()->Void)? = nil
    ) {
        let uiAlertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if let cancelText {
            let cancelAction = UIAlertAction(title: cancelText, style: .destructive) { _ in cancelCompletion?() }
            uiAlertController.addAction(cancelAction)
        }
        if let acceptText {
            let acceptAction = UIAlertAction(title: acceptText, style: .default) { _ in acceptCompletion?() }
            uiAlertController.addAction(acceptAction)
        }
        present(uiAlertController, animated: true)
    }
    
    func alertViewAlert(
        title: String?,
        message: String?,
        acceptText: String? = "확인",
        cancelText: String?,
        acceptCompletion: (()->Void)? = nil,
        cancelCompletion: (()->Void)? = nil
    ) {
        let uiAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelText {
            let cancelAction = UIAlertAction(title: cancelText, style: .destructive) { _ in cancelCompletion?() }
            uiAlertController.addAction(cancelAction)
        }
        if let acceptText {
            let acceptAction = UIAlertAction(title: acceptText, style: .default) { _ in acceptCompletion?() }
            uiAlertController.addAction(acceptAction)
        }
        present(uiAlertController, animated: true)
    }
}
