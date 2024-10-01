
import SwiftUI

// Main application entry point
@main
struct ZombieApocalypseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Content view to display the graph of population over time after running the simulation
struct ContentView: View {
    @State private var populationData: [PopulationData] = []
    
    var body: some View {
        VStack {
            if !populationData.isEmpty {
                GraphView(data: populationData)
            } else {
                Text("Running Zombie Simulation...")
                    .onAppear {
                        runSimulationAndShowResults()
                    }
            }
        }
        .padding()
    }
    
    // Function to run the simulation and store results in populationData
    func runSimulationAndShowResults() {
        let model = ZombieModel(alpha: 0.1, beta: 0.2, delta: 0.1, pi: 0.01, rho: 0.0, kappa: 0.0, cureRate: 0.0, susceptible: 1000, infected: 10, zombies: 5, removed: 2, quarantined: 0, totalTime: 100, dt: 1)
        
        // Run the simulation
        var timeStepResults: [(Double, Double, Double, Double)] = []
        for time in stride(from: 0.0, to: model.totalTime, by: model.dt) {
            let result = nextStep(model: model, mode: "outbreak")
            timeStepResults.append(result)
        }
        
        // Convert simulation results to population data for graphing
        populationData = timeStepResults.map { PopulationData(time: $0.0, population: $0.2) }
    }
}
