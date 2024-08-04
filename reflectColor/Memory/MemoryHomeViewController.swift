//
//  MemoryHomeViewController.swift
//  reflectColor
//
//  Created by 森杏菜 on 2024/06/23.
//

import UIKit
import FSCalendar

class MemoryHomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var resetButton: UIButton!
    
    var selectedDates: [Date] = [] // 選択された日付の配列
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true // 複数の日付の選択を許可
        
        // カスタムセルの登録
        calendar.register(HandDrawnCircleCell.self, forCellReuseIdentifier: "handDrawnCircleCell")
        
        // カレンダーの外観設定
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.appearance.weekdayTextColor = UIColor(red: 99 / 255.0, green: 125 / 255.0, blue: 215 / 255.0, alpha: 1.0)
        calendar.layer.borderColor = UIColor(red: 25/255.0, green: 44/255.0, blue: 112/255.0, alpha: 1.0).cgColor // #192C70
        calendar.layer.borderWidth = 3.0
        calendar.layer.cornerRadius = 20
        calendar.layer.masksToBounds = true
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.eventDefaultColor = .green
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = UIColor(red: 25 / 255.0, green: 44 / 255.0, blue: 112 / 255.0, alpha: 0.9)
        calendar.appearance.borderRadius = 1
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "ja")
        
        // リセットボタンの配置
        resetButton.frame = CGRect(x: 136, y: 704, width: 120, height: 35)
        view.addSubview(resetButton)
    }
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if !selectedDates.contains(date) {
            selectedDates.append(date) // 選択された日付を追加
        }
        
        // カレンダーを再読み込みして選択された日付を更新
        calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let index = selectedDates.firstIndex(of: date) {
            selectedDates.remove(at: index) // 選択が解除されたら配列から削除
        }
        
        // カレンダーを再読み込みして選択された日付を更新
        calendar.reloadData()
    }
    
    // MARK:- FSCalendarDelegateAppearance
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at monthPosition: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "handDrawnCircleCell", for: date, at: monthPosition) as! HandDrawnCircleCell
        
        // 日付が選択されている場合、円枠を表示
        cell.contentView.viewWithTag(999)?.isHidden = !selectedDates.contains(date)
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return nil // デフォルトの塗りつぶし色をなしに設定
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return .clear // デフォルトのボーダー色をクリアに設定
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return .clear // 選択時のボーダー色をクリアに設定
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .black // 選択時の文字色を黒に設定
    }
    
    // MARK:- Actions
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        selectedDates.removeAll() // 選択された日付をリセット
        calendar.reloadData() // カレンダーを再読み込みして表示を更新
    }
}
