//
//  UIViewController+.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/23.
//

import UIKit

extension UIViewController: UIGestureRecognizerDelegate {
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
    
    // MARK: - Dismiss Keyboard
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Keyboard 눌렀을 때 View 올리기
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let yOffset: CGFloat = 50 // 원하는 스크롤 양을 설정하세요.
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= min(keyboardSize.height, yOffset)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
// 사용할 때 이렇게 사용하면 됨
//override func viewDidLoad() {
//  super.viewDidLoad()
//
//  setKeyboardObserver()
//}
//
//deinit {
//
//  removeKeyboardObserver()
//}
