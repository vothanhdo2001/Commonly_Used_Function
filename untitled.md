Giải thích các cột trong tất cả các sheet
=========================================

Tài liệu này mô tả chức năng và ý nghĩa của từng cột trong các sheet của file nộp cuối cùng **QA_Manual_Challenge_Submission_Phan_Thi_Linh (1).xlsx**. Mục đích là giúp bạn đọc hiểu rõ hơn về dữ liệu và cách sử dụng các bảng.

1. Sheet “PART 1 – Test Design”

-------------------------------

Sheet này chứa danh sách các kịch bản kiểm thử cho Phần 1. Mỗi hàng là một trường hợp thử nghiệm cụ thể, được xác định bằng `Scenario ID`, mô tả trạng thái ví bí mật (SW), số lần claim và kết quả mong đợi.

| Cột                               | Ý nghĩa                                                                                                                                                                                     |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Scenario ID**                   | Mã duy nhất để nhận diện kịch bản kiểm thử. “P1” chỉ Phần 1; phần tiếp theo mô tả SW (ví dụ `SW10`), số claim (`C1`, `C2`,…) và nhãn bổ sung như `EDGE0%` cho trường hợp biên không trừ SW. |
| **Customer**                      | Khách hàng giả định (A/B/C/X) dùng trong kịch bản. Mỗi khách hàng đại diện cho một nhóm điều kiện (VIP, SW = 0, biên 9,99, không đủ điều kiện…).                                            |
| **Group**                         | Nhóm khách hàng (ví dụ `VIP`, `NON_ELIGIBLE`). Xác định xem khách hàng có đủ điều kiện tham gia chương trình hay không.                                                                     |
| **Eligible?**                     | Đánh dấu “Yes” nếu khách hàng được tham gia, “No” nếu bị khóa.                                                                                                                              |
| **SW Before**                     | Số credit trong ví bí mật trước khi claim. Có thể là một số cụ thể (10, 9,99, 0), hoặc nhãn `SW<10`/`SW_after_from_claim1` để diễn tả giá trị biến đổi.                                     |
| **Claim #**                       | Lần claim hiện tại (1–10).                                                                                                                                                                  |
| **Claimed Count Before**          | Số lần đã claim trước đó. Kết hợp với **Claim #** để xác định trạng thái trước khi claim.                                                                                                   |
| **Boost Applies?**                | “Yes/No” cho biết có áp dụng **Newcomer Boost** hay không. Boost áp dụng ở những claim đầu.                                                                                                 |
| **Branch Expected**               | Nhánh logic dự kiến: `SW-based` khi SW ≥ ngưỡng; `System (SW < 10.0)` khi SW < ngưỡng; hoặc `Ineligible` nếu người dùng không đủ điều kiện.                                                 |
| **Tier**                          | Mức thưởng: **Big**, **Medium**, **Small** hoặc “Randomize” (khi ở nhánh System).                                                                                                           |
| **Probability**                   | Xác suất nhận được tier đó. Ví dụ 10 % cho Big, 30 % cho Medium, 60 % cho Small; 100 % với “Randomize”.                                                                                     |
| **Base Min/Max**                  | Khoảng (Min–Max) credit bị trừ từ SW theo tỉ lệ quy định của từng tier khi ở nhánh SW‑based. Ở nhánh System, đây là dải thưởng ngẫu nhiên trả trực tiếp từ hệ thống.                        |
| **Boost Min/Max**                 | Khoảng (Min–Max) credit thưởng thêm từ **Newcomer Boost**. Áp dụng khi cột **Boost Applies?** là “Yes”.                                                                                     |
| **Total Min/Max**                 | Tổng số credit nhận được (Base + Boost). Dùng để kiểm tra giá trị nhận cuối cùng nằm trong khoảng mong đợi.                                                                                 |
| **SW After Min/Max**              | Phạm vi credit còn lại trong ví bí mật sau khi claim. Ở nhánh System, SW không bị trừ nên **SW After Min/Max** thường bằng **SW Before** hoặc `SW<10`.                                      |
| **Post‑condition Checks (State)** | Mô tả những kiểm tra cần thực hiện sau khi claim: ví dụ xác thực SW bị trừ đúng, boost được cộng đúng, bản ghi thưởng có trong database hoặc claim bị từ chối.                              |

2. Sheet “PART 2 – Timeline (Support)”

--------------------------------------

Sheet này minh họa trình tự nhận thưởng của Customer A trong 30 ngày. Nó dùng để giải thích tại sao chỉ ngày 1 sử dụng nhánh SW‑based còn các ngày sau dùng nhánh System.

