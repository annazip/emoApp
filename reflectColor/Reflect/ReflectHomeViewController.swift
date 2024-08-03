//
//  ViewController.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/06/16.
//

import UIKit
//import WaveAnimationView

class ReflectHomeViewController: UIViewController {
    
    @IBOutlet var button: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let wave = WaveAnimationView(frame: CGRect, color: UIColor)
//
//        wave.startAnimation()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pushButton() {
        self.performSegue(withIdentifier: "toRecordView", sender: nil)
        
            tabBarController?.tabBar.isHidden = true
    }
    


}

