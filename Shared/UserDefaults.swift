import Foundation

private struct UserDefaultsStatic {
    static var singleton: UserDefaults? = nil
    static var onceToken: dispatch_once_t = 0
}

public class UserDefaults {
    public static var sharedInstance: UserDefaults {
        
        if UserDefaultsStatic.singleton == nil {
            dispatch_once(&UserDefaultsStatic.onceToken) {
                self.setSharedInstance(UserDefaults())
            }
        }
        
        return UserDefaultsStatic.singleton!
    }
    
    public static func resetSharedInstance() {
        UserDefaultsStatic.singleton = nil
        UserDefaultsStatic.onceToken = 0
    }
    
    public static func setSharedInstance(instance: UserDefaults) {
        UserDefaultsStatic.singleton = instance
    }
    
    let userDefaults: NSUserDefaults
    
    public convenience init() {
        self.init(userDefaults: NSUserDefaults.standardUserDefaults())
    }
    
    public init(userDefaults aUserDefaults: NSUserDefaults) {
        userDefaults = aUserDefaults
    }
    
    public static func standardUserDefaults() -> NSUserDefaults {
        return sharedInstance.userDefaults
    }
}
