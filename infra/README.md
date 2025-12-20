# Các khái niệm cơ bản về infra

Dưới đây là một số thành phần quan trọng cần nắm bắt

## Các từ chuyên môn

- Cluster là gì?: một nhóm máy / tài nguyên được gom lại để hoạt động như MỘT hệ thống
  - Compute cluster, Database cluster, Cache / Queue cluster

```
Cluster KHÔNG phải là gì (rất hay nhầm)
❌ Cluster ≠ 1 server
❌ Cluster ≠ 1 service
❌ Cluster ≠ auto scale (nhưng thường đi kèm)
```

- Blueprint nghĩa là gì?: bản vẽ tổng thể của hệ thống

```
Cho biết:
Có những thành phần nào
Chúng nối với nhau ra sao
Ai chịu trách nhiệm việc gì

Ví dụ
- Web / API chạy ở đâu
- Có bao nhiêu service
- DB kết nối thế nào
- Có cache không
- Có proxy (DB Proxy) không
```

## Compute

### EC2(Elastic Compute Cloud)

EC2 = 1 cái máy tính trên cloud. EC2 giống hệt máy Linux thuê trên AWS

**EC2 hoạt động thế nào?**

```
User
 ↓
AWS tạo 1 máy Linux (EC2)
 ↓
User SSH vào
 ↓
Cài:
  - Ruby / Node
  - Nginx
  - App
  - Docker (nếu muốn)
```

**Ưu / nhược của EC2**

✅ Ưu:

- Dễ hiểu nhất
-
- Debug thoải mái
-
- Toàn quyền kiểm soát

❌ Nhược:

- Ops mệt
-
- Scale chậm
-
- Dễ cấu hình sai

### ECS(Elastic Container Service)

ECS = dịch vụ chạy container (Docker)

**ECS hoạt động thế nào?**

```
Code
 ↓
Docker image
 ↓
ECS chạy image đó
```

**ECS có 2 chế độ (rất quan trọng)**

A. ECS on EC2 (ít dùng cho junior)
ECS dùng EC2 bên dưới
Vẫn phải quản EC2

B. ECS Fargate (thứ công ty hay dùng)
Fargate = không cần quan tâm server

- Không tạo EC2
- Không SSH

Chỉ nói:

- dùng image này
- RAM bao nhiêu
- CPU bao nhiêu

**ECS Fargate hoạt động thế nào?**

```
Request
 ↓
Load Balancer
 ↓
ECS Service
 ↓
Container (app sống lâu)
 ↓
Database
```

- Container sống liên tục
- Connection DB giữ ổn
- Scale = thêm container

- ECS Cluster là gì?: ECS Cluster = chỗ để ECS chạy container

```
ECS Cluster
 ├─ Container #1
 ├─ Container #2
 ├─ Container #3

```

**ECS hierarchy (rất quan trọng)**

```
Cluster
 └─ Service
     └─ Task
         └─ Container
```

### Lambda

AWS Lambda = chạy code mà không quản server
Lambda là code chạy theo sự kiện, sống ngắn, scale rất mạnh

- Không EC2
-
- Không SSH
-
- Không “server sống mãi”
-
- Có request → Lambda chạy
-
- Xong việc → Lambda biến mất

**Vì sao cứ nghe Lambda là phải nghĩ tới DB Proxy?**
Vì Lambda có 3 đặc điểm rất độc:

1. Scale cực nhanh

- 1 request → 1 Lambda
- Traffic tăng → hàng trăm Lambda

2. Không giữ connection lâu

- Lambda chết → connection bị drop
- DB không thích chuyện này

3. Cold start

- Lambda mới → connect DB từ đầu
- Tốn thời gian + dễ timeout

**Khi nào công ty chọn Lambda?**

**Người ta chọn Lambda khi:**

- API nhỏ
- Event-based (webhook, cron, queue)
- Traffic không đều
- Muốn giảm ops (không quản server)

**Người ta không chọn Lambda khi:**

- App monolith to
- Query DB nặng
- Connection dài
- Real-time liên tục

## Database

Database cluster là gì?

```
Aurora Cluster
 ├─ Writer node
 └─ Reader node(s)
```

- 1 node ghi
- Nhiều node đọc
- Failover tự động

## Networking

**Networking là gì**
Quy tắc cho phép các thành phần nói chuyện với nhau

- Ai được nói chuyện với ai
- Qua cổng nào
- Từ đâu tới đâu

**VPC – gốc của mọi network trên AWS**
**VPC là gì?**

- VPC là một mạng ảo trong AWS cloud, được cô lập rành riêng cho account
- Mọi thứ (EC2, ECS, DB, Redis…) nằm trong VPC. Người ngoài không thấy được nếu không cho phép. Tại đây bạn có thể khởi chạy các tài nguyên cũng như dịch vụ AWS của mình một cách an toàn đồng thời có thể control hoàn toàn chúng

**Subnet – chia VPC thành khu**

Subnet: một phần nhỏ của VPC

Có 2 loại:

**Public Subnet**

Có đường ra Internet

Dùng cho:

- Load Balancer
- Bastion (nếu có)
- Private Subnet

Không ra Internet trực tiếp

Dùng cho:

- App
- DB
- Cache

VD:

```
VPC
 ├─ Public Subnet
 │    └─ ALB
 └─ Private Subnet
      ├─ App (ECS)
      └─ DB
```

**Internet Gateway & NAT**

**Internet Gateway (IGW)**

- Cửa ra/vào Internet cho VPC
- Gắn vào VPC

**NAT Gateway**

- Cho private subnet đi ra ngoài
- Nhưng Internet không đi vào được

👉 App private vẫn:

- gọi API ngoài
- pull package

**Security Group**

Security Group là gì?: Firewall ở level resource

Cho phép / chặn traffic dựa trên:

- IP
- Port
- Protocol

> Security Groups dùng để kiểm soát lưu lượng truy cập vào/ra của các EC instances. Chúng ta có thể sử dụng Security Groups mặc định mà AWS đã tạo khi chúng ta tạo mới một instance hoặc tự define một cái để quản lý Inbound/outbound traffic.

Ví dụ:

- ALB: mở 80 / 443 từ Internet
- App: chỉ nhận từ ALB
- DB: chỉ nhận từ App

## Load Balancer (ALB / ELB)

## Cache (Redis / ElastiCache)

## Queue / Async (SQS)

## Observability (log / metric / alarm)
