# Email Báo Cáo Tiến Độ Định Kỳ Đồ Án 2 - Giai Đoạn 5

> **Trạng thái:** Đã hoàn thiện & kiểm thử 100% (Build Java 25 & Vitest PASSED, 71/71 Tests, 29/29 UAT Screenshots)  
> **Tài liệu đính kèm:** `BaoCaoDinhKy_GiaiDoan5_TaskPilot_MSTeams_Collab_AdaptiveAI.docx` (2.2 MB)

---

**Subject:** [SE122.R11] Báo cáo tiến độ Đồ án 2 định kỳ Giai đoạn 5 (Cộng tác MS Teams, Bản ghi Cuộc họp, Làm mờ nền, Lịch biểu & Thích ứng trọng số AI) - Nhóm Phan Lê Minh & Đặng Phú Thiện

**To:** `yentth@uit.edu.vn`

**CC:** `23521476@gm.uit.edu.vn`

**Đính kèm:** `BaoCaoDinhKy_GiaiDoan5_TaskPilot_MSTeams_Collab_AdaptiveAI.docx`

---

Kính gửi Cô Trần Thị Hồng Yến,

Chúng em là sinh viên thực hiện đề tài **"Xây dựng hệ thống Quản lý dự án thông minh tích hợp AI Agent (TaskPilot)"**, lớp SE122.R11 (Đồ án 2):
1. **Phan Lê Minh** — MSSV: 23520952
2. **Đặng Phú Thiện** — MSSV: 23521476

Nhóm chúng em xin phép gửi Cô báo cáo tiến độ định kỳ 2 tuần của **Giai đoạn 5 (Kỳ W43–W44)**. Trong giai đoạn này, nhóm đã tập trung giải quyết trọn vẹn các mục tiêu lớn: **Tái cấu trúc Không gian Cộng tác theo chuẩn Microsoft Teams**, **Tích hợp Bản ghi Cuộc họp, Tính năng Làm mờ nền & Lịch biểu Điều phối**, và **Xây dựng Nền tảng Thích ứng trọng số AI (Adaptive Weight Learning & Heuristic Correctness)**.

Báo cáo chi tiết định dạng Word chuẩn UIT đã được đính kèm trong thư (`BaoCaoDinhKy_GiaiDoan5_TaskPilot_MSTeams_Collab_AdaptiveAI.docx` dung lượng 2.2 MB, tích hợp đầy đủ 14 hình ảnh minh chứng thực nghiệm). Dưới đây là tóm tắt các kết quả kỹ thuật nổi bật nhóm đã đạt được:

---

### 1. Tái cấu trúc Không gian Cộng tác (Collaboration Hub) chuẩn Microsoft Teams
Nhằm khắc phục triệt để tình trạng phân mảnh giao diện và cấu trúc thẻ lồng nhau nhiều tầng (Russian-doll nesting), nhóm đã tái thiết kế toàn bộ phân hệ cộng tác:
- **Thống nhất 3 Trụ Cột (3 Pillars Unification):** Tích hợp cả 3 phân hệ cốt lõi gồm **Trò chuyện** (Chat STOMP), **Tài liệu** (Project Files), và **Cuộc họp & Bản ghi** (LiveKit Cloud WebRTC SFU) trong cùng một khung nhìn duy nhất mà không phải tải lại trang.
- **Tạo nhóm trò chuyện tùy biến (Custom Standalone Groups):** Cho phép người dùng chủ động tạo các nhóm trao đổi tự do (không bị bó buộc trong phạm vi `projectId`), hỗ trợ tìm kiếm và chọn nhiều đồng nghiệp tham gia (`CreateGroupChatModal`).
- **Thao tác tức thời (Instant Quick Actions):** Bổ sung nút **"Họp ngay"** (Meet Now) để mở nhanh phòng họp truyền hình trực tuyến với LiveKit SFU, nút **"Lên lịch"** (Calendar), và nút **"Thành viên"** (Members).
- **Tuân thủ tiêu chuẩn Anti-AI UI:** Xóa bỏ toàn bộ gradient generic tím/lam thiếu tương phản, bảo đảm chỉ số WCAG AA trên cả 3 chủ đề (**Light**, **Dark**, và **Glassmorphism**) và tích hợp ngăn kéo điều hướng di động (**Mobile Drawer**) mượt mà trên màn hình nhỏ (375x812).

