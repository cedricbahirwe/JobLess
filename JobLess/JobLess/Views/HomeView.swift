//
//  HomeView.swift
//  JobLess
//
//  Created by Cédric Bahirwe on 07/09/2022.
//

import SwiftUI

struct HomeView: View {
    @State private var jobs: [Job] = [.customerService]
    @StateObject private var submitter = Submitter()
    @State private var selectedJob: Job?

    @State private var colorScheme: ColorScheme? = nil
    @State private var selectedJobTag: JobTag = JobTag.all
    @State private var showMenu: Bool = false
    @State private var showSearch: Bool = false
    private let screenSize = UIScreen.main.bounds.size

    var body: some View {
        ZStack {
            VStack {
                NavigationBarView(
                    onMenu: {
                        withAnimation {
                            showMenu.toggle()
                        }
                    },
                    onSearch: {
                        showSearch.toggle()
                    },
                    onFilter: {
                    })
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Find a job for you\n\(Text("in Africa 🌍").bold())")
                        .font(.system(.title, design: .rounded))
                        .layoutPriority(2)
                    
                    jobsAdvertsView
                    
                    JobTagsView(JobTag.allCases, selection: $selectedJobTag)
                    
                    recentPostedJobs
                }
            }
            .padding(.horizontal)
            .rotation3DEffect(.degrees(showMenu ? 45 : 0),
                              axis: (0,3,0),
                              anchor: .leading,
                              anchorZ: 1,
                              perspective: 1)
            .offset(x: showMenu ? screenSize.width*0.8 : 0)
            .disabled(showMenu)
            .background(Color(.secondarySystemBackground), ignoresSafeAreaEdges: .all)

            JobSearchView(isPresented: $showSearch)
                .scaleEffect(showSearch ? 1 : 0.1 , anchor: .topTrailing)
                .cornerRadius(showSearch ?  0 : CGFloat.infinity)
                .animation(.easeInOut(duration: 0.3), value: showSearch)
                .offset(x: showSearch ? 0 : -80)
                .allowsHitTesting(showSearch)

            MainMenuView(isPresented: $showMenu, screenSize: screenSize)
        }
        .sheet(item: $selectedJob,
               content: JobDetailView.init)
        .preferredColorScheme(.dark)
        .onAppear() {
            submitter.loadJobs { submitter.generalJobs = $0.map({ $0.toDomainModel() }) }
        } 
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

private extension HomeView {
    var jobsAdvertsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(submitter.generalJobs) { job in
                    JobAdvertView(job)
                        .padding(8)
                        .background(.ultraThickMaterial)
                        .cornerRadius(10)
                }
            }
        }
    }
    var recentPostedJobs: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Section {
                ForEach(submitter.generalJobs) { job in
                    JobRowView(job)
                        .onTapGesture {
                            selectedJob = job
                        }
                }
            } header: {
                Text("Recently Posted")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
