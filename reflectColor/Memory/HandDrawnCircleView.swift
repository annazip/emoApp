//
//  HandDrawnCircleView.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/06/23.
//

import UIKit

class HandDrawnCircleView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            drawHandwrittenCircle(in: context, rect: rect)
        }
    }
    
    private func drawHandwrittenCircle(in context: CGContext, rect: CGRect) {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius: CGFloat = min(rect.width, rect.height) / 4
        
     
        let customColor = UIColor(red: 99 / 255.0, green: 125 / 255.0, blue: 215 / 255.0, alpha: 1.0)


        
        context.setStrokeColor(customColor.cgColor)
        context.setLineWidth(1.5) // ラインの太さを細く
        
        let segments = 100
        let variance: CGFloat = 1.0 // ばらつきを減らす
        
        context.beginPath()
        
        for i in 0...segments {
            let angle = CGFloat(i) * (2.0 * .pi / CGFloat(segments))
            
            let x = center.x + (radius + CGFloat(arc4random_uniform(UInt32(variance * 2))) - variance) * cos(angle)
            let y = center.y + (radius + CGFloat(arc4random_uniform(UInt32(variance * 2))) - variance) * sin(angle)
            
            if i == 0 {
                context.move(to: CGPoint(x: x, y: y))
            } else {
                context.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        context.closePath()
        context.setLineCap(.round) // ラインの終わりを丸くする
        context.setLineJoin(.round) // ラインの結合部を丸くする
        context.strokePath()
    }
}
