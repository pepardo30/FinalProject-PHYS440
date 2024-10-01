
import SwiftUI
import Charts

// A simple data structure to represent time vs population values
struct PopulationData: Identifiable {
    let id = UUID()
    let time: Double
    let population: Double
}

// View to display a line chart of the population data
struct GraphView: View {
    var data: [PopulationData]  // Time vs Population data

    var body: some View {
        LineChartView(entries: data.map { ChartDataEntry(x: $0.time, y: $0.population) })
            .frame(height: 300)
            .padding()
            .navigationBarTitle("Population Over Time", displayMode: .inline)
    }
}

// Example of how the GraphView could be used
struct ContentView: View {
    var body: some View {
        let sampleData = (0..<50).map { PopulationData(time: Double($0), population: Double($0 * 2)) }
        GraphView(data: sampleData)
    }
}

@main
struct PopulationGraphApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
