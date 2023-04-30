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
	@Published var soluteMassInVolume = AttributedString()
	@Published var soluteMassInLiter = AttributedString()
	@Published var solutionVolume: String = ""
	@Published private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

	init() {
		print("### MolarConcentrationViewModel init")
		Publishers.CombineLatest4(self.$unifiedAtomicMass.removeDuplicates(),
								  self.$molarity.removeDuplicates(),
								  self.$solutionValume.removeDuplicates(),
								  self.$solutionType.removeDuplicates())
		.sink { [weak self] (unifiedAtomicMass, molarity, solutionValume, solutionType) in
			guard let self else { return }
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
			self.soluteMassInVolume = {
				let soluteMass = (unifiedAtomicMass * molarity * solutionValume * valueCoefficient).description
				var mass = AttributedString("\(soluteMass)")
				mass.font = .headline
				var units = AttributedString(" г вещества в ")
				units.font = Font.footnote
				var volume = AttributedString("\(self.solutionVolume)")
				volume.font = .headline
				var solution = AttributedString(" раствора")
				solution.font = Font.footnote
				return mass + units + volume + solution
			}()
			self.soluteMassInLiter = {
				let soluteMass = (unifiedAtomicMass * molarity).description
				var mass = AttributedString("\(soluteMass)")
				mass.font = .headline
				var units = AttributedString(" г вещества в 1 л. раствора")
				units.font = Font.footnote
				return mass + units
			}()
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
				FloatingTextField("Молярная масса вещества", value: self.$vm.unifiedAtomicMass)
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
			Text(self.vm.soluteMassInVolume)
			Text(self.vm.soluteMassInLiter)
		}
	}
}

struct MolarConcentrationView_Previews: PreviewProvider {
	static var previews: some View {
		MolarConcentrationView()
	}
}
