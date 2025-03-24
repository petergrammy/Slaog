import SwiftUI

struct AddGroupView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var groups: [Group]
    
    @State private var action = GroupAction.create
    @State private var groupName = ""
    @State private var groupId = ""
    @State private var selectedGoals: [Goal] = []
    @State private var availableGoals: [Goal] = [] // This would be fetched from your data store
    
    enum GroupAction: String, CaseIterable, Identifiable {
        case create = "创建群组"
        case join = "加入群组"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("操作", selection: $action) {
                        ForEach(GroupAction.allCases) { action in
                            Text(action.rawValue).tag(action)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                if action == .create {
                    Section(header: Text("群组信息")) {
                        TextField("群组名称", text: $groupName)
                    }
                    
                    Section(header: Text("选择要分享的目标")) {
                        ForEach(availableGoals) { goal in
                            Button(action: {
                                toggleGoalSelection(goal)
                            }) {
                                HStack {
                                    Text(goal.title)
                                    Spacer()
                                    if selectedGoals.contains(where: { $0.id == goal.id }) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                } else {
                    Section(header: Text("加入群组")) {
                        TextField("群组ID", text: $groupId)
                        
                        Section(header: Text("选择要分享的目标")) {
                            ForEach(availableGoals) { goal in
                                Button(action: {
                                    toggleGoalSelection(goal)
                                }) {
                                    HStack {
                                        Text(goal.title)
                                        Spacer()
                                        if selectedGoals.contains(where: { $0.id == goal.id }) {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle(action == .create ? "创建群组" : "加入群组")
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(action == .create ? "创建" : "加入") {
                    if action == .create {
                        createGroup()
                    } else {
                        joinGroup()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(action == .create ? groupName.isEmpty : groupId.isEmpty)
            )
        }
    }
    
    func toggleGoalSelection(_ goal: Goal) {
        if let index = selectedGoals.firstIndex(where: { $0.id == goal.id }) {
            selectedGoals.remove(at: index)
        } else {
            selectedGoals.append(goal)
        }
    }
    
    func createGroup() {
        let newGroup = Group(
            id: UUID(),
            name: groupName,
            members: [Member(id: UUID(), name: "You", isAdmin: true)],
            sharedGoals: selectedGoals
        )
        
        groups.append(newGroup)
    }
    
    func joinGroup() {
        // In a real app, you would make an API call to join the group
        // For this example, we'll just create a mock group
        let joinedGroup = Group(
            id: UUID(),
            name: "Joined Group",
            members: [
                Member(id: UUID(), name: "Admin", isAdmin: true),
                Member(id: UUID(), name: "You", isAdmin: false)
            ],
            sharedGoals: selectedGoals
        )
        
        groups.append(joinedGroup)
    }
}