| Cột                | Ý nghĩa                                                                                                                            |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| **Day**            | Ngày trong chu kỳ 30 ngày. “Day 1” lặp lại cho từng tier; “Day 2..Day 30 (29 days)” gộp các ngày còn lại.                          |
| **Precondition**   | Điều kiện trước khi claim ở ngày đó: số dư SW (≥ 10 hay < 10) và số lần claim đã thực hiện.                                        |
| **Logic Used**     | Nhánh xử lý được áp dụng: `SW‑based` khi SW vẫn ≥ 10, `System` khi SW < 10.                                                        |
| **Event**          | Mô tả sự kiện xảy ra: ví dụ “Randomize + Boost (Big tier)” ở ngày 1, hoặc “Randomize only (no boost)” ở các ngày System.           |
| **Payout Range**   | Khoảng tổng credit trả cho khách hàng trong ngày đó (bao gồm Base và Boost).                                                       |
| **SW After Range** | Phạm vi SW còn lại sau khi nhận thưởng trong ngày. Ở nhánh System, SW không đổi.                                                   |
| **Notes**          | Ghi chú bổ sung, ví dụ “Nếu SW After < 10 thì ngày 2 dùng System”, hoặc “Định nghĩa SystemDays = 29” dùng cho tính toán ngân sách. |

3. Sheet “PART 2 – Budget Calc (Support)”

-----------------------------------------

Sheet này tổng hợp các tham số và công thức dùng để chứng minh cấu hình không vượt quá 50 % lợi nhuận. Nó không phải là phần chấm điểm chính nhưng hỗ trợ việc giải thích logic.

| Cột                 | Ý nghĩa                                                                                                                                                            |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Model**           | Phân loại tham số. `Common` bao gồm các biến chung (profit, cap, số ngày); `Frozen Wallet` đề cập đến các trạng thái ví bí mật và rủi ro UX khi ví bị “đóng băng”. |
| **Parameter**       | Tên tham số cụ thể, ví dụ “Profit”, “Cap (50 % profit)”, “Days”, “System days”, “Reserved SW balance”.                                                             |
| **Value**           | Giá trị của tham số, có thể là số (như 100, 50, 30) hoặc mô tả (≈ 8–9, High).                                                                                      |
| **Formula / Notes** | Công thức tính hoặc chú thích giải thích cách suy ra giá trị đó. Ví dụ “Purchase × 10 %” để tính profit, hay “Day2..Day30 = 29 days” liên kết với sheet Timeline.  |

4. Sheet “PART 2 – BO Settings”

-------------------------------

Sheet này trình bày cấu hình BackOffice đề xuất cho Phần 2 nhằm đảm bảo tổng thưởng không vượt quá 50 % lợi nhuận trong 30 ngày. Mỗi hàng tương ứng với một khu vực cấu hình, giá trị hiện tại và đề xuất.

| Cột                       | Ý nghĩa                                                                                                                                                                                                                                       |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Config Option**         | Nhóm cấu hình. `Strict prevent (hard cap enforced)` chứa các hàng chính để đảm bảo không vượt cap; `Business logic risk` nêu rủi ro; `Optional (jackpot)` đề cập đến yêu cầu jackpot.                                                         |
| **Setting Area**          | Mục hoặc khu vực cụ thể của cấu hình: mục tiêu tổng quát (Goal), giải thích quan trọng, cài đặt tier SW‑based, newcomer boost, hệ thống bonus (Day2..30), chứng minh worst‑case, kiểm tra trung bình, rủi ro Frozen Wallet, tùy chọn jackpot. |
| **Current**               | Giá trị hiện tại của hệ thống (nếu có). Ví dụ Big max 50 %, Newcomer Boost 1–3 credit, System Bonus 0,1–3,0 credit. Các hàng về mục tiêu, chứng minh và rủi ro không có giá trị hiện tại.                                                     |
| **Recommended**           | Giá trị được đề xuất để đáp ứng yêu cầu đề bài: giảm Big max xuống 30 %, thu hẹp dải Boost còn 0,8–1,2, đặt System Bonus trong phạm vi 1,0–1,57, đặt ngưỡng cap ≤ 50…                                                                         |
| **Math Proof / UX Notes** | Giải thích, chứng minh hoặc ghi chú UX. Ví dụ “Worst‑case total = Day1BaseMax(3.0) + BoostMax(1.2) + 29 × 1.57 = 49.73 => PASS” chứng minh tổng thưởng tệ nhất, hoặc “If spec remains: QA should raise UX risk (frozen SW)” cảnh báo rủi ro.  |

