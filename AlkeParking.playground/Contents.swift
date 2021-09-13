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
    
    func listVehicles(){
        for vehicle in vehicles{
            print(vehicle.plate)
        }
    }
    
    func earningInformation(){
        return print("\(checkAndEarnings.checkedouts) vehicles have checked out and have earnings of $\(checkAndEarnings.earnings)")
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

var alkeParking = Parking()

let vehicle1 = Vehicle(plate: "AA111AA", type:VehicleType.car, checkInTime: Date(), discountCard:"DISCOUNT_CARD_001")
let vehicle2 = Vehicle(plate: "B222BBB", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle3 = Vehicle(plate: "CC333CC", type:VehicleType.miniBus, checkInTime: Date(), discountCard:nil)
let vehicle4 = Vehicle(plate: "DD444DD", type:VehicleType.bus, checkInTime: Date(), discountCard:"DISCOUNT_CARD_002")
let vehicle5 = Vehicle(plate: "AA111BB", type:VehicleType.car, checkInTime: Date(), discountCard:"DISCOUNT_CARD_003")
let vehicle6 = Vehicle(plate: "B222CCC", type:VehicleType.moto, checkInTime: Date(), discountCard:"DISCOUNT_CARD_004")
let vehicle7 = Vehicle(plate: "CC333DD", type:VehicleType.miniBus, checkInTime: Date(), discountCard:nil)
let vehicle8 = Vehicle(plate: "DD444EE", type:VehicleType.bus, checkInTime: Date(), discountCard:"DISCOUNT_CARD_005")
let vehicle9 = Vehicle(plate: "AA111CC", type:VehicleType.car, checkInTime: Date(), discountCard: nil)
let vehicle10 = Vehicle(plate: "B222DDD", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle11 = Vehicle(plate: "CC333EE", type:VehicleType.miniBus, checkInTime: Date(), discountCard:nil)
let vehicle12 = Vehicle(plate: "DD444GG", type:VehicleType.bus, checkInTime: Date(), discountCard:"DISCOUNT_CARD_006")
let vehicle13 = Vehicle(plate: "AA111DD", type:VehicleType.car, checkInTime: Date(), discountCard:"DISCOUNT_CARD_007")
let vehicle14 = Vehicle(plate: "B222EEE", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle15 = Vehicle(plate: "CC333FF", type:VehicleType.miniBus, checkInTime: Date(), discountCard:nil)
let vehicle16 = Vehicle(plate: "AA111EE", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let vehicle17 = Vehicle(plate: "B222FFF", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle18 = Vehicle(plate: "CC333GG", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle19 = Vehicle(plate: "DD444HH", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")
let vehicle20 = Vehicle(plate: "AA111FF", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")

//MARK: - Vehiculo adicional
let vehicle21 = Vehicle(plate: "B222GGG", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)

//MARK: - Vehiculo patente repetida
let vehicle22 = Vehicle(plate: "AA111FF", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")

//MARK: - Arreglo de vehiculos
var vehiclesArray = [vehicle1, vehicle2,vehicle3,vehicle4,vehicle5,vehicle6,vehicle7,vehicle8,vehicle9, vehicle10,vehicle11,vehicle12,vehicle13,vehicle14,vehicle15, vehicle16, vehicle17,vehicle18,vehicle19,vehicle20,vehicle21, vehicle22]


func addToSetVehicles(_ vehiclesArray:[Vehicle] ) {
    for vehicle in vehiclesArray {
        alkeParking.checkInVehicle(vehicle) {(onFinish: Bool) -> Void in
            return
        }
    }
}


addToSetVehicles(vehiclesArray)


//MARK: - Vehiculo retirado
print("\n\nCheck Out Vehicle")
print("************************")
alkeParking.checkOutVehicle(vehicle1.plate) { (fee: Int) -> Void in
    print("Your fee is $\(fee). Come back soon!")
    return
} onError: { (Bool) -> Void in
    print("Sorry, the check-out failed")
    return
}

//Intentar eliminar el mismo vehiculo
alkeParking.checkOutVehicle(vehicle1.plate) { (fee: Int) -> Void in
    print("Your fee is $\(fee). Come back soon!")
    return
} onError: { (Bool) -> Void in
    print("Sorry, the check-out failed")
    return
}


//MARK: - Checked outs y ganancias
print("\n\nTotal Information")
print("************************")
alkeParking.earningInformation()


//MARK: - listar patentes
print("\n\nPlates")
print("************************")
alkeParking.listVehicles()

