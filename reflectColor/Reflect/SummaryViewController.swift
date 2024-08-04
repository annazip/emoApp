//
//  SummaryViewController.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/06/23.
//

import UIKit

class SummaryViewController: UIViewController {
    @IBOutlet var end: UIButton!
    @IBOutlet var background: UILabel!
    @IBOutlet var eachBackgrounds: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgrounds()
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
