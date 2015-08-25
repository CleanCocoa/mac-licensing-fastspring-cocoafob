import Cocoa
import XCTest
import MyNewApp

class TrialProviderTests: XCTestCase {

    let trialProvider = TrialProvider()
    
    let userDefaultsDouble: TestUserDefaults = TestUserDefaults()
    
    override func setUp() {
        
        super.setUp()
        
        // No need to set the double on trialProvider because
        // its property is lazily loaded during test cases later.
        UserDefaults.setSharedInstance(UserDefaults(userDefaults: userDefaultsDouble))
    }
    
    override func tearDown() {
        
        UserDefaults.resetSharedInstance()
        
        super.tearDown()
    }
    
    func provideTrialDefaults(startDate: NSDate, endDate: NSDate) {
        userDefaultsDouble.testValues = [
            TrialPeriod.UserDefaultsKeys.StartDate.rawValue : startDate,
            TrialPeriod.UserDefaultsKeys.EndDate.rawValue : endDate
        ]
    }
    
    
    // MARK: -
    // MARK: Empty Defaults, no trial
    
    func testCurrentPeriod_WithEmptyDefaults_QueriesDefaultsForStartData() {
        
        _ = trialProvider.currentTrialPeriod
        
        let usedDefaultNames = userDefaultsDouble.didCallObjectForKeyWith
        XCTAssert(hasValue(usedDefaultNames))
        
        if let usedDefaultNames = usedDefaultNames {
            
            XCTAssert(contains(usedDefaultNames, TrialPeriod.UserDefaultsKeys.StartDate.rawValue))
        }
    }
    
    func testCurrentPeriod_WithEmptyDefaults_ReturnsNil() {
        
        let trialInfo = trialProvider.currentTrialPeriod
        
        XCTAssertFalse(hasValue(trialInfo))
    }
    
    
    // MARK: Existing Defaults, returns trial period
    
    func testCurrentPeriod_WithDefaultsValues_QueriesDefaultsForStartAndEndDate() {
        
        provideTrialDefaults(NSDate(), endDate: NSDate())
        
        _ = trialProvider.currentTrialPeriod
        
        let usedDefaultNames = userDefaultsDouble.didCallObjectForKeyWith
        XCTAssert(hasValue(usedDefaultNames))
        
        if let usedDefaultNames = usedDefaultNames {
            
            XCTAssert(contains(usedDefaultNames, TrialPeriod.UserDefaultsKeys.StartDate.rawValue))
        }
    }
    
    func testCurrentPeriod_WithDefaultsValues_ReturnsTrialPeriodWithInfo() {
        
        let startDate = NSDate(timeIntervalSince1970: 0)
        let endDate = NSDate(timeIntervalSince1970: 12345)
        provideTrialDefaults(startDate, endDate: endDate)
        
        let trialPeriod = trialProvider.currentTrialPeriod
        
        XCTAssert(hasValue(trialPeriod))
        if let trialPeriod = trialPeriod {
            XCTAssertEqual(trialPeriod.startDate, startDate)
            XCTAssertEqual(trialPeriod.endDate, endDate)
        }
    }
    
    
    // MARK: Trial wrapping
    
    let clockDouble = TestClock()
    
    func testCurrentTrial_WithoutDefaults_ReturnsNil() {
        
        XCTAssertFalse(hasValue(trialProvider.currentTrialWithClock(clockDouble)))
    }
    
    func testCurrentTrial_WithTrialPeriod_ReturnsTrialWithClockAndPeriod() {
        
        let startDate = NSDate(timeIntervalSince1970: 456)
        let endDate = NSDate(timeIntervalSince1970: 999)
        provideTrialDefaults(startDate, endDate: endDate)
        
        let trial = trialProvider.currentTrialWithClock(clockDouble)
        
        XCTAssert(hasValue(trial))
        if let trial = trial {
            XCTAssertEqual(trial.trialPeriod, trialProvider.currentTrialPeriod!)
            XCTAssert(trial.clock === clockDouble)
        }
    }
    
    
    // MARK : -

    class TestUserDefaults: NullUserDefaults {
        
        var testValues = [String : AnyObject]()
        var didCallObjectForKeyWith: [String]?
        override func objectForKey(defaultName: String) -> AnyObject? {
            
            if !hasValue(didCallObjectForKeyWith) {
                didCallObjectForKeyWith = [String]()
            }
            
            didCallObjectForKeyWith?.append(defaultName)
            
            return testValues[defaultName]
        }
    }
    
    class TestClock: KnowsTimeAndDate {
        
        var testDate: NSDate!
        func now() -> NSDate {
            
            return testDate
        }
    }
}
