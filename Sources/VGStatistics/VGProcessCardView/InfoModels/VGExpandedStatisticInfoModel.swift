//
//  File.swift
//  
//
//  Created by Александр Волков on 06.06.2023.
//

import Foundation

struct VGExpandedStatisticInfoModel {
    let title: String
    let timestampFormat: String
    let statistics: [VGProcessExpandedStatisticFilterItemInfoModel]
    
    func change(title: String? = nil, statistics: [VGProcessExpandedStatisticFilterItemInfoModel]? = nil, timestampFormat: String? = nil) -> VGExpandedStatisticInfoModel {
        let current = self
        
        return VGExpandedStatisticInfoModel(
            title: title ?? current.title,
            timestampFormat: timestampFormat ?? current.timestampFormat,
            statistics: statistics ?? current.statistics
        )
    }
}
