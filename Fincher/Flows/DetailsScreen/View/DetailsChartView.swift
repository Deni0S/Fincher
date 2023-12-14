import Charts
import SwiftUI

struct ChartData: Identifiable {
    let id = UUID()
    let number: Int
    let count: Int
}

struct DetailsChartView: View {
    private let charts: [ChartData]

    var body: some View {
        GroupBox("График изменения переплаты") {
            Chart(charts) {
                LineMark(
                    x: .value("Месяц", $0.number),
                    y: .value("Проценты", $0.count)
                )
            }
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.orange.opacity(0.1))
                    .border(.orange, width: 2)
                    .frame(height: 180)
            }
        }
    }

    init(
        charts: [ChartData]
    ) {
        self.charts = charts
    }
}
