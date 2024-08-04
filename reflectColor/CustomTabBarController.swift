//
//  CustomTabBarController.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/07/18.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タブバーの影を設定する
        tabBar.layer.shadowColor = UIColor.black.cgColor // 影の色
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -3) // 影の方向（上向きに -3）
        tabBar.layer.shadowOpacity = 0.3 // 影の透明度
        tabBar.layer.shadowRadius = 4.0 // 影のぼかし半径
    }
}
