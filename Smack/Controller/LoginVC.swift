//
//  LoginVC.swift
//  Smack
//
//  Created by Владислав on 1/16/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: TO_SIGNUP, sender: nil)
    }

}