---

### 2. Quản lý Bản ghi Cuộc họp, Làm Mờ Nền Video & Lịch biểu Điều phối
- **Ghi hình Cuộc họp & Đồng bộ Tự động (Meeting Recording & Project Files Integration):** Hỗ trợ ghi hình phiên họp WebRTC SFU đa điểm kèm tính năng chia sẻ màn hình Live HD. Sau khi kết thúc, video bản ghi (.webm) được hệ thống tự động lưu trữ và phân loại vào mục Tài liệu dự án (`Project Files`).
- **Trình phát Video Bản ghi Tích hợp (Playback Modal):** Người dùng có thể xem lại trực tiếp nội dung cuộc họp hoặc tải tệp tin `.webm` về máy cục bộ ngay trên bảng điều khiển lịch sử họp (`Meeting History`).
- **Làm mờ nền Video Call thời gian thực (Real-time Background Blur / Virtual Background):** Tích hợp công nghệ xử lý Canvas 2D phần cứng với 3 cấp độ tùy chọn gồm Mờ nhẹ (8px - tự nhiên), Chuẩn (16px - khuyến nghị cho văn phòng) và Mờ sâu (24px - riêng tư tối đa). Giao diện nút bấm thanh lịch, hiển thị huy hiệu trạng thái mờ nền trực quan trên tile người dùng cục bộ, hỗ trợ song song cả phòng họp LiveKit SFU Cloud và camera fallback.
- **Lịch biểu & Điều phối cuộc họp chuẩn Teams / Outlook (Calendar Hub):** Cung cấp 2 chế độ hiển thị linh hoạt gồm **Lịch trình** (Agenda / Daily Schedule) và **Lưới tháng** (Month Grid View), hiển thị trực quan các phiên họp, hạn chót công việc và tích hợp nút kích hoạt nhanh "Họp ngay" (Meet Now).

---

### 3. Nền tảng Thích ứng trọng số AI (Adaptive Weight Learning & Heuristic Correctness)
Nhóm đã hoàn thiện toàn diện lộ trình nghiên cứu từ Phase 0 đến Phase 2F:
- **Phase 0 & Phase 1 — Đóng băng bất biến an toàn & Hợp đồng Allowlisted:**
  - Thiết lập bộ kiểm thử đặc tính hóa Heuristic Scoring (`5 test classes, 28 tests`) khóa chặt các ngưỡng an toàn.
  - Chuẩn hóa Hợp đồng Hiển thị Đề xuất Phân công (`RecommendationCard.tsx` phiên bản `allowlisted-view-v1`), ngăn ngừa triệt để việc rò rỉ trọng số nội bộ và công thức thô ra phía máy khách.
- **Phase 2A & 2B — Lưu vết Snapshot & Thu thập sự kiện quyết định:**
  - Lưu trữ ảnh chụp phân công (`recommendation_snapshots`) liên kết khóa ngoại với nhiệm vụ và dự án.
  - Ghi nhận đầy đủ tương tác thực tế của Quản lý dự án (`pm_decision_events`: ACCEPT, REJECT, OVERRIDE) kèm lý do ghi đè, làm dữ liệu nền tảng (ground truth) phục vụ huấn luyện máy học.
- **Phase 2C — Hợp đồng đo lường Khối lượng công việc thực tế:**
  - Chuẩn hóa trường dữ liệu đo lường khối lượng công việc là số lượng tác vụ đang mở (`ACTIVE_TASK_COUNT`), loại bỏ hoàn toàn các khái niệm mơ hồ như "công suất %".
- **Phase 2E & 2F — Bộ tạo tập dữ liệu & Động cơ Đề xuất Trọng số Thích ứng:**
  - Xây dựng `AdaptiveDatasetBuilder` tự động lọc dữ liệu, kiểm tra tính toàn vẹn và tạo báo cáo chất lượng.
  - Triển khai `AdaptiveWeightProposalEngine` tối ưu hóa sai số và sinh đề xuất điều chỉnh trọng số thích ứng ngoại tuyến cho chế độ **BALANCED** (đã áp dụng Flyway Migration V40).

