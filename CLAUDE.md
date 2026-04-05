# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

エンジニア向け学習知識管理 iOS アプリ。ノウハウの記録・タグ分類・クイズ復習による知識定着を目的とする。

## ビルド・テストコマンド

```bash
xcodebuild -project BrainIndex.ios.xcodeproj -scheme BrainIndex.ios -sdk iphonesimulator build
xcodebuild -project BrainIndex.ios.xcodeproj -scheme BrainIndex.ios -sdk iphonesimulator test
```

## アーキテクチャ

Clean Architecture（3層）+ MVVM を採用。

```
Presentation/ → Domain/ → Data/
```

- **Presentation/**: SwiftUI View + ViewModel（`@Observable`）（各画面ごとにサブフォルダ）
- **Domain/**: UseCase・Repository Protocol・ドメインモデル（iOS フレームワーク依存なし）
- **Data/**: SwiftData `@Model` / Repository 実装

依存ルール: Presentation は Domain のみ参照。Data は Domain の Protocol を実装。Domain は Data/Presentation に依存しない。

### 主要技術スタック
- SwiftUI（UI）
- SwiftData（ローカル DB）
- UNUserNotificationCenter（ローカル通知）
- UserDefaults（設定保存）
- NavigationStack / TabView（画面遷移）
- Swift 5.9+ / iOS 17+

### 画面構成
Home（一覧）・Edit（CRUD）・Review（ランダム表示）・Quiz（クイズ）・Settings（設定）

## 開発ドキュメント

- `requirements.md` - 要件定義
- `docs/development_flow.md` - 開発フロー
- `docs/detail/structure.md` - ディレクトリ構成
- `docs/basic/architecture.md` - アーキテクチャ設計
- `docs/basic/navigation.md` - 画面遷移設計
- `docs/basic/class_diagrams/` - 各画面の分析クラス図（Mermaid）
- `docs/detail/class_diagrams/` - 各画面の設計クラス図（Mermaid）

## ドキュメント更新
- フォルダ内のドキュメントが更新された場合、CLAUDE.md および docs 配下の関連ファイルの内容を更新する。
