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

#### Stored Procedures

Stored Procedure là một đoạn code SQL được lưu trữ sẵn trong database, có thể gọi lại nhiều lần. Giống như một function trong programming.

Rails KHÔNG khuyến khích dùng Stored Procedures vì:

- Logic nên ở application layer (MVC pattern)
- Khó maintain, test, version control
- Lock vào database cụ thể (MySQL, PostgreSQL khác nhau)

Nhưng nếu cần dùng

```ruby
# Gọi stored procedure trong Rails
ActiveRecord::Base.connection.execute("CALL GetUserByEmail(?)", params[:email])

# Hoặc với PostgreSQL function
result = ActiveRecord::Base.connection.select_all(
  "SELECT * FROM get_user_by_email($1)",
  "SQL",
  [[nil, params[:email]]]
)
```

Khi nào nên dùng Stored Procedures?
✅ Nên dùng khi:

- Logic nghiệp vụ phức tạp cần nhiều queries (giảm round-trips)
- Shared database giữa nhiều applications
- Legacy systems đã có sẵn stored procedures
- Performance critical operations với data lớn

❌ KHÔNG nên dùng khi:

- Application đơn giản với ActiveRecord đủ dùng
- Team không có DBA hoặc kỹ năng SQL mạnh
- Cần deploy nhanh, CI/CD linh hoạt
- Logic cần test unit thường xuyên

#### Allow-list Input Validation

Allow-list (whitelist) là kỹ thuật chỉ cho phép các giá trị hợp lệ từ danh sách định sẵn. Từ chối tất cả những gì không nằm trong danh sách.

Khi nào cần Allow-list?

| Trường hợp | Cần Allow-list? | Lý do |
|------------|----------------|-------|
| User input vào WHERE value | ❌ Không | Dùng Prepared Statements |
| Column name động | ✅ Có | Không parameterize được |
| Table name động | ✅ Có | Không parameterize được |
| ORDER BY, LIMIT | ✅ Có | Không parameterize được |
| Fixed values | ❌ Không | Hard-code trong code |

Key Points

1. **Allow-list là lớp bảo vệ thứ 2** khi Prepared Statements không đủ
2. **LUÔN dùng allow-list** cho: column names, table names, ORDER BY, SQL keywords
3. **Blacklist = Bad**, Allow-list = Good
4. **Fail secure**: Từ chối mọi thứ không trong list
5. **Rails tip**: Dùng constants, symbols, và `column_names` để validate


```ruby
# ✅ AN TOÀN - Allow-list
def index
  allowed_columns = ['name', 'email', 'created_at', 'updated_at']
  sort_column = allowed_columns.include?(params[:sort_by]) ? params[:sort_by] : 'id'
  
  @users = User.order(sort_column)
end
```

#### Escaping All User Supplied Input

Escaping là kỹ thuật escape (thoát) các ký tự đặc biệt trong user input để chúng được xử lý như literal text, không phải SQL syntax.

Được khuyến nghị không dùng(Sẽ là biện pháp cuối cùng)

Tại sao Escaping là "last resort"?

- Dễ quên escape một chỗ nào đó
- Khác nhau giữa các databases (MySQL vs PostgreSQL vs SQL Server)
- Encoding issues (UTF-8, Unicode, multi-byte characters)
- Context-dependent - escape rules thay đổi tùy context
- Maintainability - Code khó maintain, dễ introduce bugs

#### Một số phương pháp khác

Ngoài 4 phướng pháp trên thì cũng nên suy xét và áp dụng các phương pháp sau để nâng cao khả năng bảo mật

- Hạn chế quyền truy cập (Least Privilege)

    - Để giảm thiểu thiệt hại tiềm tàng của một cuộc tấn công SQL injection thành công, bạn nên giảm thiểu quyền hạn được gán cho mỗi tài khoản cơ sở dữ liệu trong môi trường của mình. Hãy bắt đầu từ những bước cơ bản nhất để xác định các quyền truy cập mà tài khoản ứng dụng của bạn cần, thay vì cố gắng tìm ra những quyền truy cập mà bạn cần loại bỏ. 

- Allow-list Input Validation
    - Tham khảo : https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html

#### Nguồn

https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html

### CSRF (Cross-Site Request Forgery)

CSRF (Cross-Site Request Forgery) hay còn gọi XSRF, Session Riding là kỹ thuật tấn công lừa user thực hiện hành động không mong muốn trên website mà họ đã đăng nhập.

Cách hoạt động của CSRF Attack
Scenario thực tế:

```
1. User đăng nhập vào bank.com
   → Browser lưu session cookie

2. User vẫn đang login, mở tab khác browse web
   
3. User vào evil.com (do hacker tạo)
   
4. evil.com chứa code ẩn:
   <form action="https://bank.com/transfer" method="POST">
     <input name="to" value="hacker_account">
     <input name="amount" value="1000000">
   </form>
   <script>document.forms[0].submit()</script>
   
5. Browser TỰ ĐỘNG gửi request đến bank.com
   kèm theo session cookie (vì user vẫn đang login)
   
6. bank.com nhận request từ user đã authenticated
   → Chuyển tiền cho hacker!
```

Trong Rails có hỗ trợ bảo về khỏi CSRF. Tham khảo: https://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf

