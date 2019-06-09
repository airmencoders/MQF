//
//  SettingsViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/4/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//

import UIKit
import Eureka
class SettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

let previousQuizSize = MQFDefaults().object(forKey: MQFDefaults.quizSize) as? Int ?? 0
            super.viewDidLoad()
        form +++ SelectableSection<ListCheckRow<Int>>(header:"Number of Questions in Quiz",footer: "Applies to both Study and Test quizes.", selectionType: .singleSelection(enableDeselection: false)){
            let options = [["title":"All", "number":0],["title":"Random 7", "number":7],["title":"Random 25", "number":25],["title":"Random 50", "number":50],["title":"Random 100", "number":100], ["title":"Random 200", "number":200]]
            for option in options {
                $0 <<< ListCheckRow<Int>(option["title"] as? String ?? ""){ listRow in
                    listRow.title = option["title"] as? String ?? ""
                    let num = option["number"] as? Int ?? 0
                    listRow.selectableValue = num
                    listRow.tag = "QuizSize-\(option["title"] as? String ?? "")"
                    if(previousQuizSize == num){
                        listRow.value = num
                    }else{
                        listRow.value = nil
                    }
                }
            }
           
            }
           
                +++ Section("Settings")
        
                <<< PushRow<String>() {
                    $0.title = "MDS (Airframe)"
                    $0.selectorTitle = "Pick an MDS"
                    $0.options = DataManager.shared.availableMDS
                    $0.value = MQFDefaults().object(forKey: MQFDefaults.mds) as? String ?? "C-17"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.onChange { row in
                        if(row.value != nil){
                            MQFDefaults().set(row.value, forKey: MQFDefaults.mds)
                        }else{
                            row.value = MQFDefaults().string(forKey: MQFDefaults.mds) ?? "C-17"
                        }
                        MQFDefaults().synchronize()
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.textLabel?.textColor = .red
                            print("invalid")
                        }
                }
                <<< PushRow<String>() {
                    $0.title = "Crew Position"
                    $0.selectorTitle = "Pick a position"
                    $0.options = DataManager.shared.availableCrewPositions
                    $0.value = MQFDefaults().object(forKey: MQFDefaults.crewPosition) as? String ?? "Pilot"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.onChange { row in
                        if(row.value != nil){
                            MQFDefaults().set(row.value, forKey: MQFDefaults.crewPosition)
                        }else{
                            row.value = MQFDefaults().string(forKey: MQFDefaults.crewPosition) ?? "C-17"
                        }
                        MQFDefaults().synchronize()
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.textLabel?.textColor = .red
                            print("invalid")
                        }
                }
        
        +++ Section(header: "About", footer: "MQFs was built by aircrew for aircrew. We hope to make one small aspect of your life simpler and easier with this app. Please help us continue to improve this app by sending feedback to christian.brechbuhl@us.af.mil.")
                
                <<< LabelRow() {
                    $0.title = "Version"
                    $0.value = self.version()
        }
                <<< LabelRow() {
                    $0.title = "Build"
                    $0.value = self.build()
        }
        
                +++ Section(header: "Credits:", footer: "We built this app using some awesome images inlcuding in app icons made by Freepik from www.flaticon.com and other frameworks licensed with the MIT License.")
     
        
    }
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[0] {
           let value = row.baseValue as? Int ?? 0
            MQFDefaults().set(value, forKey: MQFDefaults.quizSize)
            MQFDefaults().synchronize()
        }
        
    }

    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as? String
        return version ?? "None"
    }
    func build() -> String{
        let dictionary = Bundle.main.infoDictionary!
    let build = dictionary["CFBundleVersion"] as? String
        return build ?? "None"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
