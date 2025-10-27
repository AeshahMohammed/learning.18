//
//  Task1.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 26/10/2025.
//

import SwiftUI

struct Task1: View {
    @State private var selectedDuration = "Week"
    @State private var subject = "Swift"
    
    var body: some View {
        NavigationStack  {
                        ZStack {
                            Color(.systemBackground)
                                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    // App logo
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "flame.fill")
                                
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.orange.opacity(100))
                                .frame(width: 50, height: 50)
                        )
                        .glassEffect()
                    
                    // Intro texts
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello Learner")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                        Text("This app will help you learn everyday!")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Learning subject
                    VStack(alignment: .leading, spacing: 10) {
                        Text("I want to learn")
                            .foregroundColor(.primary)
                            .font(.headline)
                        TextField("Enter your subject", text: $subject)
                                .textFieldStyle(.plain)
                                .padding(.vertical, 8)
                        Divider()
                                     .background(Color.secondary)
                                //.foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                
              
                    
                    // Duration picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("I want to learn it in a")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        
                        HStack(spacing: 8) {
                            ForEach(["Week", "Month", "Year"], id: \.self) { duration in
                                Button(action: {
                                    selectedDuration = duration
                                }) {
                                    Text(duration)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 15)
                                        .glassEffect(.clear)
                                        .background(
                                            Capsule()
                                                .fill(selectedDuration == duration ? Color.darkOrange.opacity(0.9): Color.gray.opacity(0.05))
                                        )
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Start button
                    NavigationLink(destination: Task2View(goalSubject: $subject, goalDuration: $selectedDuration)) {
                        Text("Start learning")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: 182, maxHeight: 48)
                            .foregroundColor(.primary)
                            .cornerRadius(30)
                            .glassEffect(.clear.tint(Color.orange.opacity(100)))
                            .background(.clear)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    //.glassEffect(.clear.tint(Color.darkOrange.opacity(0.15)))

                    
                }
            }
        }
    }
}

#Preview {
    Task1()
}
