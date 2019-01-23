//
//  ModalCreateChannelVC.swift
//  Smack
//
//  Created by Владислав on 1/22/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class ModalCreateChannelVC: UIViewController {

    // Outlets
    @IBOutlet weak var channelNameTxt: UITextField!
    @IBOutlet weak var channelDescriptionTxt: UITextField!
    @IBOutlet weak var bgColor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ModalCreateChannelVC.closeTap))
        bgColor.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelBtnPressed(_ sender: Any) {
        guard let name = channelNameTxt.text, channelNameTxt.text != "" else { return }
        guard let description = channelDescriptionTxt.text else { return }
        
        SocketService.instance.addChannel(name: name, description: description) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupView() {
        channelNameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceholder])
        channelDescriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
    }
    
}
