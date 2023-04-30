import Foundation
import SwiftUI

enum Routes: CaseIterable {

	case massFraction
	case pirsonMethod
	case molecularMass
	case molarConcentration
	
	@ViewBuilder
	var view: some View {
		switch self {
		case .massFraction:
			MassFractionView()
		case .pirsonMethod:
			PirsonMethodView()
		case .molecularMass:
			MolecularMassView()
		case .molarConcentration:
			MolarConcentrationView()
		}
	}
}

final class Router: ObservableObject {
	@Published var navPath: NavigationPath = .init()
	@Published var showSheet = false
}

extension Routes: CustomStringConvertible {
	var description: String {
		switch self {
		case .massFraction: return "Массовая доля"
		case .pirsonMethod: return "Метод Пирсона"
		case .molecularMass: return "Молекулярная масса"
		case .molarConcentration: return "Молярность раствора"
		}
	}
}
