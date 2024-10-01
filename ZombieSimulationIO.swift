
import Foundation

// A function to run the simulation and save results to a file
func runSimulationAndSaveToFile(model: ZombieModel, mode: String) {
    var timeStepResults: [(Double, Double, Double, Double)] = []

    for time in stride(from: 0.0, to: model.totalTime, by: model.dt) {
        let result = nextStep(model: model, mode: mode)
        timeStepResults.append(result)
    }

    // Formatting the results into a readable output
    let output = timeStepResults.map { "Time: \(String(format: "%.2f", $0.0)) | S: \(String(format: "%.2f", $0.1)) | I: \($0.2) | Z: \($0.3) | R: \($0.4)" }
                                .joined(separator: "
")
    
    do {
        // Save the result to a file in the current directory
        try output.write(to: URL(fileURLWithPath: "simulation_results.txt"), atomically: true, encoding: .utf8)
        print("Simulation results saved to simulation_results.txt")
    } catch {
        print("Failed to save results to file: \(error.localizedDescription)")
    }
}

// Example usage
let exampleModel = ZombieModel(alpha: 0.1, beta: 0.3, delta: 0.1, pi: 0.02, rho: 0.0, kappa: 0.0, cureRate: 0.1, susceptible: 1000, infected: 20, zombies: 10, removed: 5, quarantined: 0, totalTime: 100, dt: 1)
runSimulationAndSaveToFile(model: exampleModel, mode: "outbreak")
