import Foundation

public enum Mass: Equatable {
	case milligram(value: Decimal)
	case gram(value: Decimal)
	case kilogram(value: Decimal)
	
	var grams: Decimal {
		switch self {
		case let .milligram(value):
			return value / 1000
		case let .gram(value):
			return value
		case let .kilogram(value):
			return value * 1000
		}
	}
}

public enum Solute: Equatable {
	case moles(Decimal)
	case mass(Molecule, Mass)
	
	init(molarity: Molarity, solution: Solution) {
		self = .moles(molarity.value * solution.liter)
	}
	
	var moles: Decimal {
		switch self {
		case let .moles(value):
			return value
		case let .mass(molecule, value):
			return value.grams / molecule.unifiedAtomicMass
		}
	}
}

public enum Solution {
	case liter(Decimal)
	case milliliter(Decimal)
	
	var liter: Decimal {
		switch self {
		case .liter(let value):
			return value
		case .milliliter(let value):
			return value / 1000
		}
	}
}

public enum Molarity {
	case value(Decimal)

	init(solute: Solute, solution: Solution) {
		self = .value(solute.moles / solution.liter)
	}
	
	var value: Decimal {
		switch self {
		case let .value(value):
			return value
		}
	}
}
