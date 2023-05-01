import SwiftUI
import Combine
import Calculator

final class MolarConcentrationViewModel: ObservableObject {
	enum VolumeUnits {
		case liter
		case milliliter
	}

	@Published var molarMass: Decimal = Decimal.zero
	@Published var molarity: Decimal = Decimal.zero
	@Published var solutionHeder: String = ""
	@Published var solutionValume: Decimal = Decimal.zero
	@Published var solutionType: VolumeUnits = .milliliter
	@Published var soluteMassInVolume = AttributedString()
	@Published var soluteMassInLiter = AttributedString()
	@Published private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

	init() {
		print("### MolarConcentrationViewModel init")
		Publishers.CombineLatest4(self.$molarMass.removeDuplicates(),
								  self.$molarity.removeDuplicates(),
								  self.$solutionValume.removeDuplicates(),
								  self.$solutionType.removeDuplicates())
		.sink { [weak self] (molarMass, molarity, solutionVolume, solutionType) in
			guard let self else { return }
			switch solutionType {
			case .liter:
				self.solutionHeder = "Объем раствора (литры)"
			case .milliliter:
				self.solutionHeder = "Объем раствора (мл.)"
			}
			let (solute, soluteInLiter) = {
				do {
					let volume: MolarityFormula.Solution = solutionType == .liter
					? try .init(volume: .liter(solutionVolume))
					: try .init(volume: .milliliter(solutionVolume))
					return (
						try MolarityFormula(molarity: molarity, volume: volume).gramsOfSolute(for: molarMass),
						try MolarityFormula(molarity: molarity, volume: .init(volume: .liter(1))).gramsOfSolute(for: molarMass)
					)
				}
				catch {
					return (Decimal.zero, Decimal.zero)
				}
			}()
			
			self.soluteMassInVolume = {
				var mass = AttributedString("\(solute.description)")
				mass.font = .headline
				var units = AttributedString(" г. вещества в ")
				units.font = Font.footnote
				var volume = AttributedString("\(solutionVolume)")
				volume.font = .headline
				var solution: AttributedString
				switch solutionType {
				case .liter:
					solution = AttributedString(" л. раствора")
				case .milliliter:
					solution = AttributedString(" мл. раствора")
				}
				solution.font = Font.footnote
				return mass + units + volume + solution
			}()
			self.soluteMassInLiter = {
				var mass = AttributedString("\(soluteInLiter.description)")
				mass.font = .headline
				var units = AttributedString(" г. вещества в 1 л. раствора")
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
				FloatingTextField("Молярная масса вещества", value: self.$vm.molarMass)
				Button("Ввести") {
					router.showSheet.toggle()
				}
				.buttonStyle(.borderedProminent)
				.sheet(isPresented: $router.showSheet) {
					MolecularMassView(type: .callback { value in
						self.vm.molarMass = value
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
				.labelsHidden()
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
