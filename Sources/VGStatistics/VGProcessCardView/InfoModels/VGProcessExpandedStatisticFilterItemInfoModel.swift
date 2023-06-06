//
//  VGProcessExpandedStatisticFilterItemInfoModel.swift
//  
//
//  Created by Александр Волков on 06.06.2023.
//

import Foundation

struct VGProcessExpandedStatisticFilterItemInfoModel {
    let id: UUID
    let filter: String
    let items: [VGProcessExpandedStatisticItemInfoModel]
}
