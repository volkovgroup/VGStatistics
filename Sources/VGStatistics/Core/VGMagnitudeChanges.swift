//
//  VGMagnitudeChanges.swift
//  
//
//  Created by Александр Волков on 06.06.2023.
//

import Foundation

enum VGMagnitudeChanges {
    case lower(Int)
    case higher(Int)
    case zero
    case nodata
    
    var title: String {
        switch self {
        case let .higher(value):
            return "\(value)% higher"
            
        case let .lower(value):
            return "\(value)% lower"
            
        case .zero:
            return "no change"
            
        case .nodata:
            return "no data available"
        }
    }
    
    init(past: VGPeriodGoal?, current: VGPeriodGoal) {
        guard let past else {
            self = .nodata
            return
        }
        
        let difference = abs(100 - current.min / past.min * 100)
        
        if current.min > past.min {
            self = .higher(Int(difference))
        } else if current.min < past.min {
            self = .lower(Int(difference))
        } else if Int(current.min - past.min) == 0 {
            self = .zero
        } else {
            self = .nodata
        }
    }
}
