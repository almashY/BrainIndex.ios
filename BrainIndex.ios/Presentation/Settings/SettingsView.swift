import SwiftUI

struct SettingsView: View {
    @Environment(SettingsViewModel.self) private var viewModel
    @Environment(DIContainer.self) private var di

    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            Form {
                Section("学習状況") {
                    LabeledContent("今日の登録数") {
                        Text("\(viewModel.todayCount) 件")
                            .foregroundStyle(.secondary)
                    }
                    LabeledContent("継続日数") {
                        Text("\(viewModel.streakDays) 日")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("通知設定") {
                    Toggle("毎日リマインダー", isOn: Binding(
                        get: { viewModel.isNotificationEnabled },
                        set: { viewModel.onNotificationEnabledChange(enabled: $0) }
                    ))

                    if viewModel.isNotificationEnabled {
                        DatePicker(
                            "通知時刻",
                            selection: Binding(
                                get: { viewModel.notificationTime },
                                set: { viewModel.onNotificationTimeChange(time: $0) }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                    }
                }
            }
            .navigationTitle("設定")
            .onAppear {
                viewModel.loadSettings(
                    settingsRepository: di.settingsRepo,
                    knowhowRepository: di.knowhowRepo
                )
            }
        }
    }
}
