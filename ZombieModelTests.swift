
import XCTest
@testable import ZombieApocalypse

final class ZombieModelTests: XCTestCase {
    
    // Test case for checking if zombies increase in an outbreak scenario
    func testOutbreakScenario() {
        let model = ZombieModel(alpha: 0.1, beta: 0.2, delta: 0.1, pi: 0.01, rho: 0.0, kappa: 0.0, cureRate: 0.0, susceptible: 1000, infected: 10, zombies: 5, removed: 2, quarantined: 0, totalTime: 100, dt: 1)
        
        let result = nextStep(model: model, mode: "outbreak")
        
        XCTAssertGreaterThan(result.2, model.zombies, "Zombie population should increase in an outbreak scenario.")
    }
    
    // Additional test cases can be added for other scenarios (quarantine, cure, etc.)
}

// Running the test suite
ZombieModelTests.defaultTestSuite.run()