---

### 4. Chỉ số Kiểm thử & Đảm bảo Chất lượng (Quality Gates)
- **Backend (Spring Boot 4.1.0 & Java 25 LTS):** Toàn bộ 7/7 modules Maven biên dịch và chạy kiểm thử thành công tuyệt đối (`BUILD SUCCESS` trên toàn bộ reactor).
- **Frontend (React 19 & TypeScript):** 
  - Vượt qua 14/14 Vitest test suites (71 tests pass).
  - Đạt tỷ lệ tương đồng đa ngôn ngữ i18n tuyệt đối 100% (**763/763 keys parity** giữa `vi.json` và `en.json`).
  - Production bundle biên dịch sạch sẽ (`tsc -b && vite build` hoàn thành trong 24.32s).
- **Nghiệm thu thực tế (UAT Screenshots):** Đã bổ sung đầy đủ bộ ảnh minh chứng thực nghiệm gồm 14 hình ảnh chuyên sâu trong báo cáo (29 hình ảnh toàn hệ thống) ghi nhận đầy đủ luồng họp, chia sẻ màn hình, bản ghi và lịch biểu.

---

### 5. Hình ảnh Minh chứng Nghiệm thu Tiêu biểu (Trích từ Báo cáo đính kèm)

1. **Hình 1 — Không gian Cộng tác hợp nhất chuẩn Microsoft Teams:**  
   Giao diện kết hợp giữa thanh điều hướng Kênh dự án & Nhóm trò chuyện bên trái, thanh tiêu đề 3 Trụ Cột (Trò chuyện / Tài liệu / Cuộc họp) và nút Họp ngay.  
   *(Tệp minh chứng: `report/src/assets/collab/18_ms_teams_unified_chat_desktop.png`)*

2. **Hình 2 — Hộp thoại Tạo Nhóm Trò Chuyện Tùy Biến (Custom Group Chat):**  
   Giao diện hỗ trợ đặt tên nhóm, nhập mô tả chuyên sâu và chọn nhanh đồng nghiệp từ tổ chức mà không yêu cầu phụ thuộc vào một dự án cụ thể.  
   *(Tệp minh chứng: `report/src/assets/collab/19_ms_teams_create_group_chat_modal.png`)*

3. **Hình 3 — Luồng Hội thoại Nhóm Tùy Biến Hoạt Động Độc Lập:**  
   Hiển thị thông báo Toast xác nhận tạo nhóm thành công, luồng trao đổi trực tiếp và trạng thái kết nối STOMP thời gian thực.  
   *(Tệp minh chứng: `report/src/assets/collab/20_ms_teams_custom_group_conversation.png`)*

4. **Hình 4 — Chuyển đổi 3 Trụ Cột (Tab Tài liệu):**  
   Người dùng quản lý tệp tin dự án ngay bên trong giao diện cộng tác mà không bị gián đoạn bối cảnh làm việc.  
   *(Tệp minh chứng: `report/src/assets/collab/21_ms_teams_3_pillars_tabs.png`)*

5. **Hình 5 — Tự động Lưu trữ Bản ghi Cuộc họp trong Danh mục Tài liệu dự án (Project Files):**  
   Hệ thống tự động lưu trữ các tệp tin ghi hình cuộc họp (.webm) kèm dung lượng, người tạo và ngày ghi.  
   *(Tệp minh chứng: `report/src/assets/collab/24_project_files_meeting_recordings.png`)*

6. **Hình 6 — Thực nghiệm Phòng họp Trực tuyến LiveKit SFU với Chia sẻ Màn hình Live HD & Ghi hình Đa Điểm:**  
   Hình ảnh kiểm thử thực tế cuộc họp giữa hai tác giả đề tài với tính năng chia sẻ màn hình trực tiếp và chỉ báo ghi hình REC.  
   *(Tệp minh chứng: `report/src/assets/collab/25_project_meeting_live_screenshare_recording.png`)*

