import UIKit

protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get }
    var parkedTime: Int { get }

}

struct Parking {
    var vehicles: Set<Vehicle> = []
    var checkAndEarnings: (checkedouts: Int, earnings: Int) = (0,0)
    let maxCapacity = 20
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        
        guard maxCapacity > vehicles.count else {
            print("Sorry, the check-in failed. The Parking is full")
            onFinish(false)
            return
        }
        
        if vehicles.contains(vehicle){
            print("Sorry, the check-in failed. The plate: \(vehicle.plate) has already exist")
            onFinish(false)
            return
        } else {
            vehicles.insert(vehicle)
            print("Welcome to AlkeParking!")
            onFinish(true)
            return
        }
    }
    
    mutating func checkOutVehicle(_ plate: String, onSuccess: (Int) -> Void , onError: (Bool)-> Void ){
        
        var vehicleToCheckOut: Vehicle
        
        for vehicle in vehicles {
            if vehicle.plate == plate {
                vehicleToCheckOut = vehicle
                let totalFee = calculateFee(vehicleToCheckOut.type, parkedTime: vehicleToCheckOut.parkedTime, hasDiscountCard: vehicleToCheckOut.discountCard != nil)
                vehicles.remove(vehicleToCheckOut)
                checkAndEarnings.checkedouts += 1
                checkAndEarnings.earnings += totalFee
                onSuccess(totalFee)
                return
            }
        }
        
        onError(true)
        return

    }
    func calculateFee(_ vehicle: VehicleType, parkedTime: Int, hasDiscountCard: Bool) -> Int {
        
        var feeRate = vehicle.timeRate()
        
        if parkedTime > 120 {
            let additional = Int(ceil(((Double(parkedTime) - 120) / 15 ) * 5 ))
            feeRate += additional
        }
        
        if hasDiscountCard {
            return Int(Double(feeRate) * 0.85)
        } else {
            return feeRate
        }
    }

    
}

enum VehicleType {
    
    case car
    case moto
    case miniBus
    case bus
    
    func timeRate () -> Int {
        switch self {
        case .car:
            return 20
        case .moto:
            return 15
        case .miniBus:
            return 25
        case .bus:
            return 30
        }
    }
}

struct Vehicle: Parkable, Hashable {
    
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    let discountCard: String?
    var parkedTime: Int {
        get {
            Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
    
}

