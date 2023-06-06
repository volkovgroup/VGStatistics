//
//  File.swift
//  
//
//  Created by Александр Волков on 06.06.2023.
//

import Foundation

protocol VGProcessCardViewModelProtocol {}

final class VGProcessExpandCardState: ObservableObject {    
    weak var viewModelInput: VGProcessCardViewModelInput?
    
    @Published var title: String = ""
    @Published var selectedFilter: VGProcessExpandedCardFiltersInfoModel = .init(id: UUID(), title: "no data")
    @Published var filters: [VGProcessExpandedCardFiltersInfoModel] = []
    @Published var bars: [VGExpandBarItemInfoModel] = Array(repeating: .init(id: UUID(), value: 0.0, upperValue: 0, downText: "", enabled: false), count: 7)
    
    func update(infoModel: VGProcessExpandedCardInfoModel) {
        title = infoModel.title
        filters = infoModel.filters
        selectedFilter = infoModel.selectedFilter
        bars = infoModel.statistics
    }
}

final class VGProcessCompactCardState: ObservableObject {
    @Published var title: String = ""
    @Published var currentProgress: VGPeriodGoal = .init(min: 0, max: 0, floatingPoint: 0)
    @Published var measure: String = ""
    @Published var currentProgressProcent: Float = 0
    @Published var magnitudeChanges: String = ""
    
    func update(infoModel: VGProcessCompactCardInfoModel) {
        title = infoModel.title
        currentProgress = infoModel.currentProgress
        measure = infoModel.measure
        magnitudeChanges = infoModel.magnitudeChanges.title
        currentProgressProcent = infoModel.currentProgressProcent
    }
}

protocol VGProcessCardViewModelInput: AnyObject {
    func filterTapped(_ id: UUID)
}

final class VGProcessCardViewModel {
    let compactState = VGProcessCompactCardState()
    let expandedState = VGProcessExpandCardState()
    
    private var measure: UnitLength {
        didSet {
            configureCompactState()
            configureExpandedState()
        }
    }
    
    var compactStatisticInfoModel: VGCompactStatisticInfoModel {
        didSet {
            configureCompactState()
        }
    }
    var expandedStatisticInfoModel: VGExpandedStatisticInfoModel {
        didSet {
            configureExpandedState()
        }
    }
    
    var selectedFilter: VGProcessExpandedStatisticFilterItemInfoModel {
        didSet {
            configureExpandedState()
        }
    }
    
    init(configurator: VGProcessCardViewModelConfigurator) {
        measure = configurator.measure
        compactStatisticInfoModel = configurator.compactStatisticInfoModel
        expandedStatisticInfoModel = configurator.expandedStatisticInfoModel
        selectedFilter = configurator.expandedStatisticInfoModel.statistics.first!
        configureCompactState()
        configureExpandedState()
        
        expandedState.viewModelInput = self
    }
}

extension VGProcessCardViewModel: VGProcessCardViewModelInput {
    func filterTapped(_ id: UUID) {
        guard !expandedStatisticInfoModel.statistics.isEmpty,
        let itemIndex = expandedStatisticInfoModel.statistics.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        guard itemIndex + 1 < expandedStatisticInfoModel.statistics.count else {
            selectedFilter = expandedStatisticInfoModel.statistics[0]
            return
        }
        
        selectedFilter = expandedStatisticInfoModel.statistics[itemIndex + 1]
    }
}

extension VGProcessCardViewModel {
    private func configureCompactState() {
        let infoModel = VGProcessCompactCardInfoModel(
            title: compactStatisticInfoModel.title,
            currentProgress: compactStatisticInfoModel.currentPeriodGoal,
            measure: measure.symbol,
            currentProgressProcent: calculateProcent(min: compactStatisticInfoModel.currentPeriodGoal.min, max: compactStatisticInfoModel.currentPeriodGoal.max),
            floatingPoint: 1,
            magnitudeChanges: VGMagnitudeChanges(past: compactStatisticInfoModel.previousPeriodGoal, current: compactStatisticInfoModel.currentPeriodGoal)
        )
        
        compactState.update(infoModel: infoModel)
    }
    private func configureExpandedState() {
        let infoModel = VGProcessExpandedCardInfoModel(
            title: expandedStatisticInfoModel.title,
            filters: expandedStatisticInfoModel.statistics.map { .init(id: $0.id, title: $0.filter) },
            selectedFilter: .init(id: selectedFilter.id, title: selectedFilter.filter),
            statistics: convertStatisticToBars()
        )
        
        expandedState.update(infoModel: infoModel)
    }
    
    private func calculateProcent(min: Float, max: Float) -> Float {
        if max == 0 { return 0 }
        return (min / max) * 100
    }
    
    private func convertStatisticToBars() -> [VGExpandBarItemInfoModel] {
        guard let maxStat = selectedFilter.items.map({ $0.value }).max() else {
            return Array(repeating: .init(id: UUID(), value: 0.0, upperValue: 0, downText: "", enabled: false), count: 7)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = expandedStatisticInfoModel.timestampFormat
        
        return selectedFilter.items.enumerated().map { index, item in
            return VGExpandBarItemInfoModel(
                id: item.id,
                value: CGFloat(max(20, item.value / maxStat * 113)),
                upperValue: item.value,
                downText: formatter.string(from: item.timeStamp),
                enabled: item.value != 0
            )
        }
    }
}
