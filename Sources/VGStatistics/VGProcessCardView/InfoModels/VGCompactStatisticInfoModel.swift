//
//  VGCompactStatisticInfoModel.swift
//  
//
//  Created by Александр Волков on 06.06.2023.
//

import Foundation

struct VGCompactStatisticInfoModel {
    let title: String
    let currentPeriodGoal: VGPeriodGoal
    let previousPeriodGoal: VGPeriodGoal?
    
    func change(title: String? = nil, currentPeriodGoal: VGPeriodGoal? = nil) -> VGCompactStatisticInfoModel {
        let current = self
        
        return VGCompactStatisticInfoModel(
            title: title ?? current.title,
            currentPeriodGoal: currentPeriodGoal ?? current.currentPeriodGoal,
            previousPeriodGoal: current.previousPeriodGoal
        )
    }
    
    func change(previousPeriodGoal: VGPeriodGoal?) -> VGCompactStatisticInfoModel {
        let current = self
        
        return VGCompactStatisticInfoModel(
            title: current.title,
            currentPeriodGoal: current.currentPeriodGoal,
            previousPeriodGoal: previousPeriodGoal
        )
    }
}
