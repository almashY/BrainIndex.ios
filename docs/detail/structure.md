# ディレクトリ構成書

BrainIndex iOS アプリのフォルダ構成とファイル配置ルールを定義する。
クリーンアーキテクチャ（Presentation / Domain / Data）に従って分離する。

---

## フォルダ構成

```
BrainIndex.ios/
├── Data/
│   ├── Local/
│   │   ├── Model/
│   │   │   └── KnowhowModel.swift
│   │   └── Database/
│   │       └── AppDatabase.swift
│   └── Repository/
│       ├── KnowhowRepositoryImpl.swift
│       └── SettingsRepositoryImpl.swift
├── Domain/
│   ├── Model/
│   │   ├── Knowhow.swift
│   │   └── QuizQuestion.swift
│   ├── Repository/
│   │   ├── KnowhowRepository.swift
│   │   └── SettingsRepository.swift
│   └── UseCase/
│       ├── GetKnowhowListUseCase.swift
│       ├── GetKnowhowByIdUseCase.swift
│       ├── SaveKnowhowUseCase.swift
│       ├── DeleteKnowhowUseCase.swift
│       ├── GetRandomKnowhowUseCase.swift
│       ├── ToggleFavoriteUseCase.swift
│       ├── GenerateQuizUseCase.swift
│       ├── GetTodayCountUseCase.swift
│       └── UpdateNotificationSettingsUseCase.swift
└── Presentation/
    ├── Home/
    │   ├── HomeView.swift
    │   └── HomeViewModel.swift
    ├── Edit/
    │   ├── EditView.swift
    │   └── EditViewModel.swift
    ├── Review/
    │   ├── ReviewView.swift
    │   └── ReviewViewModel.swift
    ├── Quiz/
    │   ├── QuizView.swift
    │   └── QuizViewModel.swift
    └── Settings/
        ├── SettingsView.swift
        └── SettingsViewModel.swift
```

---

## ファイル配置ルール

### Data層

| クラス種別 | 配置フォルダ | 命名規則 |
|---|---|---|
| SwiftData @Model | `Data/Local/Model/` | `XxxModel.swift` |
| ModelContainer設定 | `Data/Local/Database/` | `AppDatabase.swift` |
| Repository実装 | `Data/Repository/` | `XxxRepositoryImpl.swift` |

### Domain層

| クラス種別 | 配置フォルダ | 命名規則 |
|---|---|---|
| ドメインモデル | `Domain/Model/` | `Xxx.swift` |
| Repository Protocol | `Domain/Repository/` | `XxxRepository.swift` |
| UseCase | `Domain/UseCase/` | `XxxUseCase.swift` |

### Presentation層

| クラス種別 | 配置フォルダ | 命名規則 |
|---|---|---|
| SwiftUI View | `Presentation/{Screen}/` | `XxxView.swift` |
| ViewModel | `Presentation/{Screen}/` | `XxxViewModel.swift` |

---

## 依存関係ルール

- `Presentation` → `Domain` のみ参照可（`Data` は直接参照禁止）
- `Domain` → 他レイヤーの参照禁止（純粋なビジネスロジック）
- `Data` → `Domain` の Protocol を実装
- DI はコンストラクタインジェクション + EnvironmentObject で管理

---

## テストコード配置

```
BrainIndex.iosTests/
├── ViewModel/
│   ├── HomeViewModelTests.swift
│   ├── EditViewModelTests.swift
│   ├── ReviewViewModelTests.swift
│   ├── QuizViewModelTests.swift
│   └── SettingsViewModelTests.swift
├── UseCase/
│   ├── GetKnowhowListUseCaseTests.swift
│   ├── SaveKnowhowUseCaseTests.swift
│   ├── GetRandomKnowhowUseCaseTests.swift
│   ├── GenerateQuizUseCaseTests.swift
│   └── GetTodayCountUseCaseTests.swift
└── Repository/
    └── KnowhowRepositoryTests.swift
```
