//
//  ButtonWithCornerRadius.swift
//  Smack
//
//  Created by Владислав on 1/16/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }

}
