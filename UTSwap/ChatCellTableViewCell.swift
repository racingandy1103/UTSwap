//
//  ChatCellTableViewCell.swift
//  UTSwap
//
//  Created by Jessica Trejo on 11/20/21.
//

import UIKit

class ChatCellTableViewCell: UITableViewCell {

    @IBOutlet weak var chatText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if chatText != nil {
            self.chatText.numberOfLines = 0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
