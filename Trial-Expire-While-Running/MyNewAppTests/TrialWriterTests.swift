// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
import MyNewApp

class TrialWriterTests: XCTestCase {

    let userDefaultsDouble: TestUserDefaults = TestUserDefaults()
    
    override func setUp() {
        
        super.setUp()
        
        // No need to set the double on TrialWriter because
        // its property is lazily loaded during test cases later.
        UserDefaults.setSharedInstance(UserDefaults(userDefaults: userDefaultsDouble))
    }
    
    override func tearDown() {
        
        UserDefaults.resetSharedInstance()
        
        super.tearDown()
    }
    

    func testStoring_DelegatesToUserDefaults() {
        
        // Given
        let writer = TrialWriter()
        let startDate = NSDate(timeIntervalSince1970: 4567)
        let endDate = NSDate(timeIntervalSince1970: 121314)
        let trialPeriod = TrialPeriod(startDate: startDate, endDate: endDate)
        
        // When
        writer.storeTrial(trialPeriod)
        
        // Then
        let changedDefaults = userDefaultsDouble.didSetObjectsForKeys
        XCTAssert(hasValue(changedDefaults))
        
        if let changedDefaults = changedDefaults {
            
            XCTAssert(changedDefaults[TrialPeriod.UserDefaultsKeys.StartDate.rawValue] == startDate)
            XCTAssert(changedDefaults[TrialPeriod.UserDefaultsKeys.EndDate.rawValue] == endDate)
        }
    }

    
    // MARK: - 
    
    class TestUserDefaults: NullUserDefaults {
        
        var didSetObjectsForKeys: [String : NSDate]?
        override func setObject(value: AnyObject?, forKey key: String) {
            
            if !hasValue(didSetObjectsForKeys) {
                didSetObjectsForKeys = [String : NSDate]()
            }
            
            didSetObjectsForKeys![key] = value as? NSDate
        }
    }
}
