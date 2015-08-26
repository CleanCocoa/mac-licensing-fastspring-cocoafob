// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
import MyNewApp

class TrialPeriodTests: XCTestCase {

    let clockDouble = TestClock()

    let irrelevantDate = NSDate(timeIntervalSinceNow: 987654321)
    
    func testCreation_WithClock_AddsDaysToCurrentTime() {
        
        let date = NSDate(timeIntervalSinceReferenceDate: 9999)
        clockDouble.testDate = date
        // 10 days
        let expectedDate = date.dateByAddingTimeInterval(10 * 24 * 60 * 60)
        
        let trialPeriod = TrialPeriod(numberOfDays: Days(10), clock: clockDouble)
        
        XCTAssertEqual(trialPeriod.startDate, date)
        XCTAssertEqual(trialPeriod.endDate, expectedDate)
    }
    
    
    // MARK: Days left
    
    func testDaysLeft_12Hours_ReturnsHalfDay() {
        
        let currentDate = NSDate()
        clockDouble.testDate = currentDate
        let endDate = currentDate.dateByAddingTimeInterval(12*60*60)
        let trialPeriod = TrialPeriod(startDate: irrelevantDate, endDate: endDate)
        
        let daysLeft = trialPeriod.daysLeft(clockDouble)
        
        XCTAssertEqual(daysLeft, Days(0.5))
    }
    
    
    // MARK: Ended?
    
    func testTrialEnded_WithEarlierClock_ReturnsFalse() {
        
        let endDate = NSDate(timeIntervalSinceNow: 4567)
        let trialPeriod = TrialPeriod(startDate: irrelevantDate, endDate: endDate)
        
        clockDouble.testDate = NSDate(timeIntervalSinceNow: 1)
        
        XCTAssertFalse(trialPeriod.ended(clockDouble))
    }

    func testTrialEnded_WithLaterClock_ReturnsTrue() {
        
        let endDate = NSDate(timeIntervalSinceNow: 4567)
        let trialPeriod = TrialPeriod(startDate: irrelevantDate, endDate: endDate)
        
        clockDouble.testDate = NSDate(timeIntervalSinceNow: 9999)
        
        XCTAssert(trialPeriod.ended(clockDouble))
    }
    
    
    // MARK: -
    
    class TestClock: KnowsTimeAndDate {
        
        var testDate: NSDate!
        func now() -> NSDate {
            
            return testDate
        }
    }
}
