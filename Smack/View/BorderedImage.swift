//
//  BorderedImage.swift
//  Smack
//
//  Created by Владислав on 1/21/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedImage: UIImageView {

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setView()
    }
    
    func setView() {
        self.layer.cornerRadius = self.frame.width / 2
    }

}
