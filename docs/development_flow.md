# BrainIndex 開発フロー

## 全体の流れ

```
要件定義 → 基本設計 → 詳細設計 → 実装 → テスト
```

---

## Phase 1: 要件定義（完了）

**目的：** 何を作るかを確定する

| ドキュメント | ファイル名 | 状態 |
|---|---|---|
| 要件定義書 | `requirements.md` | ✅ 完成 |

---

## Phase 2: 基本設計

**目的：** システム全体の構造・方針を決める

| ドキュメント | ファイル名 | 内容 |
|---|---|---|
| アーキテクチャ設計書 | `docs/basic/architecture.md` | レイヤー構成（UI/Domain/Data）、採用パターン（MVVM）、主要ライブラリ選定理由 |
| 画面遷移設計書 | `docs/basic/navigation.md` | 全画面の遷移フロー、TabView構成、画面間のデータ受け渡し方針 |
| DB設計書 | `docs/basic/database.md` | SwiftDataモデル定義、ER図、マイグレーション方針 |
| 通知設計書 | `docs/basic/notification.md` | ローカル通知のトリガー条件、UNUserNotificationCenter利用方針 |

**分析クラス図（画面ごと）：**

| ファイル | 対象画面 |
|---|---|
| `docs/basic/class_diagrams/home.md` | ホーム画面 |
| `docs/basic/class_diagrams/edit.md` | 編集画面 |
| `docs/basic/class_diagrams/review.md` | 復習画面 |
| `docs/basic/class_diagrams/quiz.md` | クイズ画面 |
| `docs/basic/class_diagrams/settings.md` | 設定画面 |

**分析シーケンス図（画面ごと）：**

| ファイル | 対象画面 |
|---|---|
| `docs/basic/sequence_diagrams/home.md` | ホーム画面 |
| `docs/basic/sequence_diagrams/edit.md` | 編集画面 |
| `docs/basic/sequence_diagrams/review.md` | 復習画面 |
| `docs/basic/sequence_diagrams/quiz.md` | クイズ画面 |
| `docs/basic/sequence_diagrams/settings.md` | 設定画面 |

**主な作業内容：**
- MVVM + Repository パターンの採用確定
- SwiftData、NavigationStack/TabView、UNUserNotificationCenter の導入確定
- 5画面の遷移フロー確定
- Swift Package Manager での依存関係追加

---

## Phase 3: 詳細設計

**目的：** 実装に必要な詳細を定義する

| ドキュメント | ファイル名 | 内容 |
|---|---|---|
| ディレクトリ構成書 | `docs/detail/structure.md` | パッケージ構成、ファイル配置ルール |

**設計クラス図（画面ごと）：**

| ファイル | 対象画面 |
|---|---|
| `docs/detail/class_diagrams/home.md` | ホーム画面 |
| `docs/detail/class_diagrams/edit.md` | 編集画面 |
| `docs/detail/class_diagrams/review.md` | 復習画面 |
| `docs/detail/class_diagrams/quiz.md` | クイズ画面 |
| `docs/detail/class_diagrams/settings.md` | 設定画面 |

**設計シーケンス図（画面ごと）：**

| ファイル | 対象画面 |
|---|---|
| `docs/detail/sequence_diagrams/home.md` | ホーム画面 |
| `docs/detail/sequence_diagrams/edit.md` | 編集画面 |
| `docs/detail/sequence_diagrams/review.md` | 復習画面 |
| `docs/detail/sequence_diagrams/quiz.md` | クイズ画面 |
| `docs/detail/sequence_diagrams/settings.md` | 設定画面 |

**主な作業内容：**
- 各SwiftUI ViewのProps/State定義
- SwiftData @Model クラスの詳細設計
- ViewModelの @Published 設計
- EnvironmentObject によるDI構成設計

---

## Phase 4: 実装

**目的：** 設計書をもとにコードを書く（マイルストーン単位で進める）

| マイルストーン | 実装内容 |
|---|---|
| M1: データ層 | SwiftData セットアップ、Model / Repository 実装 |
| M2: ホーム・編集画面 | ノウハウ CRUD、Markdown入力、タグ付け |
| M3: 復習画面 | ランダム表示、ナビゲーション |
| M4: クイズ画面 | 問題生成ロジック、回答フィードバック |
| M5: 設定・通知 | UNUserNotificationCenter、ローカル通知、継続カウント |
| M6: 検索・お気に入り | 全文検索、フィルタリング |

---

## Phase 5: テスト

**目的：** 品質を担保する

**テスト種別：**
- 単体テスト：XCTest（ViewModel, Repository, UseCase）
- DBテスト：SwiftData in-memory 設定によるテスト
- UIテスト：XCUITest（各画面）

**ユニットテストコード配置：**

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

---

## ドキュメント配置

```
docs/
├── development_flow.md
├── basic/
│   ├── architecture.md
│   ├── navigation.md
│   ├── database.md
│   ├── notification.md
│   ├── class_diagrams/
│   │   ├── home.md
│   │   ├── edit.md
│   │   ├── review.md
│   │   ├── quiz.md
│   │   └── settings.md
│   └── sequence_diagrams/
│       ├── home.md
│       ├── edit.md
│       ├── review.md
│       ├── quiz.md
│       └── settings.md
└── detail/
    ├── structure.md
    ├── class_diagrams/
    │   ├── home.md
    │   ├── edit.md
    │   ├── review.md
    │   ├── quiz.md
    │   └── settings.md
    └── sequence_diagrams/
        ├── home.md
        ├── edit.md
        ├── review.md
        ├── quiz.md
        └── settings.md
```
