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

- HA là gì?

  > HA = High Availability = hệ thống không dễ chết
  > HA = có hỏng một phần, hệ thống vẫn chạy

- Node là gì?

  > Node = 1 máy / 1 instance đang chạy một vai trò

- Replica là gì?

  > Replica = bản sao
  > Replica = DB copy dữ liệu từ DB chính

**Có 2 loại chính:**

Primary / Writer

- DB chính
- Ghi (INSERT / UPDATE)

B. Replica / Reader

- DB phụ
- Chỉ đọc (SELECT)

- Failover là gì?

> Failover = khi node chính chết, hệ thống tự chuyển sang node khác

**Failover khác restart ở đâu?**

Restart:

- cùng 1 máy
- có downtime

Failover:

- chuyển sang máy khác
- downtime rất ngắn hoặc không có

- Chuyển node là gì?

> Chuyển node = đổi vai trò giữa các node

Thường là:

- Reader → Writer
- Writer cũ → bỏ

- Multi-AZ (liên quan HA)

**AZ là gì?**

> AZ = Availability Zone = 1 datacenter

**Multi-AZ nghĩa là:**

- DB có bản sao ở AZ khác
- 1 datacenter chết → còn cái khác

**Aurora HA khác RDS chỗ nào?**

RDS (Multi-AZ)

- 1 writer
- 1 standby
- Failover: 1–2 phút

Aurora

- Storage phân tán
- Nhiều reader
- Failover: vài chục giây

  👉 Vì thế Aurora đắt hơn

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

> Database = nơi lưu trạng thái sống còn của hệ thống

Infra quan tâm DB không phải ở:

- câu SQL
- index
- ORM

mà ở:

- độ ổn định
- scale
- backup
- failover
- connection

### RDS(Amazon Relational Database Service) là gì?

> RDS = Database do AWS quản lý hộ
> RDS không phải là 1 loại DB, mà là dịch vụ

RDS có thể chạy:

- MySQL
- PostgreSQL
- MariaDB
- SQL Server
- Oracle

👉 AWS lo:

- tạo DB
- backup
- patch
- monitoring

👉 User chỉ:

- connect
- dùng

**RDS phù hợp khi**

App vừa và nhỏ
Query không quá nặng
Team chưa muốn phức tạp

### Aurora là gì?

> Aurora = database “đặc biệt” của AWS
> Aurora = MySQL/Postgres-compatible nhưng do AWS viết lại

- Không phải MySQL thuần
- Không phải Postgres thuần
- Nhưng app dùng như bình thường

### Tính năng Amazon Aurora

**Hiệu năng cao và khả năng mở rộng**

> Aurora nhanh gấp 5 lần cơ sở dữ liệu MySQL tiêu chuẩn và nhanh gấp 3 lần các cơ sở dữ liệu PostgreSQL chuẩn mà không cần yêu cầu thay đổi gì đến các ứng dụng có sẵn.
> Amazon Aurora tự động tăng dung lượng khi cần thiết, tối đa 64TB trên mỗi cơ sở dữ liệu.

**Tính khả dụng và độ bền cao**

- Có kho chứa lỗi và tự phục hồi
- Aurora liên tục sao lưu dữ liệu của bạn lên Amazon S3 và khôi phục lại từ những thất bại trong việc lưu trữ vật lý
- Amazon Aurora cung cấp nhiều mức độ bảo mật cho cơ sở dữ liệu

**Tương thích MySQL và PostgreSQL**

**Quản lý hoàn toàn**

- Amazon Aurora được quản lý đầy đủ bởi Amazon Relational Database Service (RDS)
- Aurora tự động và liên tục giám sát và sao lưu cơ sở dữ liệu của bạn lên Amazon S3, cho phép khôi phục từng điểm một.
- Có thể theo dõi hiệu suất của cơ sở dữ liệu bằng cách sử dụng Amazon CloudWatch, Enhanced Monitoring, or Performance Insights

### Database cluster là gì?

```
Aurora Cluster
 ├─ Writer node
 └─ Reader node(s)
```

- 1 node ghi
- Nhiều node đọc
- Failover tự động

### Aurora Cluster là gì?

Aurora luôn luôn là cluster:

```
Aurora Cluster
 ├─ Writer node (ghi)
 ├─ Reader node #1
 ├─ Reader node #2
 └─ Distributed Storage
```

### So sánh RDS vs Aurora

| Tiêu chí    | **RDS**             | **Aurora**       |
| ----------- | ------------------- | ---------------- |
| Bản chất    | Managed DB          | Cloud-native DB  |
| Storage     | Gắn với instance    | Distributed      |
| HA          | Multi-AZ (chậm hơn) | Built-in (nhanh) |
| Scale read  | Có replica          | Rất mạnh         |
| Cost        | Rẻ hơn              | Đắt hơn          |
| Độ phức tạp | Thấp                | Cao hơn          |
| Hay dùng ở  | App nhỏ–vừa         | App lớn / scale  |

### RDS Proxy / DB Proxy đứng ở đâu?

Nhớ sơ đồ này:

```
App
 ↓
RDS Proxy
 ↓
RDS / Aurora
```

Proxy:

- giữ connection
- bảo vệ DB

DB:

- tập trung xử lý data

👉 Proxy dùng được cho cả RDS và Aurora

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

Được sử dụng cho các tài nguyên mà yêu cầu phải kết nối với mạng internet bên ngoài như web servers

Dùng cho:

- Load Balancer
- Bastion (nếu có)
- Private Subnet

**Private Subnet**

Được sử dụng cho các tài nguyên mà không cần kết nối với mạng internet như databases chẳng hạn.

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