5. Sheet “PART 2 – Field Inputs”

--------------------------------

Sheet này liệt kê các trường (field) trong giao diện **Daily Login Settings** của hệ thống, phân loại chúng và nêu rõ giá trị hiện tại cùng giá trị đề xuất (nếu cần chỉnh sửa). Đây là bảng đối chiếu trực tiếp giữa cấu hình BO và giao diện.

| Cột                   | Ý nghĩa                                                                                                                                                                                 |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Field Name**        | Tên trường đúng như trên giao diện: ví dụ “Customer Groups”, “Language”, “Claim Reset Time”, “Number of Boosts”, “Randomize Disbursement – Big – From (%)”…                             |
| **Section**           | Phần giao diện mà trường xuất hiện: `Customer Participation`, `Daily Reset`, `Newcomer Boosts`, `Bonus Disbursement`.                                                                   |
| **Explanation**       | Giải thích ngắn gọn chức năng của trường, ví dụ “Select which customer groups are eligible”, “Minimum credit paid from the system after SW < threshold”.                                |
| **Current Value**     | Giá trị hiện tại được cài đặt trong hệ thống. Những trường không yêu cầu chỉnh sửa được ghi “No change”.                                                                                |
| **Recommended Value** | Giá trị đề xuất theo bài toán. Ví dụ Number of Boosts = 1 thay vì 3; Randomize Boost – From = 0.8; Randomize Bonus – To = 1.57. Với trường không cần thay đổi, cột này ghi “No change”. |





Giải thích từng hàng trong các sheet
====================================

Tài liệu này mô tả ý nghĩa của **mỗi hàng** trong từng sheet của file nộp cuối cùng **QA_Manual_Challenge_Submission_Phan_Thi_Linh (1).xlsx**. Mỗi hàng được giải thích ngắn gọn để bạn hiểu rõ vai trò của nó trong thiết kế test và đề xuất cấu hình.

1. Sheet “PART 1 – Test Design”

-------------------------------

Có 18 hàng (chỉ số 0 → 17) trong bảng thiết kế test. Dưới đây là giải thích cho từng hàng:

1. **Hàng 0 – P1‑SW10‑C1 (Tier Big)**: Mô phỏng lượt claim đầu tiên của khách hàng A khi ví bí mật còn 10 credit. Nhánh sử dụng là **SW‑based**; Tier Big trừ 2–5 credit (20–50 % trên 10) và cộng thêm boost 1–3 credit. Hàng này kiểm tra trường hợp khách hàng trúng Tier Big với mức thưởng cao nhất. Sau khi claim, SW còn lại trong khoảng 5–8 credit.

2. **Hàng 1 – P1‑SW10‑C1 (Tier Medium)**: Vẫn là claim đầu tiên khi SW = 10 nhưng trúng Tier Medium. Base được trừ 1–2 credit (10–20 %) và boost 1–3 credit. SW sau claim còn 8–9 credit. Hàng này kiểm tra mức thưởng trung bình.

3. **Hàng 2 – P1‑SW10‑C1 (Tier Small)**: Claim đầu tiên với Tier Small. Base trừ 0,1–1 credit (1–10 %), boost 1–3 credit. SW sau claim còn 9–9,9 credit. Hàng này đảm bảo kịch bản Tier Small hoạt động đúng.

4. **Hàng 3 – P1‑SW10‑C2‑EDGE0% (Tier Big)**: Đây là trường hợp biên của claim 1 nơi Tier Medium hoặc Tier Small có thể trừ 0 % từ SW. Hàng 3 kiểm tra Tier Big ở kịch bản này: Base trừ 2–5 credit như bình thường nhưng **không áp dụng boost** (boost = 0). Mục tiêu là xác nhận rằng hệ thống vẫn xử lý tier Big đúng khi đang ở edge case (tức khi các tier khác có thể trừ 0 %).

5. **Hàng 4 – P1‑SW10‑C2‑EDGE0% (Tier Medium)**: Edge case cho Tier Medium. Base ngẫu nhiên 0–2 credit (có thể là 0 %), không có boost. Nếu Base = 0 thì SW vẫn là 10 credit và ngày tiếp theo vẫn ở nhánh SW‑based. Hàng này đảm bảo hệ thống không trừ SW khi tỉ lệ random rơi vào 0 %.

