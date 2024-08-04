//
//  RealmSwift.swift
//  realm_practice
//
//  Created by 森杏菜 on 2024/07/21.
//

import Foundation
import RealmSwift

class reflect: Object {
    ///yyyy.MM.dd
    @objc dynamic var date: String = ""
    /// 出来事_gpt
    @objc dynamic var dekigoto_gpt: String = " "
    /// good_or_bad
    @objc dynamic var good_or_bad: Bool = false
    ///detail_gpt
    @objc dynamic var detail_gpt : String = " "
    ///good_action_gpt
    @objc dynamic var good_action_gpt : [String] = []
    ///bad_kadai_gpt
    @objc dynamic var bad_kadai_gpt : String = " "
    ///bad_action_gpt
    @objc dynamic var bad_action_gpt : [String] = []
}

