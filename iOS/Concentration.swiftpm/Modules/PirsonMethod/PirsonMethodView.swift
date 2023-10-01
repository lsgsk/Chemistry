import SwiftUI
import Combine

final class PirsonMethodViewModel: ObservableObject {
	enum KnownVolumes: Equatable {
		case twoSubstance
		case resultSubstance
	}
	
	@Published var selected: PirsonMethodViewModel.KnownVolumes = .twoSubstance
	@Published var value1: Decimal = Decimal.zero
	@Published var concentration1: Decimal = Decimal.zero
	@Published var value2: Decimal = Decimal.zero
	@Published var concentration2: Decimal = Decimal.zero
	@Published var valueResult: Decimal = Decimal.zero
	@Published var concentrationResult: Decimal = Decimal.zero
	
	private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
	
	init() {
		print("### PirsonMethodViewModel init")
		let first = Publishers.CombineLatest($value1.removeDuplicates(), $concentration1.removeDuplicates())
		let second = Publishers.CombineLatest($value2.removeDuplicates(), $concentration2.removeDuplicates())
		let result = Publishers.CombineLatest($valueResult.removeDuplicates(), $concentrationResult.removeDuplicates())
		Publishers.CombineLatest3(first, second, result).sink { first, second, result in
			let value1 = first.0; let concentration1 = first.1
			let value2 = second.0; let concentration2 = second.1
			let valueResult = result.0; let concentrationResult = result.1
			do {
				let mix = try {
					switch self.selected {
					case .twoSubstance:
						return try Mixing(v1: value1, ω1: concentration1, v2: value2, ω2: concentration2)
					case .resultSubstance:
						return try Mixing(ω1: concentration1, ω2: concentration2, vr: valueResult, ωr: concentrationResult)
					}
				}()
				switch mix {
				case let .solition(_, _, _, _, vr, ωr) where self.selected == .twoSubstance:
					self.valueResult = vr
					self.concentrationResult = ωr
				case let .solition(v1, _, v2, _, _, _) where self.selected == .resultSubstance:
					self.value1 = v1
					self.value2 = v2
				case .solition:
					break
				}
			}
			catch is Mixing.Errors where self.selected == .twoSubstance {
				self.valueResult = Decimal.zero
				self.concentrationResult = Decimal.zero
			}
			catch is Mixing.Errors where self.selected == .resultSubstance {
				self.value1 = Decimal.zero
				self.value2 = Decimal.zero
			}
			catch {
				print("jh")
			}
		}
		.store(in: &cancellables)
	}
}

struct PirsonMethodView: View {
	
	@StateObject private var vm = PirsonMethodViewModel()
	
	var body: some View {
		List {
			Picker(":", selection: $vm.selected) {
				Text("Знаем V и ω растворов").tag(PirsonMethodViewModel.KnownVolumes.twoSubstance)
				Text("Знаем V и ω смеси").tag(PirsonMethodViewModel.KnownVolumes.resultSubstance)
			}
			.labelsHidden()
			.listRowSeparator(.hidden)
			.onChange(of: vm.selected) { _ in hideKeyboard() }
			VStack {
				HStack {
					FloatingTextField("V1, мл.", value: $vm.value1)
						.disabled(vm.selected == .resultSubstance)
					FloatingTextField("ω1%", value: $vm.concentration1)
				}
				HStack {
					FloatingTextField("V2, мл.", value: $vm.value2)
						.disabled(vm.selected == .resultSubstance)
					FloatingTextField("ω2%", value: $vm.concentration2)
				}
				HStack {
					FloatingTextField("V смеси, мл.", value: $vm.valueResult)
						.disabled(vm.selected == .twoSubstance)
					FloatingTextField("ω смеси %", value: $vm.concentrationResult)
						.disabled(vm.selected == .twoSubstance)
				}
			}
			.padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
		}
	}
}

struct PirsonMethodView_Previews: PreviewProvider {
	static var previews: some View {
		PirsonMethodView()
	}
}
