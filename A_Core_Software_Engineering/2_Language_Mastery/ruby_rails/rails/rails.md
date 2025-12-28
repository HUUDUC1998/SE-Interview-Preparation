# Nâng cấp kiến thức về rails

## Security

### SQL injection

Tấn công SQL Injection là gì?

Kẻ tấn công có thể sử dụng kỹ thuật tấn công SQL injection vào một ứng dụng nếu ứng dụng đó có các truy vấn cơ sở dữ liệu động sử dụng phép nối chuỗi và dữ liệu đầu vào do người dùng cung cấp.

Để tránh các lỗ hổng tấn công SQL injection, các nhà phát triển cần phải
- Ngừng viết các truy vấn động bằng cách nối chuỗi. Ví dụ `User.where("name = #{params["name"]}")`, với việc thay đổi param["name"] bằng một đoạn mã sql độc thì ta sẽ bị tấn công.
- Ngăn chặn việc đưa dữ liệu SQL độc hại vào các truy vấn được thực thi. Thường xuyên kiểm tra dữ liệu nhập vào từ user trước khi thực hiện lệnh sql.

Các biện pháp phòng thủ chính sau đây sẽ ngăn chặn sql injection
- Use of Prepared Statements (with Parameterized Queries)
- Use of Properly Constructed Stored Procedures
- Allow-list Input Validation
- STRONGLY DISCOURAGED: Escaping All User Supplied Input

#### Prepared Statements

Về cơ bản là nên dùng Parameterized Queries thay vì Dynamic Queries. Parameterized Queries

Prepared Statements là kỹ thuật tách biệt code SQL và data thành 2 phần riêng biệt.
- Compile câu query trước (với placeholders)
- Sau đó mới bind data vào

Với ví dụ bên trên

```ruby
# bad
User.where("name = #{params["name"]}")
# Nếu hacker nhập: admin' OR '1'='1
# → Query thành: SELECT * FROM users WHERE username = 'admin' OR '1'='1'
# → Trả về tất cả users!

# or 
# sai
sql = "SELECT * FROM users WHERE name = '#{params[:name]}'"
ActiveRecord::Base.connection.execute(sql)

# good

User.where("name = ?#", params["name"])
# Dù hacker nhập `admin' OR '1'='1`, database sẽ xử lý nó như **1 string bình thường**, tìm user có username chính xác là `admin' OR '1'='1` (không tồn tại).

# or 
# AN TOÀN - Named placeholders
User.where("username = :username", username: params[:username])

# or 
sql = "SELECT * FROM users WHERE name = ?"
ActiveRecord::Base.connection.exec_query(sql, 'SQL', [[nil, params[:name]]])

## Cơ chế hoạt động

┌─────────────────────────────────────┐
│ 1. Gửi SQL template với placeholders│
│    SELECT * FROM users WHERE id = ? │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│ 2. Database COMPILE & LƯU CẤU TRÚC  │
│    (biết đây là 1 câu SELECT)       │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│ 3. Gửi data riêng biệt: id = 5      │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│ 4. Database BIND data vào           │
│    Data luôn được escape & treat as │
│    DATA, không bao giờ là CODE      │
└─────────────────────────────────────┘

```

Chú ý hay cẩn thận các trường hợp sau
- Raw SQL queries:

```ruby
# SAI
sql = "SELECT * FROM users WHERE name = '#{params[:name]}'"
ActiveRecord::Base.connection.execute(sql)

# ĐÚNG
sql = "SELECT * FROM users WHERE name = ?"
ActiveRecord::Base.connection.exec_query(sql, 'SQL', [[nil, params[:name]]])
```

- ORDER BY / LIMIT (không thể dùng placeholders):

```ruby
# Phải whitelist
allowed_columns = ['name', 'email', 'created_at']
column = params[:sort_by]

if allowed_columns.include?(column)
  User.order(column)
else
  User.order(:id) # default
end
```

Key Points

- Prepared Statements tách code và data - data không bao giờ được execute như code
- Rails tự động dùng Prepared Statements khi bạn dùng placeholders (? hoặc :name)
- Tránh string interpolation (#{}) trong SQL queries
- Luôn sanitize/whitelist cho các phần không thể parameterize (ORDER BY, column names, table names)

#### Nguồn

https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html