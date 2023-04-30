import SwiftUI
import Combine
import Calculator

final class MolarConcentrationViewModel: ObservableObject {
	enum SoluteUnits {
		case moles
		case milligram
		case gram
		case kilogram
	}
	enum VolumeUnits {
		case liter
		case milliliter
	}
	@Published var unifiedAtomicMass: Decimal = Decimal.zero
	@Published var molarity: Decimal = Decimal.zero
	@Published var solutionHeder: String = ""
	@Published var solutionValume: Decimal = Decimal.zero
	@Published var solutionType: VolumeUnits = .milliliter
	@Published var soluteMassInVolume: String = ""
	@Published var soluteMassInLiter: String = ""
	@Published var solutionVolume: String = ""
	@Published private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

	init() {
		print("@@@ MolarConcentrationViewModel init")
		Publishers.CombineLatest4(self.$unifiedAtomicMass.removeDuplicates(),
								  self.$molarity.removeDuplicates(),
								  self.$solutionValume.removeDuplicates(),
								  self.$solutionType.removeDuplicates())
		.sink { (unifiedAtomicMass, molarity, solutionValume, solutionType) in
			var valueCoefficient = Decimal(floatLiteral: 1)
			switch solutionType {
			case .liter:
				self.solutionHeder = "Объем раствора (литры)"
				self.solutionVolume = "\(solutionValume) л."
			case .milliliter:
				valueCoefficient = 0.001
				self.solutionHeder = "Объем раствора (мл.)"
				self.solutionVolume = "\(solutionValume) мл."
			}
			self.soluteMassInVolume = (unifiedAtomicMass * molarity * solutionValume * valueCoefficient).description
			self.soluteMassInLiter = (unifiedAtomicMass * molarity * valueCoefficient).description
		}
		.store(in: &cancellables)
	}
}

struct MolarConcentrationView: View {
	@EnvironmentObject var router: Router
	@StateObject private var vm = MolarConcentrationViewModel()
	
	var body: some View {
		List {
			HStack {
				FloatingTextField("Молекулярная масса вещества", value: self.$vm.unifiedAtomicMass)
				Button("Ввести") {
					router.showSheet.toggle()
				}
				.buttonStyle(.borderedProminent)
				.sheet(isPresented: $router.showSheet) {
					MolecularMassView(type: .callback { value in
						self.vm.unifiedAtomicMass = value
						router.showSheet.toggle()
					})
				}
			}
			.listRowSeparator(.hidden)
			FloatingTextField("Молярность раствора", value: self.$vm.molarity)
			HStack {
				FloatingTextField(self.vm.solutionHeder, value: self.$vm.solutionValume)
				Picker("", selection: self.$vm.solutionType) {
					Text("л.").tag(MolarConcentrationViewModel.VolumeUnits.liter)
					Text("мл.").tag(MolarConcentrationViewModel.VolumeUnits.milliliter)
				}
				.frame(width: 70)
			}
			.listRowSeparator(.hidden)
			Text("\(self.vm.soluteMassInVolume) г вещества в \(self.vm.solutionVolume) раствора")
			Text("\(self.vm.soluteMassInLiter) г вещества в 1 л. раствора")
		}
	}
}

struct MolarConcentrationView_Previews: PreviewProvider {
	static var previews: some View {
		MolarConcentrationView()
	}
}
