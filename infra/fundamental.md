# Những kiến thức cơ bản cần biết
Danh sách những khái niệm, kiến thức cần biết

## Container & ECS
Hiểu khái niệm: container vs VM vs process.

Trong ECS: biết về task definition, service, cluster, launch type (EC2 vs Fargate).

Biết CPU & Memory được cấu hình cho mỗi task/container: ví dụ trong ECS task definition specify cpu và memory. 
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html?utm_source=chatgpt.com
- https://aws.amazon.com/vi/blogs/containers/how-amazon-ecs-manages-cpu-and-memory-resources/?utm_source=chatgpt.com

Biết cách ECS quản lý tài nguyên CPU/memory cho container: ví dụ blog “How Amazon ECS manages CPU and memory resources”. 
Amazon Web Services, Inc.
- https://aws.amazon.com/vi/blogs/containers/how-amazon-ecs-manages-cpu-and-memory-resources/?utm_source=chatgpt.com

Biết khi container vượt quá limit: ví dụ memory vượt – container bị kill/stop. 
- https://stackoverflow.com/questions/44764135/aws-ecs-task-memory-hard-and-soft-limits?utm_source=chatgpt.com
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/troubleshooting.html?utm_source=chatgpt.com
- https://repost.aws/knowledge-center/ecs-resolve-outofmemory-errors?utm_source=chatgpt.com

Cách monitor ECS tasks: CloudWatch, task logs, service events. 
AWS Documentation
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/troubleshooting.html?utm_source=chatgpt.com

Biết scaling rules: nếu CPU hoặc memory liên tục cao → scale out (thêm task), hoặc tăng resource mỗi task. 
- https://repost.aws/knowledge-center/ecs-container-instance-replacement-high-cpu-utilization?utm_source=chatgpt.com

## CPU vs Memory usage & hậu quả
CPU cao → app/process đang xử lý nặng hoặc chờ I/O, nếu vượt quá lâu sẽ dẫn đến response chậm, timeout.

Memory cao → có thể bị leak, không đủ RAM → hệ thống bắt đầu swap hoặc OS kill process (OOM).

Biết “credit‐base” cho RDS kiểu T2/T3: nếu dùng instance kiểu “burstable” sẽ có CPU credits, khi hết credit CPU bị throttle. 
- https://www.bluematador.com/docs/troubleshooting/rds-cpu?utm_source=chatgpt.com

Đối với DB: nếu CPU/memory cao → có thể chậm query, kết nối mới bị từ chối. 
- https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/mysql-troubleshooting-dbconn.html?utm_source=chatgpt.com

## DB (MySQL/PostgreSQL & RDS) troubleshooting
Tìm hiểu metric & công cụ: Amazon RDS Performance Insights, CloudWatch metrics như DBLoad, CPUUtilization. 
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.Cloudwatch.html?utm_source=chatgpt.com
- https://repost.aws/knowledge-center/rds-instance-high-cpu?utm_source=chatgpt.com

Cách tìm queries nặng: Top SQL tab. 
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.UsingDashboard.AnalyzeDBLoad.AdditionalMetrics.html?utm_source=chatgpt.com

Khi DB bị down hoặc kết nối fail: kiểm tra event logs, network/security groups, storage full. 
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Troubleshooting.html?utm_source=chatgpt.com

Memory issues trong Aurora/MySQL: dùng Performance Schema / SYS schema để xem usage. 
- https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/ams-workload-memory.html?utm_source=chatgpt.com

## Khi nào cần làm gì
Khi CloudWatch báo CPU hoặc memory vượt threshold: không chỉ nhìn số thôi, mà xem nguyên nhân (container, task, DB, query).

Nếu CPU container cao → kiểm tra code, query, logic xử lý, I/O.

Nếu Memory container cao → kiểm tra leak, tăng limit, scale.

Nếu DB CPU/memory cao → xem query nặng, kết nối nhiều, instance không đủ mạnh.

Nếu DB down → xem sự kiện AWS, logs, storage, security, replication/fail-over.

## “Credit base” và loại instance
Nếu dùng instance “burstable” (T2/T3) của RDS thì CPU hoạt động dựa vào credit: khi credit hết → CPU bị giới hạn → performance kém. 
- https://www.bluematador.com/docs/troubleshooting/rds-cpu?utm_source=chatgpt.com

Quan trọng biết loại instance đang dùng, cấu hình task/container (ECS) đúng size hay không.