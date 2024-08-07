//
//  WaveViewController.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/08/01.
//

import UIKit

class WaveView: UIView {
    
    // デフォルトの波線
    var waveColor = UIColor(red: 130/255.0, green: 130/255.0, blue: 130/255.0, alpha: 0.15) {
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
        backgroundColor = .white
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
        
        // 背景を白で塗りつぶす
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)
        
        // 波線を描く
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
        
        // 波線の色で塗りつぶす
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
        
    
    }
}

