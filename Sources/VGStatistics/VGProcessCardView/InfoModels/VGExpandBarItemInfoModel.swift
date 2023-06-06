//
//  VGExpandBarItemInfoModel.swift
//  
//
//  Created by Александр Волков on 06.06.2023.
//

import Foundation

struct VGExpandBarItemInfoModel: Identifiable, Equatable, Hashable {
    let id: UUID
    let value: CGFloat
    let upperValue: Float
    let downText: String
    let enabled: Bool
    
    public static func == (lhs: VGExpandBarItemInfoModel, rhs: VGExpandBarItemInfoModel) -> Bool {
        return lhs.id == rhs.id
    }
}
