//
//  PINModel.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 11/11/25.
//

import Foundation

struct PINModel: Codable {
    let salt: Data
    let iterations: UInt32
    let hash: Data
    var failCount: UInt32
}
