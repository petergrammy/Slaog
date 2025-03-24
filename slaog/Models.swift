import Foundation

struct Goal: Identifiable {
    var id: UUID
    var title: String
    var deadline: Date
    var divisionType: AddGoalView.DivisionType
    var timeInterval: Int
    var timeUnit: AddGoalView.TimeUnit
    var tasks: [String]
    var progress: Double
}

struct Group: Identifiable {
    var id: UUID
    var name: String
    var members: [Member]
    var sharedGoals: [Goal]
}

struct Member: Identifiable {
    var id: UUID
    var name: String
    var isAdmin: Bool
}

