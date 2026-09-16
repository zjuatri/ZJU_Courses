# 图书馆作业说明

## 文件说明

- `library_homework.cpp`：本次作业的完整 C++ 实现，包含 `Date`、`Book`、`Patron`、`Library` 和 `Transaction`。
- `README.md`：作业功能说明、设计思路和编译运行方法。

## 功能对应题目要求

### 1. `Book` 类

已实现以下内容：

- 成员：`isbn`、`title`、`author`、`copyright_date`
- 成员：`checked_out` 表示书是否已经借出
- 访问函数：获取各成员的值
- 借书函数：`check_out()`
- 还书函数：`check_in()`
- 有效性检查：仅接受 `n-n-n-x` 形式的 ISBN，其中前三段必须是整数，最后一段必须是单个数字或字母

### 2. 运算符重载

已实现：

- `operator==`：比较两本书的 ISBN 是否相同
- `operator!=`：比较两本书的 ISBN 是否不同
- `operator<<`：分行输出书名、作者和 ISBN

### 3. `Genre` 枚举

在 `Book` 类中定义了：

- `fiction`
- `nonfiction`
- `periodical`
- `biography`
- `children`

每本书在构造时都需要指定一个 `Genre`。

### 4. `Patron` 类

已实现以下内容：

- 成员：读者姓名 `user_name`
- 成员：借书证号 `card_number`
- 成员：借阅费 `fee`
- 访问函数：获取姓名、卡号和费用
- 设置费用函数：`set_fee()`
- 辅助函数：`owes_fee()`，返回读者是否欠费

### 5. `Library` 类

已实现以下内容：

- 保存图书的 `vector<Book>`
- 保存读者的 `vector<Patron>`
- 内部结构体 `Transaction`
  - 包含一个 `Book`
  - 包含一个 `Patron`
  - 包含一个 `Date`
- 保存借阅记录的 `vector<Transaction>`

并实现了以下函数：

- `add_book()`：向图书馆添加图书
- `add_patron()`：向图书馆添加读者
- `check_out_book()`：办理借书
  - 如果系统中没有该书，报错
  - 如果系统中没有该读者，报错
  - 如果读者欠费，报错
  - 如果图书已借出，报错
  - 条件满足时创建交易记录并加入 `transactions`
- `patrons_with_fees()`：返回所有欠费读者姓名组成的向量

## 设计说明

- `Date` 类用于表示日期，并做了简单合法性校验，避免出现非法年月日。
- `Book` 类中的 ISBN 检查没有使用复杂库，直接按题目要求检查格式，更容易向老师说明实现逻辑。
- `Library` 的借书函数会先检查图书和读者是否存在，再检查欠费和借出状态，最后登记交易记录。
- `main()` 中写了一个简单演示，展示对象创建、运算符重载、借书操作和欠费读者查询。

## 编译运行

如果你使用 `g++`，可以在当前目录执行：

```bash
g++ -std=c++11 -o library_homework library_homework.cpp
./library_homework
```

如果你使用 Visual Studio，也可以直接新建控制台项目后把 `library_homework.cpp` 加进去运行。

## 运行结果示例

程序会输出类似内容：

```text
Book information:
Title: The C++ Programming Language
Author: Bjarne Stroustrup
ISBN: 978-7-121-0-A

book1 == book2 ? false
book1 != book2 ? true
book3 genre: children

Alice borrowed book successfully.

Patrons with fees:
Bob

Transaction records:
Alice borrowed The C++ Programming Language on 2026-05-25
```

## 可交作业建议

如果老师只要求提交两个文件，那么直接提交下面两个文件即可：

- `README.md`
- `library_homework.cpp`
