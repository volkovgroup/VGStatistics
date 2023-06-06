//
//  VGProcessCompactCardInfoModel.swift
//  
//
//  Created by Александр Волков on 06.06.2023.
//

import Foundation

struct VGProcessCompactCardInfoModel {
    let title: String
    let currentProgress: VGPeriodGoal
    let measure: String
    let currentProgressProcent: Float
    let floatingPoint: Int
    let magnitudeChanges: VGMagnitudeChanges
}
