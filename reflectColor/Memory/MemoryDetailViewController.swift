//
//  MemoryDetailViewController.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/06/23.
//

import UIKit

class MemoryDetailViewController: UIViewController, MemoryMoreDetailViewControllerDelegate {
    
    @IBOutlet var background: UILabel!
    @IBOutlet var eachBackgrounds: [UILabel]!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgrounds()
        
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
    
    func setupBackgrounds() {
        eachBackgrounds.forEach { label in
            label.layer.cornerRadius = 10
            label.clipsToBounds = true
        }
        
        background.layer.cornerRadius = 10
        background.layer.borderColor = UIColor(red: 25/255, green: 44/255, blue: 112/255, alpha: 1.0).cgColor
        background.layer.borderWidth = 2.0
        background.clipsToBounds = true
    }
    
    @IBAction func showHalfModal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HalfModal")
        guard let modalVC = vc as? MemoryMoreDetailViewController else { return }
        modalVC.delegate = self

        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        } else {
            modalVC.modalPresentationStyle = .pageSheet
        }
        
        modalVC.view.layer.cornerRadius = 50
        modalVC.view.layer.masksToBounds = true
        
        self.present(modalVC, animated: true)
    }
    
//    @IBAction func back() {
//
//    dismiss(animated: true)
//    }
    

    func didUpdateMemoryDetails() {
        // メモリの詳細が更新されたときの処理をここに追加
        print("Memory details updated")
    }
}
