# Khi nào sẽ bị gì và nên làm gì
- CPU cao trên container/service → response chậm, backlog request tăng → nên: tăng CPU limit mỗi task, tăng số task (scale out), tối ưu logic xử lý, phân tải.

- Memory cao trên container/service → container có thể bị bị kill hoặc crash → nên: tăng memory limit, tối ưu bộ nhớ dùng (garbage collect, cache), xem leak, giảm concurrency.

- DB CPU cao → query chậm, kết nối mới bị queue → nên: tìm và tối ưu các query nặng, upgrade instance class, scale read replicas nếu phù hợp.

- DB memory vấn đề → swap, crash, kết nối từ chối → nên: xem memory allocation, connection pool, buffer/cache, instance đủ RAM.

- DB down hoàn toàn → app không truy cập được → nên: kiểm tra event log, backup/fail-over, replication setup, network/security, storage space.