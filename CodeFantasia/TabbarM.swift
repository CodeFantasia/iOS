//
//  TabbarM.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/13/23.
//

import UIKit
import SnapKit
import FirebaseAuth

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        logUserOut()
        authenticateUserAndConfigureUI()
    }
    
    // MARK: - API
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.view.backgroundColor = UIColor.primaryColor
                
                let loginController = UINavigationController(rootViewController: LoginController())
                loginController.modalPresentationStyle = .fullScreen
                self.present(loginController, animated: false)
            }
        } else {
            configureUI()
        }
    }

    // 테스트 용!
//    func logUserOut() {
//        do {
//            try Auth.auth().signOut()
//            print("🤍 로그아웃 성공! 🤍")
//        } catch let error {
//            print("🤍 로그아웃 실패 ㅠㅠ \(error) 🤍")
//        }
//    }
    
    // MARK: - Helpers
    
    func configureUI() {
        let userId = Auth.auth().currentUser?.uid
        tabBar.isTranslucent = true
        
        let iconSize = CGSize(width: 25, height: 25)
        
        let tabbarMyProjectVC = UINavigationController(rootViewController: MyProjectVC(viewModel: MyProjectViewModel(projectRepository: ProjectRepository(firebaseBaseManager: FireBaseManager()), projectId: userId!)))
        let firstTabIcon = UIImage(named: "TabbarMyProject")?.withRenderingMode(.alwaysOriginal).resize(to: iconSize)
        tabbarMyProjectVC.tabBarItem = UITabBarItem(title: "나의 프로젝트", image: firstTabIcon, tag: 0)
        
        let tabbarMainVC = UINavigationController(rootViewController: ProjectBoardVC())
        let secondTabIcon = UIImage(named: "TabbarHome")?.withRenderingMode(.alwaysOriginal).resize(to: iconSize)
        tabbarMainVC.tabBarItem = UITabBarItem(title: "홈", image: secondTabIcon, tag: 1)
        let tabbarProfileVC = UINavigationController(rootViewController: ProfileViewController(viewModel: ProfileViewModel(userRepository: UserRepository(firebaseBaseManager: FireBaseManager()), userId: userId!)))
        let thirdTabIcon = UIImage(named: "TabbarProfile")?.withRenderingMode(.alwaysOriginal).resize(to: iconSize)
        tabbarProfileVC.tabBarItem = UITabBarItem(title: "프로필", image: thirdTabIcon, tag: 2)
        
        tabBar.tintColor = UIColor.black
        tabBar.backgroundColor = UIColor.clear
        
        viewControllers = [tabbarMyProjectVC, tabbarMainVC, tabbarProfileVC]
    }

}
