//
//  SummaryTableViewCell.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/2/19.


import UIKit
import UICircularProgressRing
class SummaryTableViewCell: UITableViewCell {

    @IBOutlet var correctOutlet: UILabel!
    @IBOutlet var incorrectOutlet: UILabel!
    @IBOutlet var scoreCircle: UICircularProgressRing!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
