import Foundation

public enum MassFraction {
	case solition(substance: Substance, solvent: Solvent, concentration: Concentration)
	
	public init(substance: Decimal, solvent: Decimal) throws {
		guard substance >= Constants.zero else { throw Errors.incorrectSubstance }
		guard solvent >= Constants.zero else { throw Errors.incorrectSolvent }
		guard substance + solvent > Constants.zero else { throw Errors.impossibleSolution }
		self = .solition(substance: Substance(value: substance),
						 solvent: Solvent(value: solvent),
						 concentration: Concentration(value: substance / (substance + solvent) * Constants.hundred))
	}
	
	public init(substance: Decimal, concentration: Decimal) throws {
		guard substance >= Constants.zero else { throw Errors.incorrectSubstance }
		guard concentration > Constants.zero else { throw Errors.incorrectConcentration }
		guard Constants.hundred - concentration > Constants.zero else { throw Errors.impossibleSolution }
		self = .solition(substance: Substance(value: substance),
						 solvent: Solvent(value: substance * (Constants.hundred - concentration) / concentration),
						 concentration: Concentration(value: concentration))
	}
	
	public init(solvent: Decimal, concentration: Decimal) throws {
		guard solvent >= Constants.zero else { throw Errors.incorrectSolvent }
		guard concentration >= Constants.zero else { throw Errors.incorrectConcentration }
		guard Constants.hundred - concentration > Constants.zero else { throw Errors.impossibleSolution }
		self = .solition(substance: Substance(value: (solvent * concentration / (Constants.hundred - concentration))),
						 solvent: Solvent(value: solvent),
						 concentration: Concentration(value: concentration))
	}
}

extension MassFraction {
	public enum Errors: Error {
		case incorrectSubstance
		case incorrectSolvent
		case incorrectConcentration
		case impossibleSolution
	}
	
	private enum Constants {
		static let zero = Decimal.zero
		static let hundred = Decimal(100)
	}
	
	public struct Substance { fileprivate let value: Decimal }
	public struct Solvent{ fileprivate let value: Decimal }
	public struct Concentration { fileprivate let value: Decimal }
}

extension MassFraction {
	public var substance: Decimal {
		switch self { case let .solition(substance, _, _): return substance.value }
	}

	public var solvent: Decimal {
		switch self { case let .solition(_, solvent, _): return solvent.value }
	}

	public var concentration: Decimal {
		switch self { case let .solition(_, _, concentration): return concentration.value }
	}
}
