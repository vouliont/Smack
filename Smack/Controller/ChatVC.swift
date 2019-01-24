//
//  ChatVC.swift
//  Smack
//
//  Created by Владислав on 1/16/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var messagesView: UITableView!
    @IBOutlet weak var sendMsgBtn: UIButton!
    
    // Variables
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        messageTxtBox.rightView = paddingView
        messageTxtBox.rightViewMode = .always
        
        sendMsgBtn.isHidden = true
        selectAppTitle()
        
        messagesView.delegate = self
        messagesView.dataSource = self
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        SocketService.instance.messageDidAdd { (success) in
            if success {
                self.messagesView.reloadData()
                
                if MessageService.instance.messages.count > 0 {
                    let indexLastMessage = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.messagesView.scrollToRow(at: indexLastMessage, at: .bottom, animated: false)
                }
            }
        }
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            }
        }
    }
    
    @objc func userDataDidChange() {
        selectAppTitle()
    }
    
    func selectAppTitle() {
        if !AuthService.instance.isLoggedIn {
            channelNameLbl.text = "Please Log In"
            messagesView.reloadData()
        } else {
            channelNameLbl.text = "Smack"
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.name ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?._id else { return }
        
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            self.messagesView.reloadData()
            
            if MessageService.instance.messages.count > 0 {
                let indexLastMessage = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                self.messagesView.scrollToRow(at: indexLastMessage, at: .bottom, animated: false)
            }
        }
    }
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        if messageTxtBox.text == "" {
            isTyping = false
            sendMsgBtn.isHidden = true
        } else {
            if isTyping == false {
                sendMsgBtn.isHidden = false
            }
            isTyping = true
        }
    }
    
    @IBAction func sendMsgBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?._id else { return }
            guard let message = messageTxtBox.text, messageTxtBox.text != "" else { return }
            
            SocketService.instance.addMessage(messageBody: message, channelId: channelId) { (success) in
                self.messageTxtBox.text = ""
                self.messageTxtBox.resignFirstResponder()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.setupView(message: message)
            
            return cell
        }
        
        return MessageCell()
    }
    
}
