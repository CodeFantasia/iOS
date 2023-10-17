//
//  TabbarM.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/13/23.
//

import UIKit
import SnapKit

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
    override func viewDidLoad() {
        tabBar.isTranslucent = true
        super.viewDidLoad()
        
        let iconSize = CGSize(width: 25, height: 25)
        
        let tabbarMyProjectVC = UINavigationController(rootViewController: MyProjectVC())
        let firstTabIcon = UIImage(named: "TabbarMyProject")?.withRenderingMode(.alwaysOriginal).resize(to: iconSize)
        tabbarMyProjectVC.tabBarItem = UITabBarItem(title: "나의 프로젝트", image: firstTabIcon, tag: 0)
        
        let tabbarMainVC = UINavigationController(rootViewController: ProjectBoardVC())
        let secondTabIcon = UIImage(named: "TabbarHome")?.withRenderingMode(.alwaysOriginal).resize(to: iconSize)
        tabbarMainVC.tabBarItem = UITabBarItem(title: "홈", image: secondTabIcon, tag: 1)
        
        let tabbarProfileVC = UINavigationController(rootViewController: ProfileVC())
        let thirdTabIcon = UIImage(named: "TabbarProfile")?.withRenderingMode(.alwaysOriginal).resize(to: iconSize)
        tabbarProfileVC.tabBarItem = UITabBarItem(title: "프로필", image: thirdTabIcon, tag: 2)
        
        tabBar.tintColor = UIColor.black
        tabBar.backgroundColor = UIColor.clear
        
        viewControllers = [tabbarMyProjectVC, tabbarMainVC, tabbarProfileVC]
    }
}
