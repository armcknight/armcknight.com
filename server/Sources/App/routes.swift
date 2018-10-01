import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let witController = WitController()
    router.get("", use: witController.index)
    router.get("wits.json", use: witController.list)
    router.get("wits", use: witController.index)
    router.post("wits", use: witController.create)
}