6. **Hàng 5 – P1‑SW10‑C2‑EDGE0% (Tier Small)**: Tương tự hàng 4 nhưng cho Tier Small. Base ngẫu nhiên 0–1 credit; không có boost. Mục tiêu giống nhau: xử lý trường hợp base = 0 mà vẫn tính là đã claim.

7. **Hàng 6 – P1‑SW10‑C2‑NORMAL (Randomize)**: Mô phỏng lần claim thứ 2 của khách hàng A sau khi claim 1 làm SW tụt xuống dưới 10. Lúc này nhánh chuyển sang **System**. Base được random trong dải 0,1–3 credit, không có boost. Cột “SW Before” ghi `SW_after_from_claim1` để nhắc rằng giá trị SW phụ thuộc vào kết quả ở claim 1. Mục tiêu là kiểm tra lần claim thứ 2 ở nhánh hệ thống.

8. **Hàng 7 – P1‑SW10‑C3**: Lần claim thứ 3 (và các claim sau khi SW < 10). Nhánh vẫn là **System** với base 0,1–3 credit, không boost. Giá trị SW Before là `SW<10`. Hàng này đảm bảo logic hệ thống lặp lại đúng.

9. **Hàng 8 – P1‑SW10‑C4**: Claim thứ 4, nhánh System, giống hàng 7.

10. **Hàng 9 – P1‑SW10‑C5**: Claim thứ 5, nhánh System, giống hàng 7.

11. **Hàng 10 – P1‑SW10‑C6**: Claim thứ 6, nhánh System, giống hàng 7.

12. **Hàng 11 – P1‑SW10‑C7**: Claim thứ 7, nhánh System, giống hàng 7.

13. **Hàng 12 – P1‑SW10‑C8**: Claim thứ 8, nhánh System, giống hàng 7.

14. **Hàng 13 – P1‑SW10‑C9**: Claim thứ 9, nhánh System, giống hàng 7.

15. **Hàng 14 – P1‑SW10‑C10**: Claim thứ 10, nhánh System, giống hàng 7. Các hàng 8–14 lặp lại để đảm bảo bao phủ 10 lần claim theo yêu cầu đề bài.

16. **Hàng 15 – P1‑SW0‑C1**: Kịch bản cho **Customer B** với SW = 0. Ngay từ claim đầu, nhánh System được dùng. Base 0,1–3 credit và có boost (1–3 credit). Mục tiêu là kiểm tra logic khi người dùng có SW bằng 0.

17. **Hàng 16 – P1‑BOUNDARY‑9.99**: Kịch bản biên với SW = 9,99 (<10). Nhánh System dùng ngay cả khi SW rất gần ngưỡng. Base 0,1–3 credit, boost 1–3 credit. Hàng này đảm bảo logic chuyển nhánh chính xác tại ranh giới 10 credit.

18. **Hàng 17 – P1‑INELIGIBLE**: Kịch bản khách hàng không đủ điều kiện (**Customer X**). Các giá trị Base, Boost đều 0. Post‑condition yêu cầu xác thực claim bị từ chối và không có bản ghi thưởng. Đây là hàng duy nhất có `Tier` trống.

2. Sheet “PART 2 – Timeline (Support)”

--------------------------------------

Sheet này có 4 hàng mô tả diễn tiến qua 30 ngày:

1. **Hàng 0 – Day 1, Big tier**: SW Before = 10; dùng nhánh SW‑based. Sự kiện: randomize trong Tier Big và cộng Boost. Payout Range = 3–8 credit (2–5 base + 1–3 boost). SW After Range = 5–8 credit. Notes nhắc rằng nếu SW After < 10 thì ngày 2 chuyển sang nhánh System.

2. **Hàng 1 – Day 1, Medium tier**: Cũng ở ngày 1 nhưng trúng Tier Medium. Payout Range = 2–5 credit; SW After Range = 8–9 credit. Notes tương tự hàng 0.

3. **Hàng 2 – Day 1, Small tier**: Ngày 1 với Tier Small. Payout Range = 1,1–4 credit (0,1–1 base + 1–3 boost). SW After Range = 9–9,9 credit. Notes nhắc rằng nếu SW After == 10 (trường hợp base = 0) thì ngày 2 vẫn dùng nhánh SW‑based; còn nếu SW After < 10 thì chuyển sang System.

4. **Hàng 3 – Day 2..Day 30 (29 days)**: Tổng hợp 29 ngày còn lại. SW Before < 10 nên nhánh System được dùng. Sự kiện: randomize System bonus (0,1–3 credit), không có boost. SW After Range = No change. Notes ghi chú rằng dòng này định nghĩa `SystemDays = 29` cho bảng tính ngân sách.

