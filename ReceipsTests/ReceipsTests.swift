//
//  ReceipsTests.swift
//  ReceipsTests
//
//  Created by Ignacio Jacob on 18/07/17.
//  Copyright © 2017 Ignacio Jacob. All rights reserved.
//

import XCTest
@testable import Receips

class ReceipsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGoals() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let controller = GoalsController()
        
        let duedate = Date.init(timeIntervalSinceNow: 60*60*24*365)
        
        let list = controller.getGoalsList()

        controller.addGoal(balance: 1500, dueDate: duedate, name: "Ejemplo", notify: true, period: 16, targetAmmount: 1000000)
        
        let list2 = controller.getGoalsList()
        
        
        XCTAssert(list2.count > list.count)
        
    }
    
    func testGoalCalculator(){
        
        let controller = GoalsController()

        let duedate = Date.init(timeIntervalSinceNow: 60*60*24*365)
        
        let numPays = controller.getPeriodsForGoal(ammound: 100000, duedate: duedate, paymentsPerMont: 1)

        XCTAssert(numPays > 0)

        
    }
    
}
