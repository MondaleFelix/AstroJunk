//
//  PhysicsCategories.swift
//  AstroJunk
//
//  Created by Mondale on 6/23/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None:      UInt32 = 0          // 0000000
    static let Ship:      UInt32 = 0b1        // 0000001
    static let Meteor:    UInt32 = 0b10       // 0000010
    static let Junk:      UInt32 = 0b100      // 0000100
}
