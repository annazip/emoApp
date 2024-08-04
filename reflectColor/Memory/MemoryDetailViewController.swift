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

    func didUpdateMemoryDetails() {
        // メモリの詳細が更新されたときの処理をここに追加
        print("Memory details updated")
    }
}
