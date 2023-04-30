import Foundation

public enum MassFraction
{
	private static let zero = Decimal.zero
	private static let hundred = Decimal(string: "100")!
	
	case substance(Decimal)
	case solvent(Decimal)
	case concentration(Decimal)
	
	public var value: Decimal {
		switch self {
		case let .substance(value): return value
		case let .solvent(value): return value
		case let .concentration(value): return value
		}
	}
	
	public init(solvent: Decimal, concentration: Decimal) {
		guard solvent >= Self.zero, concentration >= Self.zero, Self.hundred - concentration > Self.zero else {
			self = .substance(Self.zero); return
		}
		self = .substance(solvent * concentration / (Self.hundred - concentration))
	}
	
	public init(substance: Decimal, concentration: Decimal) {
		guard substance >= Self.zero, concentration > Self.zero else {
			self = .solvent(Self.zero); return
		}
		self = .solvent(substance * (Self.hundred - concentration) / concentration)
	}
	
	public init(substance: Decimal, solvent: Decimal) {
		guard substance >= Self.zero, solvent >= Self.zero, substance + solvent > Self.zero else {
			self = .concentration(Self.zero); return
		}
		self = .concentration(substance / (substance + solvent) * Self.hundred)
	}
}
