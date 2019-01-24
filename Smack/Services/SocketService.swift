//
//  SocketService.swift
//  Smack
//
//  Created by Владислав on 1/22/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    
    override init() {
        super.init()
        
        socket = manager.defaultSocket
    }
    
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!)
    var socket: SocketIOClient!
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(name: String, description: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", name, description)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescription = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(_id: channelId, name: channelName, description: channelDescription)
            
            MessageService.instance.channels.append(newChannel)
            
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        
        socket.emit("newMessage", messageBody, user.id, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func messageDidAdd(completion: @escaping CompletionHandler) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let channelId = dataArray[2] as? String else { return }
            if channelId != MessageService.instance.selectedChannel?._id || !AuthService.instance.isLoggedIn {
                return
            }
            
            guard let messageBody = dataArray[0] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
            
            MessageService.instance.messages.append(message)
            
            completion(true)
        }
    }
    
}
