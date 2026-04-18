# OPTIGO - AI Route Intelligence Platform

**Ứng dụng trí tuệ nhân tạo tối ưu hóa vận tải bằng cách khai thác ghế trống và xe rỗng.**

![OptiGo Banner](https://img.shields.io/badge/Platform-Flutter-blue?style=for-the-badge&logo=flutter)
![OptiGo Backend](https://img.shields.io/badge/Backend-.NET-512bd4?style=for-the-badge&logo=dotnet)
![OptiGo Database](https://img.shields.io/badge/Database-Supabase-3ecf8e?style=for-the-badge&logo=supabase)

---

## Tóm tắt dự án

**OptiGo** là một nền tảng tiên tiến ứng dụng Trí tuệ nhân tạo (AI) nhằm giải quyết bài toán lãng phí công suất trong ngành vận tải. Dự án tập trung vào việc khai thác hiệu quả:
*   **Ghế trống:** Khi xe khách/xe cá nhân di chuyển nhưng không đủ khách.
*   **Xe rỗng chiều về:** Các chuyến xe đã hoàn thành hành trình một chiều và đang quay về không tải.

Bằng cách kết nối thông minh người đi và hàng hóa trên cùng các tuyến đường đã có sẵn, OptiGo giúp **giảm thiểu chi phí** cho khách hàng và **tăng thêm thu nhập** cho tài xế, đồng thời góp phần giảm ùn tắc và khí thải môi trường.

---

##  Công nghệ AI cốt lõi (Route Intelligence)

Trái tim của OptiGo là hệ thống **Route Intelligence** tự phát triển, đóng vai trò:

1.  **Phát hiện công suất dư:** Tự động nhận diện các khoảng trống (ghế/tải trọng) khả dụng trên các phương tiện.
2.  **So khớp thông minh (Matching):** Thuật toán cao cấp giúp ghép nối Tuyến đường - Thời gian thực tế với độ chính xác cao.
3.  **Xếp hạng khả năng chốt (Conversion Ranking):** Phân tích dữ liệu để dự đoán và ưu tiên các yêu cầu có khả năng thành công cao nhất, giảm thiểu tỉ lệ hủy chuyến.
4.  **Ước lượng mức tiết kiệm:** Hiển thị trực quan số tiền khách hàng tiết kiệm được và số tiền tài xế thu thêm được ngay khi so khớp.
5.  **AI Agent CSKH:** Hệ thống hỗ trợ khách hàng tự động, xử lý thắc mẵc và hỗ trợ đặt chuyến nhanh chóng 24/7 qua chatbot thông minh.

---

## 🛠 Dịch vụ cung cấp

OptiGo cung cấp hai luồng dịch vụ riêng biệt nhưng hoạt động trên cùng một nền tảng công nghệ:

### 1.  Luồng chở người
*   **Mục tiêu:** Kết nối người có nhu cầu di chuyển quãng đường trung bình - xa.
*   **Nguồn lực:** Các xe còn ghế trống hoặc xe chạy không tải kết thúc hành trình.
*   **Phân khúc:** Ưu tiên các tuyến đường liên tỉnh, ngoại ô.

###  2. Luồng chở hàng
*   **Mục tiêu:** Kết nối nhu cầu gửi hàng nhanh, hàng nhỏ lẻ của cá nhân/doanh nghiệp.
*   **Nguồn lực:** Xe Van, xe tải nhẹ còn dư diện tích/tải trọng hoặc đang trên đường về rỗng.
*   **Đặc điểm:** Tối ưu hóa thể tích thùng xe hiện có.

> [!IMPORTANT]
> **Quy tắc vận hành:** OptiGo **KHÔNG** ghép người và hàng trên cùng một phương tiện. Hai dịch vụ chỉ dùng chung năng lực lõi (so khớp, thanh toán, đánh giá) nhưng áp dụng quy tắc an toàn và tiêu chí ghép riêng biệt.

---

## Hệ sinh thái công nghệ

Nền tảng được xây dựng trên các công nghệ hiện đại nhất để đảm bảo hiệu năng và khả năng mở rộng:

*   **Frontend:** [Flutter](https://flutter.dev/) - Mang lại trải nghiệm mượt mà, đồng nhất trên cả iOS và Android.
*   **Database & Auth:** [Supabase](https://supabase.com/) - Backend-as-a-Service mạnh mẽ, cho phép xử lý dữ liệu thời gian thực và xác thực bảo mật.
*   **Backend:** [.NET (C#)](https://dotnet.microsoft.com/) - Xử lý logic nghiệp vụ phức tạp, API hiệu năng cao và tích hợp các mô hình AI/Machine Learning.

---

##  Giá trị cốt lõi

*   **Đối với Khách hàng:** Đi lại và gửi hàng với mức giá rẻ hơn đáng kể so với dịch vụ truyền thống.
*   **Đối với Tài xế:** Tận dụng tối đa tài sản sẵn có, biến chi phí "xe rỗng" thành lợi nhuận.
*   **Đối với Xã hội:** Tối ưu hóa nguồn lực vận tải hiện có, giảm số lượng xe chạy không tải trên đường.

---

##  Liên hệ

*   **Dự án:** OptiGo
*   **Lĩnh vực:** AI in Transportation / Logistics
*   **Email:** [Email của bạn]
*   **Website:** [Link website nếu có]

---
*© 2024 OptiGo - Khởi tạo từ sự tối ưu.*
