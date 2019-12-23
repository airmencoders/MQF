//
//  SetUpViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 7/31/19.


import UIKit
import Eureka
class SetUpViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let previousQuizSize = MQFDefaults().object(forKey: MQFDefaults.quizSize) as? Int ?? 0
        form +++ Section(header: "Choose your MDS & Crew Position", footer: "You can always change them later in Settings. Don't see your MDS or crew position? Contact us to get your MQFs added, this app is open to all AF communities.")
            
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
        
            <<< ButtonRow(){ row in
                row.title = "Begin"
                row.onCellSelection({ (button, row) in
                    print("button on select")
                    self.dismissSetup()
                    
                })
        }
            
       //mark set up as shown
        MQFDefaults().set(true, forKey: MQFDefaults.hasBeenSetup)
        MQFDefaults().synchronize()
    
    }
    func dismissSetup(){
        self.dismiss(animated: true, completion: nil)
    }
        
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[0] {
            let value = row.baseValue as? Int ?? 0
            MQFDefaults().set(value, forKey: MQFDefaults.quizSize)
            MQFDefaults().synchronize()
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
