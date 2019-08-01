//
//  MQFDefaults.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/5/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//

import UIKit

class MQFDefaults: UserDefaults {
    public static let defaults = UserDefaults(suiteName: "RQ9T47YT3S.group.mqf")!
    
    //MARK - KEYS
    public static let mds = "MQF-MDS"
    public static let crewPosition = "MQF-CREW-POSITION"
    public static let pickerMode = "MQF-PICKER-MODE"
    public static let activeMode = "MQF-ACTIVE-MODE"
    public static let activePresetID = "MQF-ACTIVE-PRESET-ID"
    public static let quizSize = "MQF-QUIZ-SIZE"
    public static let squadronHidden = "MQF-SQUADRON-HIDDEN"
    public static let studyLoop = "MQF-STUDY-LOOP"
    public static let hasBeenSetup = "MQF-HAS-BEEN-SETUP"
    
    init() {
        super.init(suiteName: "RQ9T47YT3S.group.mqf")!
    }
    
  
    
    
}


