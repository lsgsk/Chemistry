import SwiftUI

struct FloatingTextField: View {
	@Environment(\.isEnabled) var isEnabled
	@Binding private var value: Decimal
	private var placeholder: String

	init(_ placeholder: String, value: Binding<Decimal>) {
		self.placeholder = placeholder
		self._value = value
	}
	
	var body: some View {
		ZStack {
			TextField("", value: self.$value, format: .number)
				.keyboardType(.decimalPad)
			HStack {
				Text(self.placeholder)
					.font(.caption2)
					.foregroundColor(Color.gray.opacity(0.7))
					.offset(x: 2, y: -18)
				Spacer()
			}
		}
		.padding(EdgeInsets(top: 15, leading: 5, bottom: 5, trailing: 5))
		.overlay(RoundedRectangle(cornerRadius: 7)
			.stroke(.gray, lineWidth: 0.2)
		)
		.background(RoundedRectangle(cornerRadius: 7)
			.fill(self.isEnabled ? Color.clear : Color.gray.opacity(0.2))
		)
	}
}

struct FloatingLabelInput_Previews: PreviewProvider {
	
	@State private static var value = Decimal.zero
	
	static var previews: some View {
		FloatingTextField("Placeholder", value: Self.$value).frame(width: 350, height: 160).disabled(true)
	}
}
