//
//  MessageService.swift
//  Smack
//
//  Created by Владислав on 1/21/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel: Channel?
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if let err = response.result.error {
                completion(false)
                debugPrint(err as Any)
            } else {
                guard let data = response.data else { return }
                
                if let json = try! JSON(data: data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let description = item["description"].stringValue
                        let _id = item["_id"].stringValue

                        let channel = Channel(_id: _id, name: name, description: description)

                        self.channels.append(channel)
                    }
                    completion(true)
                }
            }
        }
    }
    
    func clearAllChannel() {
        channels.removeAll()
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        let url = "\(URL_GET_MESSAGES)\(channelId)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if let err = response.result.error {
                debugPrint(err as Any)
                completion(false)
            } else {
                self.clearAllMessage()
                guard let data = response.data else { return }
                
                if let json = try? JSON(data: data).array {
                    for item in json! {
                        let messageBody = item["messageBody"].stringValue
                        let userName = item["userName"].stringValue
                        let channelId = item["channelId"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let id = item["_id"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody,
                                              userName: userName,
                                              channelId: channelId,
                                              userAvatar: userAvatar,
                                              userAvatarColor: userAvatarColor,
                                              id: id,
                                              timeStamp: timeStamp)
                        
                        self.messages.append(message)
                    }
                    completion(true)
                }
            }
        }
    }
    
    func clearAllMessage() {
        messages.removeAll()
    }
}