3. Sheet “PART 2 – Budget Calc (Support)”

-----------------------------------------

Sheet này có 8 hàng chia thành hai nhóm:

1. **Hàng 0 – Common: Profit** – Giá trị Profit = 100. Công thức/ghi chú: `Purchase × 10 %`, nghĩa là lợi nhuận giả định bằng 10 % của doanh thu.

2. **Hàng 1 – Common: Cap (50 % profit)** – Giá trị 50. Đây là giới hạn thưởng tối đa (50 % lợi nhuận). Ghi chú: `Profit × 50 %`.

3. **Hàng 2 – Common: Days** – Số ngày trong chu kỳ Daily Bonus, giá trị 30. Ghi chú: `30‑day window`.

4. **Hàng 3 – Common: System days** – Số ngày nhánh System được dùng, giá trị 29. Ghi chú: `Day2..Day30 = 29 days (aligned with STATE sheet)`.

5. **Hàng 4 – Frozen Wallet: Reserved SW balance (displayed)** – Hiển thị số dư ví bí mật cho người dùng (10 credit). Ghi chú: `Initial SW shown to user`.

6. **Hàng 5 – Frozen Wallet: Actual SW payout Day1 (BASE)** – Mô tả khoảng base thực tế có thể bị trừ ở ngày 1: `0–5` credit (trong cấu hình gốc Big = 20–50 %). Ghi chú: `If Big tier max 50% on SW=10 => max base=5; can be 0 for Medium/Small`.

7. **Hàng 6 – Frozen Wallet: Remaining SW after switch (typical)** – Mô tả giá trị SW còn lại sau khi trừ base ngày 1 (~8–9), lúc đó SW < 10 nên nhánh chuyển sang System. Ghi chú giải thích sự “đóng băng” của ví: `If base ~1–2 then SW becomes ~8–9 and is frozen because SW<10 => System`.

8. **Hàng 7 – Frozen Wallet: QA/UX risk** – Giá trị `High`. Ghi chú nêu nguy cơ UX: người dùng thấy SW balance nhưng không thể dùng sau ngày 1, gây nhầm lẫn/khó chịu.

4. Sheet “PART 2 – BO Settings”

-------------------------------

Bảng này có 9 hàng, mỗi hàng mô tả một phần của cấu hình BackOffice:

1. **Hàng 0 – Goal**: Mục tiêu tổng quát của cấu hình “Strict prevent”: ngăn tổng thưởng vượt 50 % lợi nhuận trong 30 ngày, đồng thời giữ khả năng nhận nhiều hơn 1 credit/lần. Cột Current để trống; cột Recommended nhắc lại mục tiêu và yêu cầu có chứng minh kịch bản xấu nhất. Ghi chú mô tả cần có worst‑case proof và kiểm tra trung bình.

2. **Hàng 1 – Important clarification**: Nhắc nhở rằng SW = 10 chỉ là số dư hiển thị, không phải toàn bộ payout. Sau khi trừ base lần 1, phần còn lại sẽ “đóng băng” nếu SW < 10. Đề xuất yêu cầu làm rõ điều này trong tài liệu. Ghi chú giải thích UX risk.

3. **Hàng 2 – SW-based tiers (SW ≥ 10)**: Cài đặt tier khi SW đủ ngưỡng. Current: `Big max 50 %`. Recommended: `Reduce Big max to 30 % (Big Min remains 20 %)`, Medium và Small giữ nguyên. Ghi chú cho biết điều này giới hạn base ngày 1 ở tối đa 3 credit thay vì 5.

4. **Hàng 3 – Newcomer Boost**: Cài đặt boost tân binh. Current: `Times=1; 1–3`. Recommended: `Times=1; 0.8–1.2`. Ghi chú giải thích rằng thu hẹp khoảng boost giúp cap tổng thưởng mà vẫn tạo hứng thú cho người dùng mới.

5. **Hàng 4 – System Bonus (Day2..Day30 = 29 days)**: Cài đặt thưởng hệ thống khi SW < 10. Current: `0.1–3.0`. Recommended: `1.0–1.57`. Ghi chú nêu công thức tính trần: `(50 − 3.0 − 1.2)/29 ≈ 1.5793`, chọn 1.57 để an toàn; đáy 1.0 đảm bảo payout > 1 credit.

