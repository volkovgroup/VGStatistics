//
//  VGProcessCardView.swift
//  
//
//  Created by Александр Волков on 04.06.2023.
//

import SwiftUI

import Combine

struct VGPeriodGoal {
    let min: Float
    let max: Float
    let floatingPoint: Int
    
    var procent: Float {
        if max == 0 { return 0 }
        
        return (min / max) * 100
    }
}

struct HorizontalBarView: View {
    let complete: Bool
    
    var body: some View {
        Rectangle()
            .fill(Color(UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: complete ? 1.0 : 0.2)))
            .frame(height: 7)
            .cornerRadius(3.14)
    }
}

struct VerticalBarView: View {
    let infoModel: VGExpandBarItemInfoModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("\(infoModel.upperValue, specifier: "%.1f")")
                .font(Fonts.pastTitle.withSize(10).suFont)
            Rectangle()
                .fill(Color(UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: infoModel.enabled ? 1.0 : 0.2)))
                .frame(height: infoModel.value)
                .cornerRadius(16)
            Text(infoModel.downText)
                .font(Fonts.pastTitle.withSize(10).suFont)
        }
    }
}

struct VGProcessCardView: View {
    @ObservedObject var compactState: VGProcessCompactCardState
    @ObservedObject var expandedState: VGProcessExpandCardState
    
    @State var expanded: Bool = true
    
    let fonts = VGStatisticsFonts()
    
    var title: some View {
        Text(compactState.title)
            .font(Fonts.cardTitle.suFont)
            .foregroundColor(Semantic.title.suColor)
    }
    
    var pastTitleGroup: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(compactState.magnitudeChanges)
                .font(Fonts.pastTitle.suFont)
                .foregroundColor(Semantic.title.suColor)
            Text("that last week ")
                .font(Fonts.pastTitle.suFont)
                .foregroundColor(Semantic.subtitle.suColor)
        }
    }
    
    var upperStatistic: some View {
        VStack(alignment: .center, spacing: 18) {
            HStack(alignment: .top) {
                title
                Spacer()
                pastTitleGroup
            }
            VStack(alignment: .center, spacing: 7.52) {
                HStack(alignment: .center) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("\(compactState.currentProgress.min, specifier: "%.\(compactState.currentProgress.floatingPoint)f")")
                            .font(Fonts.cardTitle.suFont)
                            .foregroundColor(Semantic.title.suColor)
                            .animation(.default)
                        Text("/")
                            .font(Fonts.cardTitle.suFont)
                            .foregroundColor(Semantic.title.suColor)
                        Text("\(compactState.currentProgress.max, specifier: "%.\(compactState.currentProgress.floatingPoint)f") \(compactState.measure)")
                            .font(Fonts.cardTitle.suFont)
                            .foregroundColor(Semantic.subtitle.suColor)
                            .animation(.default)
                    }
                    
                    Spacer()
                    Text("\(compactState.currentProgressProcent, specifier: "%.0f")%")
                        .font(Fonts.percentTitle.suFont)
                        .foregroundColor(Semantic.title.suColor)
                        .animation(.default)
                }
                HStack(alignment: .center, spacing: 6.21) {
                    ForEach(1..<7) { index in
                        HorizontalBarView(complete: index * (Int(100 / 6)) < Int(compactState.currentProgressProcent))
                            .animation(.default, value: compactState.currentProgressProcent)
                    }
                }
            }
        }
    }
    
    var downStatistic: some View {
        VStack(alignment: .center, spacing: 18) {
            Divider()
            HStack(alignment: .top) {
                Text(expandedState.title)
                    .font(Fonts.cardTitle.suFont)
                    .foregroundColor(Semantic.title.suColor)
                Spacer()
                Button(expandedState.selectedFilter.title) { [weak expandedState] in
                    guard let expandedState else {
                        return
                    }
                    
                    expandedState.viewModelInput?.filterTapped(expandedState.selectedFilter.id)
                }
                    .font(Fonts.pastTitle.suFont)
                    .foregroundColor(Semantic.subtitle.suColor)
            }
            HStack(alignment: .bottom, spacing: 9.5) {
                ForEach(Array(expandedState.bars.enumerated()), id: \.offset) { _, model in
                    VerticalBarView(infoModel: model)
                }
                .animation(Animation.easeInOut(duration: 0.2), value: expandedState.bars)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            upperStatistic
            if expanded {
                downStatistic
            }
        }
        .padding([.leading, .trailing], 25)
        .padding([.top, .bottom], 25)
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              alignment: .topLeading
        )
        .background {
            Rectangle()
                .fill(Color(UIColor(red: 0.91, green: 1.00, blue: 0.33, alpha: 1.00)))
                .cornerRadius(29)
        }
        .onTapGesture {
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                expanded.toggle()
            }
        }
    }
}

struct VGProcessCardView_Previews: PreviewProvider {
    static let viewModel = VGProcessCardViewModel(
        configurator: VGProcessCardViewModelConfigurator(
            measure: .kilometers,
            compactStatisticInfoModel: VGCompactStatisticInfoModel(
                title: "Walk distance goal",
                currentPeriodGoal: VGPeriodGoal(min: 20, max: 310, floatingPoint: 0),
                previousPeriodGoal: VGPeriodGoal(min: 200, max: 300, floatingPoint: 0)
            ),
            expandedStatisticInfoModel: VGExpandedStatisticInfoModel(
                title: "Your distance",
                timestampFormat: "HH:mm",
                statistics: [
                    VGProcessExpandedStatisticFilterItemInfoModel(
                        id: UUID(),
                        filter: "Today",
                        items: [0.7, 0, 0, 2, 0, 20, 2].map {
                            VGProcessExpandedStatisticItemInfoModel(id: UUID(), value: $0, timeStamp: Date.now)
                        }
                    ),
                    VGProcessExpandedStatisticFilterItemInfoModel(
                        id: UUID(),
                        filter: "Last week",
                        items: [10, 4, 1, 0, 7, 0, 2].map {
                            VGProcessExpandedStatisticItemInfoModel(id: UUID(), value: $0, timeStamp: Date.now)
                        }
                    )
                ]
            )
        )
    )
    
    static var previews: some View {
        ScrollView(.vertical) {
            VStack {
                VGProcessCardView(
                    compactState: Self.viewModel.compactState,
                    expandedState: Self.viewModel.expandedState
                )
                Button("Tap me") {
                    viewModel.compactStatisticInfoModel = viewModel.compactStatisticInfoModel.change(currentPeriodGoal: VGPeriodGoal(min: Float.random(in: 20...300), max: 310, floatingPoint: 0))
                }
            }
        }
        .padding(12)
    }
}
