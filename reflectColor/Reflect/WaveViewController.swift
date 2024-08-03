//
//  WaveViewController.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/08/01.
//

import UIKit

class WaveView: UIView {
    
    var waveColor: UIColor = .blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var displayLink: CADisplayLink!
    private var phase: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc private func updateWave() {
        phase += 0.08
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let width = rect.width
        let height = rect.height / 5 * 4
        let waveHeight: CGFloat = 20
        
        context.clear(rect)
        
        //波線を描く
        context.setLineWidth(2.0)
        context.setStrokeColor(waveColor.cgColor)
        
        let path = CGMutablePath()
        var y = height
        
        path.move(to: CGPoint(x: 0, y: y))
        
        for x in stride(from: 0, to: width, by: 1) {
            y = height + waveHeight * sin(0.015 * x + phase)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        // 波線の下を塗り潰す
        path.addLine(to: CGPoint(x: width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        // 波線より上を白色に塗りつぶす
        let upperPath = CGMutablePath()
        upperPath.addRect(CGRect(x: 0, y: 0, width: width, height: height+waveHeight))
        
        context.setFillColor(waveColor.withAlphaComponent(1).cgColor)
        context.addPath(path)
        context.fillPath()
        
     //波線の下を青色に塗りつぶす
        context.setFillColor(waveColor.cgColor)
        context.addPath(path)
        context.fillPath()
        
        
    }
    
    deinit {
        displayLink.invalidate()
    }
}

class WaveViewController: UIViewController {
    
    private var waveView: WaveView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waveView = WaveView(frame: view.bounds)
        waveView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(waveView)
        
        // 色を変更する場合
        waveView.waveColor = .gray
    }
}


