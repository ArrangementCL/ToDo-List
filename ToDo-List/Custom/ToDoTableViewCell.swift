//
//  ToDoTableViewCell.swift
//  ToDo-List
//
//  Created by 陳列 on 2022/3/30.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var toDoTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
