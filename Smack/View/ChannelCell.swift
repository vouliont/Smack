//
//  ChannelCell.swift
//  Smack
//
//  Created by Владислав on 1/22/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel) {
        let title = channel.name ?? ""
        channelName.text = "#\(title)"
        
        if MessageService.instance.uncheckedChannels.contains(channel._id) {
            channelName.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        } else {
            channelName.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        }
    }

}
