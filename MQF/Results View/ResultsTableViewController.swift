//
//  ResultsTableViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/2/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {
    var session:QKSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return 1
        }
        return session?.questionCount ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as! SummaryTableViewCell
            cell.correctOutlet.text = "\(session?.score ?? 0)"
            let incorrect = (session?.questionCount ?? 0) - (session?.score ?? 0)
            cell.incorrectOutlet.text = "\(incorrect)"
            
            let percent = Double(session?.score ?? 0) / Double(session?.questionCount ?? 0)
            cell.scoreCircle.value = CGFloat(percent*100)
            cell.scoreCircle.style = .dotted
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        let question = session?.question(for: indexPath.row)
        cell.setUp(question: question!, session: session!)
      //  cell.selectedAnswer.text = question.

        // Configure the cell...

        return cell
    }
 
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if(indexPath.section == 0){
//            return 200
//        }
//        return 200
//    }
//
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
