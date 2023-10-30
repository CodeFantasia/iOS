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
    
    // MARK: - Keyboard 눌렀을 때 View 올리기

//    func setKeyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
//    }
//    
//    @objc func keyboardWillShow(notification: NSNotification) {
//          if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                  let keyboardRectangle = keyboardFrame.cgRectValue
//                  let keyboardHeight = keyboardRectangle.height
//              UIView.animate(withDuration: 1) {
//                  self.view.window?.frame.origin.y -= keyboardHeight
//              }
//          }
//      }
//    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.window?.frame.origin.y != 0 {
//            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                    let keyboardRectangle = keyboardFrame.cgRectValue
//                    let keyboardHeight = keyboardRectangle.height
//                UIView.animate(withDuration: 1) {
//                    self.view.window?.frame.origin.y += keyboardHeight
//                }
//            }
//        }
//    }
}