6. **Hàng 5 – Worst-case proof**: Không có giá trị hiện tại. Recommended: `<= 50.0`. Ghi chú cung cấp phép tính: `3.0 + 1.2 + 29 × 1.57 = 49.73 => PASS`, chứng minh kịch bản xấu nhất phù hợp giới hạn.

7. **Hàng 6 – Average sanity‑check (uniform)**: Tương tự hàng 5 nhưng kiểm tra trường hợp trung bình. Recommended: `<= 50.0`. Ghi chú cho ví dụ `41.41 => PASS` khi dùng bound cao nhất cho ngày 1 và giá trị trung bình cho 29 ngày còn lại.

8. **Hàng 7 – Frozen Wallet paradox (Business logic risk)**: Không phải tham số cấu hình mà là rủi ro UX. Cột Recommended: `Document + propose fix options`. Ghi chú đưa ra các hướng khắc phục: (A) tiêu SW đến 0 rồi chuyển, (B) hạ ngưỡng, (C) hybrid vừa trả thưởng hệ thống vừa trừ SW dần.

9. **Hàng 8 – Jackpot but still prevent (Optional)**: Hàng tùy chọn nếu muốn thêm jackpot. Current trống. Recommended: `Add per‑user remaining budget control`. Ghi chú cảnh báo rằng dải Min/Max cố định không thể vừa đạt jackpot vừa đảm bảo cap 50 %; cần cơ chế đếm ngân sách còn lại theo từng người dùng.

5. Sheet “PART 2 – Field Inputs”

--------------------------------

Sheet này có 19 hàng, tương ứng với các trường trên giao diện cấu hình “Daily Login Settings”. Mỗi hàng cho biết trường nào cần thay đổi và nên nhập gì:

1. **Customer Groups** – Chọn nhóm khách hàng đủ điều kiện: hiện có TEST, VIP, DEMO. Không yêu cầu thay đổi (tùy chọn nhóm phù hợp).

2. **Language** – Ngôn ngữ dùng để chỉnh thông điệp cho khách hàng không đủ điều kiện. Giá trị hiện tại: English. Không đổi.

3. **Ineligible message** – Thông điệp hiển thị cho khách hàng không đủ điều kiện. Hiện: “Buy more product to unlock”. Không đổi.

4. **Claim Reset Time** – Thời gian reset lượt claim mỗi ngày. Hiện: 12:00:00. Không đổi.

5. **Number of Boosts** – Số lần boost tân binh được áp dụng. Hiện: 3. Đề xuất: 1.

6. **Randomize Boost – From (credits)** – Giá trị boost tối thiểu. Hiện: 1. Đề xuất: 0.8.

7. **Randomize Boost – To (credits)** – Giá trị boost tối đa. Hiện: 3. Đề xuất: 1.2.

8. **Randomize Disbursement – Big – From (%)** – Tỉ lệ trừ SW tối thiểu cho Tier Big. Hiện: 20 %. Đề xuất: giữ nguyên 20 %.

9. **Randomize Disbursement – Big – To (%)** – Tỉ lệ trừ SW tối đa cho Tier Big. Hiện: 50 %. Đề xuất: 30 %.

10. **Winning Probability – Big (%)** – Xác suất nhận Tier Big. Hiện: 10 %. Giữ nguyên.

11. **Randomize Disbursement – Medium – From (%)** – Tỉ lệ trừ SW tối thiểu cho Tier Medium. Hiện: 10 %. Giữ nguyên.

12. **Randomize Disbursement – Medium – To (%)** – Tỉ lệ trừ SW tối đa cho Tier Medium. Hiện: 20 %. Giữ nguyên.

13. **Winning Probability – Medium (%)** – Xác suất nhận Tier Medium. Hiện: 30 %. Giữ nguyên.

14. **Randomize Disbursement – Small – From (%)** – Tỉ lệ trừ SW tối thiểu cho Tier Small. Hiện: 1 %. Giữ nguyên.

15. **Randomize Disbursement – Small – To (%)** – Tỉ lệ trừ SW tối đa cho Tier Small. Hiện: 10 %. Giữ nguyên.

16. **Winning Probability – Small (%)** – Xác suất nhận Tier Small. Hiện: 60 %. Giữ nguyên.

17. **Threshold (SW falls below)** – Ngưỡng SW để chuyển từ nhánh SW‑based sang System. Hiện: 10 credit. Giữ nguyên.

18. **Randomize Bonus – From (credits)** – Khoản thưởng hệ thống tối thiểu khi SW < ngưỡng. Hiện: 0.1. Đề xuất: 1.0.

