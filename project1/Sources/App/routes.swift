import Routing
import Vapor
import Foundation
import Leaf

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)

public func routes(_ router: Router) throws {
    let bios = [ "kirk": "My name is James Kirk and I love snakes.",
                 "jane": "My name is Jane and I love dogs."
                ]
    
    router.get { req -> Future<View> in
        let context = [String: String]()
        return try req.view().render("home", context)
    }
    
    router.group("staff") { group in
        let allStaff = bios.keys.sorted()
        
        group.get("/") { req -> Future<View> in
            let context = ["names": allStaff]
            return try req.view().render("allStaff", context)
        }
        
        group.get("/", String.parameter) { req -> Future<View> in
            let name = try req.parameters.next(String.self)
            
            struct StaffView: Codable {
                var name: String?
                var bio: String?
                var allNames: [String]
            }
            
            // Any data that needs to be passed to a template is called its context.
            let context: StaffView
            
            if let bio = bios[name] {
                context = StaffView(name: name, bio: bio, allNames: allStaff)
            } else {
                context = StaffView(name: nil, bio: nil, allNames: allStaff)
            }
            
            return try req.view().render("staff", context)
        }
    }
    
    router.get("contact") { req -> Future<View> in
        let context = [String: String]()
        return try req.view().render("contact", context)
    }
}
