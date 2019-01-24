//
//  ChannelVC.swift
//  Smack
//
//  Created by Владислав on 1/16/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: BorderedImage!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addChannelBtn: UIButton!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        if AuthService.instance.isLoggedIn {
            setupUserInfo()
        }
        
        tableView.delegate = self
        tableView.dataSource = self

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        self.revealViewController()?.toggleAnimationDuration = 0.5
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        SocketService.instance.messageDidAdd { (newMessage) in
            guard AuthService.instance.isLoggedIn else { return }
            
            if newMessage.channelId != MessageService.instance.selectedChannel?._id {
                MessageService.instance.uncheckedChannels.append(newMessage.channelId)
                let index = self.tableView.indexPathForSelectedRow
                
                self.tableView.reloadData()
                
                if let index = index {
                    self.tableView.selectRow(at: index, animated: false, scrollPosition: .none)
                }
            }
        }
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if AuthService.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func addChannelBtnPressed(_ sender: UIButton) {
        let createChannelModal = ModalCreateChannelVC()
        createChannelModal.modalPresentationStyle = .custom
        present(createChannelModal, animated: true, completion: nil)
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
        if AuthService.instance.isLoggedIn {
            addChannelBtn.isEnabled = true
        } else {
            addChannelBtn.isEnabled = false
        }
    }
    
    func setupUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            MessageService.instance.findAllChannel { (success) in
                if success {
                    self.tableView.reloadData()
                }
            }
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            self.tableView.reloadData()
        }
    }
    
    func setupView() {
        if !AuthService.instance.isLoggedIn {
            addChannelBtn.isEnabled = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            cell.configureCell(channel: MessageService.instance.channels[indexPath.row])
            
            return cell
        }
        
        return ChannelCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if MessageService.instance.uncheckedChannels.contains(channel._id) {
            MessageService.instance.uncheckedChannels = MessageService.instance.uncheckedChannels.filter { (uncheckedChannel) -> Bool in
                return uncheckedChannel != channel._id
            }
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        self.revealViewController().revealToggle(animated: true)
    }
    
}