19. **Randomize Bonus – To (credits)** – Khoản thưởng hệ thống tối đa khi SW < ngưỡng. Hiện: 3. Đề xuất: 1.57.





Giải thích cách tính các ô trong các sheet
==========================================

Tài liệu này giải thích **cách tính toán** cho từng ô hoặc nhóm ô trong các sheet của file **QA_Manual_Challenge_Submission_Phan_Thi_Linh (1).xlsx**. Thay vì lặp lại mỗi giá trị, chúng ta chỉ ra công thức và quy tắc dùng để điền dữ liệu cho từng cột và hàng.

1. Sheet “PART 1 – Test Design”

-------------------------------

### Nguyên tắc chung

1. **Nhánh SW‑based vs. System**: Nếu SW ≥ 10 tại thời điểm claim thì áp dụng nhánh **SW‑based**: hệ thống trừ một phần ví bí mật theo tỉ lệ tier và áp dụng boost. Khi SW < 10 thì dùng nhánh **System**: hệ thống không trừ ví mà trả thưởng từ dải random cố định, không áp dụng boost.

2. **Base Min/Max** (SW‑based): Tính bằng `SW × From%` và `SW × To%`. Ví dụ SW = 10: Tier Big trích từ 20 % (2 credit) đến 50 % (5 credit); Tier Medium từ 10 % (1 credit) đến 20 % (2 credit); Tier Small từ 1 % (0,1 credit) đến 10 % (1 credit).

3. **Boost Min/Max** (Newcomer): Áp dụng cho claim đầu. Boost range ban đầu 1–3 credit. Ở edge case không có boost (`Boost Min = Boost Max = 0`).

4. **Base Min/Max** (System): Khi SW < 10, Base luôn là dải random của hệ thống (0,1–3 credit). Sau khi bạn điều chỉnh cấu hình trong Phần 2, dải này sẽ trở thành 1,0–1,57 nhưng trong file test thiết kế vẫn sử dụng 0,1–3 để kiểm thử hệ thống gốc.

5. **Total Min/Max** = `Base Min + Boost Min` và `Base Max + Boost Max`.

6. **SW After Min/Max** (SW‑based) = `SW Before − Base Max` và `SW Before − Base Min`. Đối với nhánh System, SW không bị trừ nên cột này ghi lại SW hiện tại (hoặc biểu thị `SW < 10` nếu SW không còn cố định).

7. **Probability**: Quy định bởi cấu hình hệ thống: Big = 10 %, Medium = 30 %, Small = 60 %. Hàng “Randomize” dùng 100 % vì hệ thống rút số trong dải duy nhất.

### Ví dụ tính toán

* **Hàng 0 (P1‑SW10‑C1, Big)**:
  
  * `SW Before` = 10.
  
  * `Base Min = 10 × 20 % = 2` và `Base Max = 10 × 50 % = 5`.
  
  * `Boost Min = 1`, `Boost Max = 3` (theo cấu hình boost 1–3).
  
  * `Total Min = 2 + 1 = 3`, `Total Max = 5 + 3 = 8`.
  
  * `SW After Min = 10 − 5 = 5`, `SW After Max = 10 − 2 = 8`.

* **Hàng 4 (P1‑SW10‑C2‑EDGE0%, Medium)**:
  
  * Đây là edge case nên boost không áp dụng (`Boost Min = Boost Max = 0`).
  
  * `Base Min = 0` vì cấu hình cho phép random trừ 0 % ở edge case, và `Base Max = 2` (10 × 20 %).
  
  * `Total Min = 0 + 0 = 0`, `Total Max = 2 + 0 = 2`.
  
  * Nếu Base = 0 thì `SW After` vẫn 10.

* **Hàng 6 (P1‑SW10‑C2‑NORMAL)**:
  
  * Sau claim 1, giả sử SW < 10 nên dùng nhánh System.
  
  * `Base Min = 0.1`, `Base Max = 3` (dải hệ thống hiện tại).
  
  * `Boost Min = Boost Max = 0` vì không còn boost.
  
  * `Total Min = 0.1`, `Total Max = 3`.
  
  * SW không thay đổi (`SW After` ghi `SW<10`).

Các hàng còn lại sử dụng các công thức tương tự dựa trên giá trị SW, tỉ lệ tier và việc có boost hay không. Đối với các hàng P1‑SW10‑C3 → C10, base và total luôn dùng dải hệ thống (0,1–3), và SW không đổi.

2. Sheet “PART 2 – Timeline (Support)”

--------------------------------------

Mỗi ô trong sheet này được tính từ các giá trị đã xác định ở sheet Test Design:

