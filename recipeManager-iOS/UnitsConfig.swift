//
//  UnitsConfig.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/7/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//
//  This file provides extensions to the MKUnits framework (imported from MKUnits Cocoapod)

import Foundation
import MKUnits

/////////////////////////////////////////////
//  ADD COUNTING UNIT GROUP AND COUNT UNIT //
/////////////////////////////////////////////

//  MKUnits doesn't support unitless counting by default.  We need to add this functionality.

public final class CountingUnit: MKUnits.Unit {
    
    public static var count: CountingUnit {
        return CountingUnit(
            name: "count",
            symbol: "ct",
            ratio: NSDecimalNumber.one // as it is a base unit
        )
    }
    
}

extension NSNumber {
    
    public func count() -> Quantity {
        return Quantity(amount: self, unit: CountingUnit.count)
    }
    
}

/////////////////////////////////////////////
//  ADD ADDITIONAL VOLUME UNITS            //
/////////////////////////////////////////////

extension VolumeUnit {
    
    /* Change the name from english spelling to US spelling to be consistent with API */
    public static var hectolitre: VolumeUnit {
        return VolumeUnit(
            name: "hectoliter",
            symbol: "hl",
            ratio: NSDecimalNumber(mantissa: 1, exponent: 2, isNegative: false)
        )
    }
    
    /* Change the name from english spelling to US spelling to be consistent with API */
    public static var litre: VolumeUnit {
        return VolumeUnit(
            name: "liter",
            symbol: "l",
            ratio: NSDecimalNumber.one
        )
    }
    
    /* Change the name from english spelling to US spelling to be consistent with API */
    public static var decilitre: VolumeUnit {
        return VolumeUnit(
            name: "deciliter",
            symbol: "dl",
            ratio: NSDecimalNumber(mantissa: 1, exponent: -1, isNegative: false)
        )
    }
    
    /* Change the name from english spelling to US spelling to be consistent with API */
    public static var centilitre: VolumeUnit {
        return VolumeUnit(
            name: "centiliter",
            symbol: "cl",
            ratio: NSDecimalNumber(mantissa: 1, exponent: -2, isNegative: false)
        )
    }
    
    /* Change the name from english spelling to US spelling to be consistent with API */
    public static var millilitre: VolumeUnit {
        return VolumeUnit(
            name: "milliliter",
            symbol: "ml",
            ratio: NSDecimalNumber(mantissa: 1, exponent: -3, isNegative: false)
        )
    }
    
    /* Change the name from english spelling to US spelling to be consistent with API */
    public static var microlitre: VolumeUnit {
        return VolumeUnit(
            name: "microliter",
            symbol: "µl",
            ratio: NSDecimalNumber(mantissa: 1, exponent: -6, isNegative: false)
        )
    }
    
    /* Define the volume unit pinch as being 1/8 teaspoon */
    public static var pinch: VolumeUnit {
        return VolumeUnit(
            name: "pinch",
            symbol: "pinch",
            ratio: NSDecimalNumber(mantissa: 591939/8, exponent: -8, isNegative: false)
        )
    }

}

/////////////////////////////////////////////
//  UNIT HELPER FUNCTIONS                  //
/////////////////////////////////////////////

extension MKUnits.Unit {
    
    /* Returns an array of available Unit types */
    static func availableUnits() -> [MKUnits.Unit] {
        
        let imperialVolumeUnits: [MKUnits.Unit] = [VolumeUnit.gallon, VolumeUnit.quart, VolumeUnit.pint, VolumeUnit.cup, VolumeUnit.fluidounce, VolumeUnit.tablespoon, VolumeUnit.teaspoon, VolumeUnit.pinch]
        
        let metricVolumeUnits: [MKUnits.Unit] = [VolumeUnit.decilitre, VolumeUnit.hectolitre, VolumeUnit.litre, VolumeUnit.centilitre, VolumeUnit.microlitre]
        
        let imperialMassUnits: [MKUnits.Unit] = [MassUnit.pound, MassUnit.ounce]
        
        let metricMassUnits: [MKUnits.Unit] = [MassUnit.kilogram, MassUnit.decagram, MassUnit.gram, MassUnit.milligram]
        
        let countingUnits: [MKUnits.Unit] = [CountingUnit.count]
        
        return imperialVolumeUnits + metricVolumeUnits + imperialMassUnits + metricMassUnits + countingUnits
        
    }
    
    /*  Returns a unit object if it can find a unit matching the name given among available units,
        otherwise assumes the unit is count */
    static func unitByName(_ unitName: String) -> MKUnits.Unit {
        for unit in MKUnits.Unit.availableUnits() {
            if unit.name == unitName {
                return unit
            }
        }
        return CountingUnit.count
    }
    
}
