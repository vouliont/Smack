//
//  MessageCell.swift
//  Smack
//
//  Created by Владислав on 1/23/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var userImg: BorderedImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(message: Message) {
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        userName.text = message.userName
        messageDate.text = ""
        messageBody.text = message.message
    }

}
