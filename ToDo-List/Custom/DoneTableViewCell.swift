//
//  DoneTableViewCell.swift
//  ToDo-List
//
//  Created by 陳列 on 2022/3/30.
//

import UIKit

class DoneTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var doneTextField: UITextField!
    @IBOutlet weak var completeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
