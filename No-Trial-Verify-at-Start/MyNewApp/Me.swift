// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation
import AddressBook

/// Wrapper around `ABPerson` to expose properties used by the FastSpring store
/// in a useful manner with proper types.
class Me {

    let person: ABPerson?

    convenience init() {

        // Force-cast to optional to not crash when rights are missing.
        self.init(person: ABAddressBook.sharedAddressBook()?.me())
    }

    /// - parameter persion: Pass `nil` for unknown data.
    init(person: ABPerson?) {

        self.person = person
    }

    static let Unknown = ""

    var firstName: String {

        guard let person = person else {
            return Me.Unknown
        }

        guard let firstName = person.valueForProperty(kABFirstNameProperty) as? String else {

            return Me.Unknown
        }

        return firstName
    }

    var lastName: String {

        guard let person = person else {
            return Me.Unknown
        }

        guard let lastName = person.valueForProperty(kABLastNameProperty) as? String else {

            return Me.Unknown
        }

        return lastName
    }

    var organization: String {

        guard let person = person else {
            return Me.Unknown
        }

        guard let lastName = person.valueForProperty(kABLastNameProperty) as? String else {

            return Me.Unknown
        }

        return lastName
    }

    var primaryEmail: String {

        guard let person = person else {
            return Me.Unknown
        }

        guard let allEmails = person.valueForProperty(kABEmailProperty) as? ABMultiValue,
            primaryEmail = allEmails.valueAtIndex(allEmails.indexForIdentifier(allEmails.primaryIdentifier())) as? String else {

                return Me.Unknown
        }

        return primaryEmail
    }

    var primaryPhone: String {

        guard let person = person else {
            return Me.Unknown
        }

        guard let allPhones = person.valueForProperty(kABPhoneProperty) as? ABMultiValue,
            primaryPhone = allPhones.valueAtIndex(allPhones.indexForIdentifier(allPhones.primaryIdentifier())) as? String else {
                
                return Me.Unknown
        }
        
        return primaryPhone
    }
}
