//
//  File.swift
//  
//
//  Created by Александр Волков on 06.06.2023.
//

import Foundation

struct VGProcessExpandedCardInfoModel {
    let title: String
    let filters: [VGProcessExpandedCardFiltersInfoModel]
    let selectedFilter: VGProcessExpandedCardFiltersInfoModel
    let statistics: [VGExpandBarItemInfoModel]
}
