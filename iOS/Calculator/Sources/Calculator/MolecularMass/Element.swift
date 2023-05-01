import Foundation

public enum Element: String, Equatable, CaseIterable
{
	case H, C, N, O, F, Na, P, S, Cl, К, Ca, Fe, Br, I
	
	public var number: Int {
		switch self {
		case .H: return 1
		case .C: return 6
		case .N: return 7
		case .O: return 8
		case .F: return 9
		case .Na: return 11
		case .P: return 15
		case .S: return 16
		case .Cl: return 17
		case .К: return 19
		case .Ca: return 20
		case .Fe: return 26
		case .Br: return 35
		case .I: return 53
		}
	}
	
	public var symbol: String {
		self.rawValue
	}
	
	public var name: String {
		switch self {
		case .H: return "Водород"
		case .C: return "Углерод"
		case .N: return "Азот"
		case .O: return "Кислород"
		case .F: return "Фтор"
		case .Na: return "Натрий"
		case .P: return "Фосфор"
		case .S: return "Сера"
		case .Cl: return "Хлор"
		case .К: return "Калий"
		case .Ca: return "Кальций"
		case .Fe: return "Железо"
		case .Br: return "Бром"
		case .I: return "Йод"
		}
	}
	private enum Mass {
		static let H = Decimal(string: "1.00794")!
		static let C = Decimal(string: "12.011")!
		static let N = Decimal(string: "14.0067")!
		static let O = Decimal(string: "15.9994")!
		static let F = Decimal(string: "18.9984")!
		static let Na = Decimal(string: "22.98977")!
		static let P = Decimal(string: "30.97376")!
		static let S = Decimal(string: "32.06")!
		static let Cl = Decimal(string: "35.453")!
		static let K = Decimal(string: "39.0983")!
		static let Ca = Decimal(string: "40.08")!
		static let Fe = Decimal(string: "55.847")!
		static let Br = Decimal(string: "79.904")!
		static let I = Decimal(string: "126.9045")!
		
	}
	
	public var mass: Decimal {
		switch self {
		case .H: return Mass.H
		case .C: return Mass.C
		case .N: return Mass.N
		case .O: return Mass.O
		case .F: return Mass.F
		case .Na: return Mass.Na
		case .P: return Mass.P
		case .S: return Mass.S
		case .Cl: return Mass.Cl
		case .К: return Mass.K
		case .Ca: return Mass.Ca
		case .Fe: return Mass.Fe
		case .Br: return Mass.Br
		case .I: return Mass.I
		}
	}
}
