import Foundation

public enum Mixing {
	public enum Errors: Error {
		case incorrectVolume
		case incorrectConcentration
		case impossibleConcentration
	}
	
	case solition(v1: Decimal, ω1: Decimal, v2: Decimal, ω2: Decimal, vr: Decimal, ωr: Decimal)
	
	public init(v1: Decimal, ω1: Decimal, v2: Decimal, ω2: Decimal) throws {
		guard v1 >= 0, v2 >= 0, v1 + v2 > 0 else { throw Errors.incorrectVolume }
		guard ω1 >= 0, ω2 >= 0, ω1 <= 100, ω2 <= 100 else { throw Errors.incorrectConcentration }
		let vr = v1 + v2
		let ωr = (v1 * ω1 + v2 * ω2) / (v1 + v2)
		self = .solition(v1: v1, ω1: ω1, v2: v2, ω2: ω1, vr: vr, ωr: ωr)
	}
	
	public init(ω1: Decimal, ω2: Decimal, vr: Decimal, ωr: Decimal) throws {
		guard vr >= 0 else { throw Errors.incorrectVolume }
		guard ω1 >= 0, ω2 >= 0, ω1 <= 100, ω2 <= 100, ωr >= 0, ωr <= 100 else { throw Errors.incorrectConcentration }
		guard max(ω1, ω2) >= ωr, min(ω1, ω2) <= ωr else { throw Errors.impossibleConcentration }
		let v1 = (abs(ω2 - ωr) * vr) / (abs(ω2 - ωr) + abs(ω1 - ωr))
		let v2 = vr - v1
		self = .solition(v1: v1, ω1: ω1, v2: v2, ω2: ω1, vr: vr, ωr: ωr)
	}
}
