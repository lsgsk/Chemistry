import Foundation

public enum MolarityFormula {
	case solution(molarity: Molarity, moles: Solute, volume: Solution)
	
	public init(moles: Solute, volume: Solution) throws {
		guard moles.moles >= Constants.zero else { throw Errors.incorrectMoles }
		guard volume.liters > Constants.zero else { throw Errors.incorrectVolume }
		self = .solution(molarity: .init(value: moles.moles / volume.liters),
						 moles: moles,
						 volume: volume)
	}
	
	public init(molarity: Decimal, moles: Solute) throws {
		guard molarity > Constants.zero else { throw Errors.incorrectMolarity }
		guard moles.moles >= Constants.zero else { throw Errors.incorrectMoles }
		self = .solution(molarity: .init(value: molarity),
						 moles: moles,
						 volume: .volume(.init(value: moles.moles / molarity)))
	}
	
	public init(molarity: Decimal, volume: Solution) throws {
		guard molarity >= Constants.zero else { throw Errors.incorrectMolarity }
		guard volume.liters >= Constants.zero else { throw Errors.incorrectVolume }
		self = .solution(molarity: .init(value: molarity),
						 moles: .moles(.init(value: molarity * volume.liters)),
						 volume: volume)
	}
}

extension MolarityFormula {
	public enum Errors: Error {
		case incorrectMoles
		case incorrectVolume
		case incorrectMolarity
	}
	
	private enum Constants {
		static let zero = Decimal.zero
		static let thousand = Decimal(1000)
	}
}

extension MolarityFormula {
	public var molarity: Decimal {
		switch self { case let .solution(molarity, _, _): return molarity.value }
	}
	
	public var molesOfSolute: Decimal {
		switch self { case let .solution(_, moles, _): return moles.moles }
	}
	
	public func gramsOfSolute(for molarMass: Decimal) -> Decimal {
		switch self { case let .solution(_, moles, _): return moles.moles * molarMass }
	}
	
	public var litersOfSolution: Decimal {
		switch self { case let .solution(_, _, volume): return volume.liters }
	}
}

extension MolarityFormula {
	public struct Molarity { fileprivate let value: Decimal }
	public struct Moles { fileprivate let value: Decimal }
	public struct Volume {
		public enum Units {
			case liter(Decimal)
			case milliliter(Decimal)
		}
		fileprivate let value: Decimal
	}
	public struct Mass {
		public enum Units  {
			case milligram(Decimal)
			case gram(Decimal)
			case kilogram(Decimal)
		}
		fileprivate let value: Decimal
	}
	
	public enum Solute {
		case moles(Moles)
		
		init(moles: Decimal) {
			self = .moles(Moles(value: moles))
		}
		
		init(mass: Mass.Units, molarMass: Decimal) {
			switch mass {
			case let .milligram(value):
				self = .moles(.init(value: value / Constants.thousand))
			case let .gram(value):
				self = .moles(.init(value: value))
			case let .kilogram(value):
				self = .moles(.init(value: value * Constants.thousand))
			}
		}
		
		public var moles: Decimal {
			switch self { case let .moles(moles): return moles.value }
		}
	}
	
	public enum Solution {
		case volume(Volume)
		
		public init(volume: Volume.Units) throws {
			switch volume {
			case let .liter(value):
				guard value >= Constants.zero else { throw Errors.incorrectVolume }
				self = .volume(.init(value: value))
			case let .milliliter(value):
				guard value >= Constants.zero else { throw Errors.incorrectVolume }
				self = .volume(.init(value: value / Constants.thousand))
			}
		}
		
		var liters: Decimal {
			switch self { case let .volume(volume): return volume.value }
		}
	}
}
