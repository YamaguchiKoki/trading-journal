---
name: register-indicators
description: "米国の主要経済指標(FOMC・ISM・雇用統計・CPI・PPI・PMI・小売売上高・GDP・PCE)の発表日時を公式スケジュールで調べ、Google カレンダー(Notion Calendar に表示される)に登録し、指標/YYYY-MM.md にまとめるスキル。「10月分の指標を登録して」「来月の経済指標をカレンダーに」「指標カレンダー更新」などで発動する。経済指標、指標、FOMC、雇用統計、CPI、カレンダー登録といったキーワードでも発動すること。"
---

# register-indicators

対象月の米国経済指標の発表日時を公式ソースで確認し、Google カレンダーの「米経済指標」カレンダーに登録する。Notion Calendar は Google カレンダーを表示しているので、そこにも出る。

## 対象指標と公式ソース

時刻は米国東部時間(ET)。カレンダーには `timeZone: America/New_York` で登録するので、日本時間への変換と夏時間・冬時間の切り替えは Google カレンダーに任せる。

| 予定名 | 発表日の目安 | 時刻(ET) | 公式ソース |
|---|---|---|---|
| FOMC | 年8回、会合最終日 | 14:00 | https://www.federalreserve.gov/monetarypolicy/fomccalendars.htm |
| ISM製造業 | 第1営業日 | 10:00 | https://www.ismworld.org/supply-management-news-and-reports/reports/rob-report-calendar/ |
| ISM非製造業 | 第3営業日 | 10:00 | 同上 |
| 雇用統計 | 原則 第1金曜 | 08:30 | https://www.bls.gov/schedule/ |
| CPI | 中旬 | 08:30 | https://www.bls.gov/schedule/ |
| PPI | 中旬 | 08:30 | https://www.bls.gov/schedule/ |
| PMI速報 | 下旬 | 09:45 | https://www.pmi.spglobal.com/Public/Release/ReleaseDates |
| 小売売上高 | 中旬 | 08:30 | https://www.census.gov/retail/release_schedule.html |
| GDP(速報/改定/確報) | 月末ごろ | 08:30 | https://www.bea.gov/news/schedule |
| PCEデフレーター | 月末ごろ | 08:30 | https://www.bea.gov/news/schedule |

- PMI は相場が動きやすい速報値だけを登録する。確報値は登録しない
- GDP は速報値・改定値・確報値のどれなのかを予定名に入れる(例: `GDP速報(7-9月期)`)

## 処理手順

1. 対象月を決める(例:「10月分」→ `2026-10`)。指定がなければ翌月

2. 上の公式ソースを WebFetch / WebSearch で確認し、対象月の発表日を全指標ぶん確定させる
   - 「発表日の目安」で日付を推測して登録しない。公式ソースで日付を確認できなかった指標は、登録せずにユーザーに報告する
   - 政府機関の閉鎖などで予定が変わっていないかも確認する

3. `list_calendars` で「米経済指標」カレンダーの ID を取得する
   - 見つからなければ、Google カレンダーで「米経済指標」という名前のカレンダーを作るようユーザーに依頼して終了する(MCP からはカレンダーを作成できない)

4. `list_events` で、そのカレンダーにある対象月の既存予定を取得する。同じ日付・同じ予定名のものは登録済みとして飛ばす

5. 登録内容を一覧にしてユーザーに確認する(日本時間も併記する)

6. OK が出たら `create_event` で1件ずつ登録する
   - `calendarId`: 手順3の ID
   - `summary`: `🇺🇸 <予定名>`(例: `🇺🇸 雇用統計`)
   - `startTime`: 発表時刻、`endTime`: 15分後
   - `timeZone`: `America/New_York`
   - `availability`: `AVAILABILITY_FREE`
   - `description`: 確認した公式ソースの URL

7. `指標/YYYY-MM.md` を作成(既にあれば上書き)して、日付順の表にまとめる:
   ```markdown
   # 2026-10 米経済指標

   | 日付 | 日本時間 | 指標 |
   |---|---|---|
   | 10/2(金) | 21:30 | 雇用統計 |
   ```
   日本時間は夏時間(3月第2日曜〜11月第1日曜)なら ET+13時間、冬時間なら ET+14時間で計算する

8. 登録した件数・飛ばした件数・確認できなかった指標を報告する

## 注意点

- 登録前に必ずユーザーの確認を取る
- 日本時間で深夜0〜8時になる発表(FOMC など)は、エントリーしない時間帯なので表の末尾に「※エントリー対象外」と書く
