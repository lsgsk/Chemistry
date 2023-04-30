import SwiftUI

@main
struct ConcentrationApp: App {
	
	@StateObject private var router = Router()
	
	var body: some Scene {
		WindowGroup {
			NavigationStack(path: $router.navPath) {
				List(Routes.allCases, id: \.description) { route in
					NavigationLink(route.description, value: route)
				}
				.navigationTitle("Формулы")
				.navigationDestination(for: Routes.self) { route in
					route.view.navigationTitle(route.description)
				}
			}
			.environmentObject(router)
		}
	}
}
