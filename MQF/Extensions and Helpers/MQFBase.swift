//
//  MQFBase.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/7/19.

import UIKit
import SwiftyJSON

/// Represents a base in the app, such as "Charleston AFB"
class MQFBase: NSObject {
    /// Name of the base
    public var name:String
    
    /// Array of presets attached to this base
    public var presets:[MQFPreset]
    
    /// Init empty MQFBase - DO NOT USE THIS ONE
    override init() {
        self.name = "Unknown"
        self.presets = [MQFPreset]()
    }
    
    /// Init instance of MQFBase using given `JSON`
    ///
    /// - parameters:
    ///   - json:  `JSON` for the desired MQF Base
    /// - returns: `MQFBase`
    init(json:JSON){
        let dict = json.dictionary ?? [String:JSON]()
        self.name = dict["name"]?.string ?? "Base not found"
        self.presets = [MQFPreset]()
        for preset in dict["presets"]?.array ?? [JSON]() {
            let p = MQFPreset(json: preset)
            self.presets.append(p)
        }
    }
}
