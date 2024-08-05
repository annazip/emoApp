//
//  ViewController.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/06/16.
//

import UIKit

class ReflectHomeViewController: UIViewController {
    
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = UITabBar()
        
        tabBar.frame = CGRect(x: 0, y: view.frame.height - 88, width: view.frame.width, height: 88)
        
        // タブバーの背景色
        tabBar.backgroundColor = UIColor(red: 248/255.0, green: 247/255.0, blue: 253/255.0, alpha: 1.0)

        // 角丸く
        let maskPath = UIBezierPath(roundedRect: tabBar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = tabBar.bounds
        maskLayer.path = maskPath.cgPath
        tabBar.layer.mask = maskLayer
        
        // 影
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.15
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 5
        
        // 角丸と影の表示
        let containerView = UIView(frame: tabBar.frame)
        containerView.layer.shadowColor = tabBar.layer.shadowColor
        containerView.layer.shadowOpacity = tabBar.layer.shadowOpacity
        containerView.layer.shadowOffset = tabBar.layer.shadowOffset
        containerView.layer.shadowRadius = tabBar.layer.shadowRadius
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = false
        containerView.backgroundColor = .clear
        
        tabBar.frame.origin = .zero
        containerView.addSubview(tabBar)
        
        view.addSubview(containerView)
    }
    
    @IBAction func pushButton() {
        self.performSegue(withIdentifier: "toRecordView", sender: nil)
    }
}
