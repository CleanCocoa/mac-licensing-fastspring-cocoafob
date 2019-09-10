// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import XCTest
@testable import MyNewApp

class TrialProviderTests: XCTestCase {

    var trialProvider: TrialProvider!
    
    var userDefaultsDouble: TestUserDefaults!
    
    override func setUp() {
        super.setUp()
        
        userDefaultsDouble = TestUserDefaults()
        trialProvider = TrialProvider()
        trialProvider.userDefaults = userDefaultsDouble
    }
    
    override func tearDown() {
        userDefaultsDouble = nil
        trialProvider = nil
        super.tearDown()
    }
    
    func provideTrialDefaults(_ startDate: Date, endDate: Date) {
        userDefaultsDouble.testValues = [
            TrialPeriod.DefaultsKey.startDate.rawValue : startDate,
            TrialPeriod.DefaultsKey.endDate.rawValue : endDate
        ]
    }
    
    
    // MARK: -
    // MARK: Empty Defaults, no trial
    
    func testCurrentPeriod_WithEmptyDefaults_QueriesDefaultsForStartData() {
        
        _ = trialProvider.trialPeriod

        XCTAssertNotNil(userDefaultsDouble.didCallObjectForKeyWith)
        if let usedDefaultNames = userDefaultsDouble.didCallObjectForKeyWith {
            XCTAssert(usedDefaultNames.contains(TrialPeriod.DefaultsKey.startDate.rawValue))
        }
    }
    
    func testCurrentPeriod_WithEmptyDefaults_ReturnsNil() {
        
        let trialInfo = trialProvider.trialPeriod
        
        XCTAssertNil(trialInfo)
    }
    
    
    // MARK: Existing Defaults, returns trial period
    
    func testCurrentPeriod_WithDefaultsValues_QueriesDefaultsForStartAndEndDate() {
        
        provideTrialDefaults(Date(), endDate: Date())
        
        _ = trialProvider.trialPeriod

        XCTAssertNotNil(userDefaultsDouble.didCallObjectForKeyWith)
        if let usedDefaultNames = userDefaultsDouble.didCallObjectForKeyWith {
            XCTAssert(usedDefaultNames.contains(TrialPeriod.DefaultsKey.startDate.rawValue))
        }
    }
    
    func testCurrentPeriod_WithDefaultsValues_ReturnsTrialPeriodWithInfo() {
        
        let startDate = Date(timeIntervalSince1970: 0)
        let endDate = Date(timeIntervalSince1970: 12345)
        provideTrialDefaults(startDate, endDate: endDate)
        
        let trialPeriod = trialProvider.trialPeriod
        
        XCTAssertNotNil(trialPeriod)
        if let trialPeriod = trialPeriod {
            XCTAssertEqual(trialPeriod.startDate, startDate)
            XCTAssertEqual(trialPeriod.endDate, endDate)
        }
    }
    
    
    // MARK: Trial wrapping
    
    let clockDouble = TestClock()
    
    func testCurrentTrial_WithoutDefaults_ReturnsNil() {
        
        XCTAssertNil(trialProvider.trial(clock: clockDouble))
    }
    
    func testCurrentTrial_WithTrialPeriod_ReturnsTrialWithClockAndPeriod() {
        
        let startDate = Date(timeIntervalSince1970: 456)
        let endDate = Date(timeIntervalSince1970: 999)
        provideTrialDefaults(startDate, endDate: endDate)
        
        let trial = trialProvider.trial(clock: clockDouble)
        
        XCTAssertNotNil(trial)
        if let trial = trial {
            XCTAssertEqual(trial.trialPeriod, trialProvider.trialPeriod!)
            XCTAssert(trial.clock === clockDouble)
        }
    }
    
    
    // MARK : -

    class TestUserDefaults: NullUserDefaults {
        
        var testValues = [AnyHashable : Any]()
        var didCallObjectForKeyWith: [String]?
        override func object(forKey defaultName: String) -> Any? {
            
            if didCallObjectForKeyWith == nil {
                didCallObjectForKeyWith = [String]()
            }
            
            didCallObjectForKeyWith?.append(defaultName)
            
            return testValues[defaultName]
        }
    }
    
    class TestClock: KnowsTimeAndDate {
        
        var testDate: Date!
        func now() -> Date {
            
            return testDate
        }
    }
}