1. **Payout Range** = `Base Min/Max + Boost Min/Max` từ hàng tương ứng ở Test Design.

2. **SW After Range** = `SW Before − Base Max/Min` đối với ngày 1; ở các ngày System, SW không đổi.

3. Các ghi chú trong cột **Notes** được suy ra từ logic: nếu sau ngày 1 SW < 10 thì từ ngày 2 trở đi sử dụng hệ thống (29 ngày), vì vậy `SystemDays = 29` được dùng trong bảng Budget Calc.

Ví dụ:

* **Day 1, Big tier**: Base 2–5 + Boost 1–3 → Payout 3–8. SW After Range = 5–8.

* **Day 2..30**: dùng dải hệ thống 0,1–3 (hoặc 1,0–1,57 sau khi điều chỉnh), nên Payout Range là dải đó; SW After không đổi.
3. Sheet “PART 2 – Budget Calc (Support)”

-----------------------------------------

Các giá trị trong sheet này được suy ra từ mô hình kinh doanh:

* **Profit** = `Purchase × 10 %`. Trong ví dụ, nếu Purchase = 1000 credit, Profit = 100.

* **Cap (50 % profit)** = `Profit × 50 %`. Với Profit = 100, Cap = 50. Đây là giới hạn tổng thưởng.

* **Days** = 30 (số ngày trong chu kỳ bonus).

* **System days** = 29 (30 ngày trừ 1 ngày SW‑based).

* **Reserved SW balance** = 10 (hiển thị SW ban đầu).

* **Actual SW payout Day1 (BASE)** = dải base có thể trừ ở ngày 1 (0–5), xuất phát từ cấu hình Big max = 50 %.

* **Remaining SW after switch (typical)** ~ 8–9: giả sử base trừ 1–2 credit, SW còn lại 8–9 và bị “đóng băng”.

* **QA/UX risk** = High: đánh giá định tính, không phải phép tính.
4. Sheet “PART 2 – BO Settings”

-------------------------------

Trong sheet này, các giá trị không phải kết quả của phép tính mà là đề xuất điều chỉnh:

* **Big tier max**: giảm từ 50 % xuống 30 %. Tính bằng `SW × 30 %` → 10 × 0.3 = 3 credit tối đa ở ngày 1.

* **Newcomer Boost range**: thu hẹp từ 1–3 xuống 0,8–1,2 để tổng thưởng không quá cao. Phần trăm cụ thể do người thiết kế chọn dựa trên mục tiêu cap.

* **System bonus range**: dải 1,0–1,57 được tính từ công thức `SystemMax ≤ (Cap − Day1BaseMax − BoostMax) / (Số ngày System)`. Với Cap = 50, Day1BaseMax = 3, BoostMax = 1,2, Số ngày System = 29 → SystemMax ≤ (50−3−1,2)/29 ≈ 1,5793. Chọn 1,57 để an toàn.

* **Worst‑case total**: tổng = BaseMax + BoostMax + SystemMax × 29. Áp dụng giá trị đề xuất: 3,0 + 1,2 + 29 × 1,57 = 49,73 ≤ 50.

* **Average check**: giả sử người dùng không luôn trúng max, ta lấy giá trị trung bình (ví dụ 1,27) cho System bonus → tổng khoảng 41,41 ≤ 50.
5. Sheet “PART 2 – Field Inputs”

--------------------------------

Các ô trong sheet này chủ yếu là giá trị hiện tại và đề xuất. Không có công thức tính, nhưng mối liên hệ với logic có thể được mô tả:

* **Number of Boosts**: đề xuất giảm từ 3 xuống 1 để tránh cộng quá nhiều credit trong ngày 1.

* **Randomize Boost – From/To**: đề xuất điều chỉnh theo công thức tính tổng thưởng tối đa cho boost: `(Cap − BaseMax − SystemMax × 29) / 1` → ~1,2, và chọn đáy 0,8 để vẫn có biến thiên.

* **Randomize Disbursement – Big – From/To**: “From” giữ nguyên (20 %), “To” giảm xuống 30 % để BaseMax ngày 1 bằng 3.

* Các trường “Winning Probability” giữ nguyên vì xác suất không ảnh hưởng tới cap trong bài toán.

* **Randomize Bonus – From/To**: được tính như ở phần BO Settings (từ 1,0 đến 1,57).

Phần lớn các ô còn lại (Customer Groups, Language, Claim Reset Time…) chỉ là cài đặt giao diện nên không có phép tính kèm theo.


