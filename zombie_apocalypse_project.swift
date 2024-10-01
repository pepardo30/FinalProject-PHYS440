
import Foundation

// Define the parameters for each model
struct ZombieModel {
    var alpha: Double  // Zombie destruction rate
    var beta: Double   // Zombie infection rate
    var delta: Double  // Resurrection rate
    var pi: Double     // Natural death rate
    var rho: Double    // Infection latency rate (for latent model)
    var kappa: Double  // Quarantine rate (for quarantine model)
    var cureRate: Double  // Cure rate (for treatment model)
    
    // Initial values
    var susceptible: Double
    var infected: Double
    var zombies: Double
    var removed: Double
    var quarantined: Double  // Quarantined individuals (for quarantine model)
    
    // Time parameters
    var totalTime: Double
    var dt: Double
}

// Function to calculate the next time step using Euler's method
func nextStep(model: ZombieModel, mode: String) -> (Double, Double, Double, Double, Double) {
    let S = model.susceptible
    let I = model.infected
    let Z = model.zombies
    let R = model.removed
    let Q = model.quarantined
    
    var dS: Double = 0
    var dI: Double = 0
    var dZ: Double = 0
    var dR: Double = 0
    var dQ: Double = 0
    
    switch mode {
    case "basic":
        // Basic model equations
        dS = -model.beta * S * Z - model.pi * S
        dZ = model.beta * S * Z + model.delta * R - model.alpha * S * Z
        dR = model.pi * S + model.alpha * S * Z - model.delta * R
        // No changes to infected or quarantined
    case "latent":
        // Latent infection model equations
        dS = -model.beta * S * Z - model.pi * S
        dI = model.beta * S * Z - model.rho * I
        dZ = model.rho * I + model.delta * R - model.alpha * S * Z
        dR = model.pi * S + model.alpha * S * Z - model.delta * R
    case "quarantine":
        // Quarantine model equations
        dS = -model.beta * S * Z - model.pi * S
        dI = model.beta * S * Z - model.rho * I - model.kappa * I
        dZ = model.rho * I + model.delta * R - model.alpha * S * Z - model.kappa * Z
        dR = model.pi * S + model.alpha * S * Z - model.delta * R
        dQ = model.kappa * I + model.kappa * Z - model.delta * Q
    case "treatment":
        // Treatment model equations
        dS = -model.beta * S * Z - model.pi * S + model.cureRate * Z
        dI = model.beta * S * Z - model.rho * I
        dZ = model.rho * I + model.delta * R - model.alpha * S * Z - model.cureRate * Z
        dR = model.pi * S + model.alpha * S * Z - model.delta * R
    default:
        print("Invalid mode selected!")
    }
    
    // Update the values using Euler's method
    let newS = S + dS * model.dt
    let newI = I + dI * model.dt
    let newZ = Z + dZ * model.dt
    let newR = R + dR * model.dt
    let newQ = Q + dQ * model.dt
    
    return (newS, newI, newZ, newR, newQ)
}

// Function to simulate the zombie apocalypse based on the selected model
func simulateZombieApocalypse(model: ZombieModel, mode: String) {
    var currentModel = model
    
    // Loop over time
    for time in stride(from: 0.0, to: model.totalTime, by: model.dt) {
        // Calculate the next step
        let (newS, newI, newZ, newR, newQ) = nextStep(model: currentModel, mode: mode)
        
        // Update the model values
        currentModel.susceptible = newS
        currentModel.infected = newI
        currentModel.zombies = newZ
        currentModel.removed = newR
        currentModel.quarantined = newQ
        
        // Print the current state
        print("Time: \(time), Susceptible: \(newS), Infected: \(newI), Zombies: \(newZ), Removed: \(newR), Quarantined: \(newQ)")
        
        // Stop if all susceptible humans are gone
        if newS <= 0 {
            print("Doomsday reached! Zombies have taken over.")
            break
        }
    }
}

// Define parameters for different models

// Basic model
let basicModel = ZombieModel(
    alpha: 0.005,   // Zombie destruction rate
    beta: 0.0095,   // Zombie infection rate
    delta: 0.0001,  // Resurrection rate
    pi: 0.0001,     // Natural death rate
    rho: 0.0,       // Latent infection rate (not used in basic model)
    kappa: 0.0,     // Quarantine rate (not used in basic model)
    cureRate: 0.0,  // Cure rate (not used in basic model)
    susceptible: 500.0,  // Initial susceptible humans
    infected: 0.0,      // Initially no infected
    zombies: 10.0,      // Initial zombies
    removed: 0.0,       // Initially no removed individuals
    quarantined: 0.0,   // Initially no quarantined individuals
    totalTime: 20.0,    // Total simulation time
    dt: 0.01            // Time step for Euler method
)

// Latent infection model
let latentModel = ZombieModel(
    alpha: 0.005,
    beta: 0.0095,
    delta: 0.0001,
    pi: 0.0001,
    rho: 0.005,  // Latent infection rate
    kappa: 0.0,
    cureRate: 0.0,
    susceptible: 500.0,
    infected: 0.0,
    zombies: 10.0,
    removed: 0.0,
    quarantined: 0.0,
    totalTime: 40.0,  // Longer time for latent infection model
    dt: 0.01
)

// Quarantine model
let quarantineModel = ZombieModel(
    alpha: 0.005,
    beta: 0.0095,
    delta: 0.0001,
    pi: 0.0001,
    rho: 0.005,
    kappa: 0.002,  // Quarantine rate
    cureRate: 0.0,
    susceptible: 500.0,
    infected: 0.0,
    zombies: 10.0,
    removed: 0.0,
    quarantined: 0.0,
    totalTime: 40.0,
    dt: 0.01
)

// Treatment model
let treatmentModel = ZombieModel(
    alpha: 0.005,
    beta: 0.0095,
    delta: 0.0001,
    pi: 0.0001,
    rho: 0.005,
    kappa: 0.0,
    cureRate: 0.001,  // Cure rate
    susceptible: 500.0,
    infected: 0.0,
    zombies: 10.0,
    removed: 0.0,
    quarantined: 0.0,
    totalTime: 40.0,
    dt: 0.01
)

// Uncomment the model you want to run

//simulateZombieApocalypse(model: basicModel, mode: "basic")
//simulateZombieApocalypse(model: latentModel, mode: "latent")
//simulateZombieApocalypse(model: quarantineModel, mode: "quarantine")
//simulateZombieApocalypse(model: treatmentModel, mode: "treatment")
