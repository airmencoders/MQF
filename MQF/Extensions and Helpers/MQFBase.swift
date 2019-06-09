//
//  MQFBase.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/7/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
class MQFBase: NSObject {

    public var name:String
    public var presets:[MQFPreset]
    
    override init() {
        self.name = "Unknown"
        self.presets = [MQFPreset]()
    }
    
    init(json:JSON){
        let dict = json.dictionary ?? [String:JSON]()
        self.name = dict["base"]?.string ?? "Base not found"
        self.presets = [MQFPreset]()
        for preset in dict["presets"]?.array ?? [JSON]() {
            let p = MQFPreset(json: preset)
            self.presets.append(p)
        }
    }
}
