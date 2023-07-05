

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    Image(uiImage: #imageLiteral(resourceName: "sweathershop"))
                        .background(Color.clear)
                    
                    //                    Spacer()
                    //                    PrimaryButton(title: "Get Started")
                    
                    NavigationLink(
                        destination: SignInView(),
                        label: {
                            Text("Sign In")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color("PrimaryColor"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hue: 1.0, saturation: 0.007, brightness: 0.898))
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                                .padding(.vertical)
                        })
                    //                        .navigationBarHidden(true)
                    
                    HStack {
                        Text("Don't have an account")
                        NavigationLink(
                        destination: SignupView(),
                        label:{
                            Text("Sign up")
                                .foregroundColor(Color("PrimaryColor"))
                            }
                        )
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
