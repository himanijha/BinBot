//
//  PieChartView.swift
//  BinBot
//
//  Created by Lian Elsa Linton on 11/18/24.
//

/*import SwiftUI
import Charts
import DGCharts

struct PieChartView: View {
    var probabilities: [String: Double]
    
    var body: some View {
        PieChart(entries: probabilities)
            .frame(height: 300)
    }
}

// Helper: PieChart to work with Charts library
struct PieChart: View {
    var entries: [String: Double]

    var body: some View {
        // Prepare chart data
        let dataEntries = entries.map { entry in
            PieChartDataEntry(value: entry.value, label: entry.key)
        }

        // Create PieChartDataSet
        let dataSet = PieChartDataSet(entries: dataEntries, label: "Categories")
        dataSet.colors = entries.keys.map { key in
            getColor(for: key)
        }

        // Create PieChartData
        let data = PieChartData(dataSet: dataSet)

        // Return PieChartView
        return PieChartView(probabilities: data)
            .padding()
    }

    func getColor(for label: String) -> UIColor {
        switch label {
        case "Recycling":
            return .blue
        case "Compost":
            return .green
        case "Trash":
            return .gray
        default:
            return .purple
        }
    }
}
*/
