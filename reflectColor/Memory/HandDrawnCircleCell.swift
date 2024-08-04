//
//  HandDrawnCircleCell.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/06/23.
//

import UIKit
import FSCalendar

class HandDrawnCircleCell: FSCalendarCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircleView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCircleView()
    }

    private func setupCircleView() {
        let circleView = HandDrawnCircleView(frame: self.contentView.bounds)
        circleView.tag = 999
        circleView.backgroundColor = UIColor.clear
        self.contentView.addSubview(circleView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let circleView = self.contentView.viewWithTag(999) {
            circleView.frame = self.contentView.bounds
        }
    }
}


