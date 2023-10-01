import SwiftUI

struct ElemetView: View {
	private let element: Element
	private let action: (Element) -> Void
	
	init(_ element: Element, action: @escaping (Element) -> Void) {
		self.element = element
		self.action = action
	}
	
	var body: some View {
		Button {
			self.action(self.element)
		} label: {
			VStack {
				Grid {
					GridRow {
						Text(self.element.symbol)
							.font(Fonts.symbol)
							.frame(width: 25)
						Spacer()
						Text("\(self.element.number)")
							.font(Fonts.number)
							.frame(width: 20)
					}
					Text(self.element.name).font(Fonts.name)
						.frame(width: 50, alignment: .center)
					Text(self.element.mass.description)
						.font(Fonts.mass)
				}
			}
		}
		.frame(width: 60, height: 60)
		.border(.blue)
		.foregroundColor(.blue)
	}
}

// внедрить https://www.swiftbysundell.com/articles/encapsulating-swiftui-view-styles/
extension ElemetView {
	private enum Fonts {
		static let symbol = Font.system(size: 20)
		static let number = Font.system(size: 15)
		static let name = Font.system(size: 10)
		static let mass = Font.system(size: 7)
	}
}

struct ElemetView_Previews: PreviewProvider {
	static var previews: some View {
		ElemetView(.Fe) { _ in }
	}
}
