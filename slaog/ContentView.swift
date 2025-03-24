import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showIntro = true
    @State private var isAuthenticated = false
    
    var body: some View {
        if !isAuthenticated {
            AuthView(isAuthenticated: $isAuthenticated)
        } else if showIntro {
            IntroView(showIntro: $showIntro)
        } else {
            MainTabView(selectedTab: $selectedTab)
        }
    }
}

struct MainTabView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SlaogView()
                .tabItem {
                    Label("Slaog", systemImage: "list.bullet.clipboard")
                }
                .tag(0)
            
            GroupView()
                .tabItem {
                    Label("群组", systemImage: "person.3")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("个人", systemImage: "person")
                }
                .tag(2)
        }
    }
}

struct IntroView: View {
    @Binding var showIntro: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Welcome to Slaog")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Image(systemName: "arrow.triangle.2.circlepath")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("'goals'总是难以实现，因为人们立下它们而没有任何行动。如果人们从行动开始，那么目标就易于实现了。'slaog'就是把'goals'反过来写，在这个app里你一定可以实现那些曾经无比困难的目标。")
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            Button {
                withAnimation {
                    showIntro = false
                }
            } label: {
                Text("开始使用")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 50)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