7. **Hình 7 — Hộp thoại Phát lại Video Bản ghi Cuộc họp (Playback Modal) & Tải tệp .webm:**  
   Giao diện phát lại video bản ghi cuộc họp trực tiếp trên TaskPilot kèm nút tải xuống thuận tiện.  
   *(Tệp minh chứng: `report/src/assets/collab/26_project_meeting_playback_download_modal.png`)*

8. **Hình 8 — Bảng điều khiển Lịch sử Cuộc họp & Truy cập Bản ghi Nhanh (Watch Recording):**  
   Quản lý danh sách các cuộc họp đã kết thúc theo thẻ trực quan và xem lại bản ghi với một cú nhấp chuột.  
   *(Tệp minh chứng: `report/src/assets/collab/27_project_meetings_history_recordings_list.png`)*

9. **Hình 9 — Phân hệ Lịch biểu & Điều phối cuộc họp — Chế độ Lịch trình (Agenda View):**  
   Hiển thị danh sách lịch họp trong ngày, tổng quan lịch tháng và nút tác vụ nhanh "Họp ngay" (Meet Now).  
   *(Tệp minh chứng: `report/src/assets/collab/28_calendar_schedule_coordination_agenda.png`)*

10. **Hình 10 — Phân hệ Lịch biểu & Điều phối cuộc họp — Chế độ Lưới Tháng (Month View Grid):**  
    Góc nhìn toàn cảnh phân bổ các phiên họp và hạn chót tác vụ trên toàn bộ tháng.  
    *(Tệp minh chứng: `report/src/assets/collab/29_calendar_schedule_coordination_month_grid.png`)*

11. **Hình 11 — Thẻ Đề xuất Phân công Nhân sự Thích ứng AI (Adaptive Recommendation Card):**  
    Hiển thị chế độ BALANCED, xếp hạng ứng viên, chỉ số độ khớp kỹ năng (Fit %), chỉ số tác vụ thực tế (ACTIVE_TASK_COUNT) và lời giải thích logic từ AI.  
    *(Tệp minh chứng: `report/src/assets/collab/22_ai_adaptive_recommendation_card.png`)*

12. **Hình 12 — Tối ưu hóa Giao diện trên Thiết bị Di động (Mobile Responsive Drawer):**  
    Thanh điều hướng chuyển đổi linh hoạt thành ngăn kéo trượt cảm ứng trên màn hình 375x812 iPhone.  
    *(Tệp minh chứng: `report/src/assets/collab/23_mobile_responsive_collab_hub.png`)*

---

### 6. Kế hoạch Thực hiện Giai đoạn Tiếp theo (Giai đoạn 6)
1. **Triển khai Hệ thống Giám sát Toàn diện (Full-Stack Observability):** Cấu hình Prometheus và Grafana thu thập chỉ số tải tài nguyên, độ trễ truyền thông WebRTC SFU và thông lượng tin nhắn WebSocket.
2. **Tích hợp Đăng nhập Một Chạm (Social Login & SSO):** Kết nối dịch vụ Authentik IAM hỗ trợ đăng nhập liên kết qua Google và GitHub OAuth2.
3. **Đo kiểm Tải Hiệu năng (Load Testing):** Thực hiện kịch bản kiểm thử tải đồng thời qua k6/Gatling cho phân hệ Meeting & Chat và hoàn thiện tài liệu thuyết minh Khóa luận tốt nghiệp theo quy chuẩn UIT.

---

Chúng em kính gửi Cô xem xét và rất mong nhận được những nhận xét, góp ý quý báu từ Cô để nhóm tiếp tục hoàn thiện đề tài trong các giai đoạn tiếp theo ạ.

Kính chúc Cô dồi dào sức khỏe và có tuần làm việc hiệu quả!

Trân trọng kính thư,  
**Sinh viên Phan Lê Minh & Đặng Phú Thiện**  
*Đề tài Đồ án 2 (SE122.R11) — Trường Đại học Công nghệ Thông tin, ĐHQG-HCM*
