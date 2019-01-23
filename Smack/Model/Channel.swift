//
//  Channel.swift
//  Smack
//
//  Created by Владислав on 1/21/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

struct Channel {
    public private(set) var _id: String!
    public private(set) var name: String!
    public private(set) var description: String!
    public private(set) var __v: Int?
    
    init(_id: String, name: String, description: String) {
        self._id = _id
        self.name = name
        self.description = description
    }
}
