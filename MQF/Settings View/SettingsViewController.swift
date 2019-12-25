//
//  SettingsViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/4/19.


import UIKit
import Eureka

/// `SettingsViewController`  subclasses `FormViewController`. It controls the Settings view that users see.
class SettingsViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpForm()
    }
    
    /// Overides `valueHasBeenChanged` to save new value to  `MQFDefaults` for Quiz Size
    ///
    /// - parameters
    ///   - row:  `BaseRow`
    ///   - oldValue: `Any?` the old value
    ///   - newValue: `Any?` the new value
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[0] {
            let value = row.baseValue as? Int ?? 0
            MQFDefaults().set(value, forKey: MQFDefaults.quizSize)
            MQFDefaults().synchronize()
        }
        
    }
    
    /// Sets up the form on the screen, should be called from `self.viewDidLoad`
    /// Creates multiple sections displaying different options and relevant messages to the user.
    func setUpForm(){
        let previousQuizSize = MQFDefaults().object(forKey: MQFDefaults.quizSize) as? Int ?? 0
        super.viewDidLoad()
        
        // Instantiates an Eureka form instance
        form
        
            //Add section for number of questions in quiz
            +++ SelectableSection<ListCheckRow<Int>>(header:"Number of Questions in Quiz",footer: "Applies to Study mode only.", selectionType: .singleSelection(enableDeselection: false)){
                
            //Options available (static)
            let options = [["title":"All", "number":0],["title":"Random 10", "number":10],["title":"Random 25", "number":25],["title":"Random 50", "number":50],["title":"Random 100", "number":100], ["title":"Random 200", "number":200]]
                
            //Adds a row for each option
            for option in options {
                $0 <<< ListCheckRow<Int>(option["title"] as? String ?? ""){ listRow in
                    listRow.title = option["title"] as? String ?? ""
                    let num = option["number"] as? Int ?? 0
                    listRow.selectableValue = num
                    listRow.tag = "QuizSize-\(option["title"] as? String ?? "")" //Tags are important, each row must have a unique tag. See Eurkeka documentation for more info.
                    if(previousQuizSize == num){
                        listRow.value = num
                    }else{
                        listRow.value = nil
                    }
                }
            }
            
            }
            
            //Add sections for more settings
            +++ Section(header: "Settings", footer: "Don't see your MDS or crew position? Contact us to get your MQFs added, this app is open to all AF communities. ")
            
            <<< PushRow<String>() {
                $0.title = "MDS (Airframe)"
                $0.selectorTitle = "Pick an MDS"
                $0.options = DataManager.shared.availableMDS
                $0.value = MQFDefaults().object(forKey: MQFDefaults.mds) as? String ?? "C-17"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }.onChange { row in // Handle changes
                if(row.value != nil){
                    MQFDefaults().set(row.value, forKey: MQFDefaults.mds)
                }else{
                    row.value = MQFDefaults().string(forKey: MQFDefaults.mds) ?? "C-17"
                }
                MQFDefaults().synchronize() // saves defaults
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
            <<< SwitchRow() {
                $0.title = "Study on a Loop"
                $0.value = MQFDefaults().object(forKey: MQFDefaults.studyLoop) as? Bool ?? true
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }.onChange { row in
                if(row.value != nil){
                    MQFDefaults().set(row.value, forKey: MQFDefaults.studyLoop)
                }else{
                    row.value = MQFDefaults().object(forKey: MQFDefaults.studyLoop) as? Bool ?? true
                }
                MQFDefaults().synchronize()
            }
            
            
            //Adds section with information, disclaimers, and credits
            +++ Section(header: "About", footer: "MQFs was built by aircrew for aircrew. We hope to make one small aspect of your life simpler and easier with this app. Please help us continue to improve this app by sending feedback to AirmenCoders@us.af.mil.")
            
            <<< LabelRow() {
                $0.title = "Version"
                $0.value = self.version()
            }
            <<< LabelRow() {
                $0.title = "Build"
                $0.value = self.build()
            }
            
            +++ Section(header: "Disclaimer:", footer: "This app is not the official source for MQF studying, just a tool to help you. Check your ePubs and with your OGV & A3V for the official MQF. We have made every effort to have the app reflect your MQF, including all typos.")
            +++ Section(header: "Credits:", footer: "We built this app using some awesome images including in app icons made by Freepik from www.flaticon.com and other frameworks licensed with the MIT License.")
        
    }
    
    /// Returns current app version  number
    /// Uses xCode project version
    ///
    ///
    /// - returns: version number as `String`
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as? String
        return version ?? "None"
    }
    /// Returns current build number
    /// Uses xCode build number
    /// - returns: build number as `String`
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
    
    ///Dismisses View
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
