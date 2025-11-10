# Những kiến thức cơ bản cần biết
Danh sách những khái niệm, kiến thức cần biết

## Container & ECS
### Hiểu khái niệm: container vs VM vs process.
1. Amazon Web Services (AWS) — “The difference between containers and virtual machines”
https://aws.amazon.com/compare/the-difference-between-containers-and-virtual-machines/
  → Giải thích rất rõ: VM ảo hóa toàn bộ phần cứng + OS, còn container ảo hóa ở mức OS, nhẹ hơn. 

2. Atlassian — Containers vs Virtual Machines (VMs)
https://www.atlassian.com/microservices/cloud-computing/containers-vs-vms
  → Có bảng so sánh, điểm mạnh/nhược, khi nào dùng container vs VM. 
  Atlassian

3. Red Hat — Containers vs VMs
https://www.redhat.com/en/topics/containers/containers-vs-vms
  → Cập nhật gần đây (2023) về cách container & VM khác nhau, và khi nào nên dùng mỗi cái. 
  [redhat.com](https://www.redhat.com/en/topics/containers/containers-vs-vms?utm_source=chatgpt.com)

4. Jessica Greben — What is the difference between a process, a container, and a VM? (Medium blog)
https://jessicagreben.medium.com/what-is-the-difference-between-a-process-a-container-and-a-vm-f36ba0f8a8f7
  → Bao gồm process nữa (không chỉ container vs VM) — rất phù hợp với bạn đang tìm hiểu cả process. 

5. (Cho khi bạn muốn đi sâu) Academia paper: A Qualitative and Quantitative Analysis of Container Engines — nghiên cứu chuyên sâu về performance giữa container & VM. https://arxiv.org/abs/2303.04080?utm_source=chatgpt.com

> Gợi ý cách học

1. Bắt đầu với bài viết 1 hoặc 2 để hiểu khái niệm cơ bản: process vs “máy ảo” (VM) vs container.

2. Sau đó đọc bài viết 4 để thấy rõ “process” là gì và tại sao container có thể coi như một tiến trình (process) nhưng với cách biệt hơn.

3. Khi bạn đã hiểu và muốn áp dụng cho hạ tầng của bạn (ví dụ dùng Docker, Kubernetes, Amazon ECS) thì đọc 3 và 5 để hiểu trade-off và performance.

### Trong ECS: biết về task definition, service, cluster, launch type (EC2 vs Fargate).
1. AWS Docs – Launch types
Trang chính thức giải thích launch types trong ECS: EC2 vs Fargate; cách task definition & cluster hoạt động.
→ [“Amazon ECS launch types – Amazon Elastic Container Service” 
AWS Documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-configuration.html?utm_source=chatgpt.com)

2. AWS Docs – Task definition differences for Fargate
Giải thích đặc biệt cho khi bạn dùng launch type FARGATE, các tham số Task Definition bị khác/giới hạn. 
→ [“Amazon ECS task definition differences for the Fargate launch type” 
AWS Documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-tasks-services.html?utm_source=chatgpt.com)

3. Blog/Article – Comparing EC2 vs Fargate
Giải thích rõ phần so sánh giữa hai launch type, khi nào nên dùng cái nào.
→ [“Comparing Amazon ECS launch types: EC2 vs. Fargate” 
Lumigo](https://lumigo.io/blog/comparing-amazon-ecs-launch-types-ec2-vs-fargate/?utm_source=chatgpt.com)
→ [“Fargate vs EC2: What is the difference and which is best for ECS?” 
Spot.io](https://spot.io/blog/fargate-vs-ecs-comparing-amazons-container-management-services/?utm_source=chatgpt.com)

4. YouTube Video
[“AWS ECS on EC2 vs Fargate: Choosing Your AWS Container Launch Type”](https://www.youtube.com/watch?v=ArSrQwh4dPg) trên YouTube.

### Biết CPU & Memory được cấu hình cho mỗi task/container: ví dụ trong ECS task definition specify cpu và memory. 
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html?utm_source=chatgpt.com
- https://aws.amazon.com/vi/blogs/containers/how-amazon-ecs-manages-cpu-and-memory-resources/?utm_source=chatgpt.com

### Biết cách ECS quản lý tài nguyên CPU/memory cho container: ví dụ blog “How Amazon ECS manages CPU and memory resources”. 
- https://aws.amazon.com/vi/blogs/containers/how-amazon-ecs-manages-cpu-and-memory-resources/?utm_source=chatgpt.com

### Biết khi container vượt quá limit: ví dụ memory vượt – container bị kill/stop. 
- https://stackoverflow.com/questions/44764135/aws-ecs-task-memory-hard-and-soft-limits?utm_source=chatgpt.com
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/troubleshooting.html?utm_source=chatgpt.com
- https://repost.aws/knowledge-center/ecs-resolve-outofmemory-errors?utm_source=chatgpt.com

### Cách monitor ECS tasks: CloudWatch, task logs, service events. 
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/troubleshooting.html?utm_source=chatgpt.com

### Biết scaling rules: nếu CPU hoặc memory liên tục cao → scale out (thêm task), hoặc tăng resource mỗi task. 
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