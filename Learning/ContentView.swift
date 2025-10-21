//
//  ContentView.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 20/10/2025.
import SwiftUI

struct ContentView: View {
    @State private var selectedDate = 20
    @State private var learnedDays = 5
    @State private var frozenDays = 1
    
    let days = [
        ("SUN", 20), ("MON", 21), ("TUE", 22),
        ("WED", 23), ("THU", 24), ("FRI", 25), ("SAT", 26)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 16) {
            // Top header
                // Top header with icons
                HStack {
                    Text("Activity")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "calendar")}
                        Button(action: {}) {
                            Image(systemName: "person.circle")}
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                }
                .padding(.top, 20)

            
            // Month navigation
           
            // Stats
                VStack(alignment: .leading, spacing: 5) { HStack {
                    Text("October 2025")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 10) {
                        Image(systemName: "chevron.left")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.orange)
                }
                    
                    // Days row
                    HStack(spacing: 12) {
                        ForEach(days, id: \.1) { day, num in
                            Button(action: {
                                selectedDate = num // 👈 updates the selected day
                            }) {
                                VStack {
                                    Text(day)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                    Text("\(num)")
                                        .font(.headline)
                                        .padding(10)
                                        .background(
                                            Circle().fill(num == selectedDate ? Color.blue : Color.orange.opacity(0.8))
                                        )
                                        .foregroundColor(.white)
                                }
                            }
                            .buttonStyle(.plain) // 👈 removes default gray tap style
                        }
                    }

                    
                    
                    Text("Learning Swift")
                        .font(.headline)
                        .foregroundColor(.white)
                    Divider().background(Color.white.opacity(0.1))

                    HStack(spacing: 28) {
                        HStack(spacing: 30) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(learnedDays)")
                                    .bold()
                                    .foregroundColor(.white)
                                Text("Days Learned")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.vertical, 9)
                        .padding(.horizontal, 16)
                        .background(Color(red: 0.25, green: 0.17, blue: 0.11)) // brownish tone
                        .cornerRadius(30)
                        
                        HStack(spacing: 30) {
                            Image(systemName: "cube.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(frozenDays)")
                                    .bold()
                                    .foregroundColor(.white)
                                Text("Day Freezed")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.vertical, 9)
                        .padding(.horizontal, 16)
                        .background(Color(red: 0.13, green: 0.20, blue: 0.25)) // bluish tone
                        .cornerRadius(30)
                    }
                    Spacer().padding()
                    
                      
                }  .padding(10)
                    .background(Color(red: 0.10, green: 0.10, blue: 0.10))
                    .cornerRadius(16)

                
                // Big button
                VStack(spacing: 16) {
                    Button(action: {}) {
                        Text("Log as Learned")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 250)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    Spacer().padding(16)

                    
                    Button(action: {}) {
                        Text("Log as Freezed")
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    
                    Text("1 out of 2 Freezes used")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
           
        }
        .padding()
                   .background(Color.black.ignoresSafeArea())
    }
}
#Preview {
    ContentView()
}
