# 日历逻辑说明

## 当前实现

### 星期标题顺序
```
日 一 二 三 四 五 六
0  1  2  3  4  5  6  (JavaScript getDay() 返回值)
```

### 空白填充逻辑

`getFirstDayOfMonth(year, month)` 返回该月1号是星期几（0-6）

- 如果1号是周日（getDay()=0）：不添加空白，1号显示在第1列（周日列）
- 如果1号是周一（getDay()=1）：添加1个空白，1号显示在第2列（周一列）
- 如果1号是周二（getDay()=2）：添加2个空白，1号显示在第3列（周二列）
- 如果1号是周三（getDay()=3）：添加3个空白，1号显示在第4列（周三列）
- 如果1号是周四（getDay()=4）：添加4个空白，1号显示在第5列（周四列）
- 如果1号是周五（getDay()=5）：添加5个空白，1号显示在第6列（周五列）
- 如果1号是周六（getDay()=6）：添加6个空白，1号显示在第7列（周六列）

## 示例：2024年12月

2024年12月1号是周日（getDay()=0）

```
日  一  二  三  四  五  六
1   2   3   4   5   6   7
8   9   10  11  12  13  14
15  16  17  18  19  20  21
22  23  24  25  26  27  28
29  30  31
```

## 示例：2025年1月

2025年1月1号是周三（getDay()=3）

```
日  一  二  三  四  五  六
         1   2   3   4
5   6   7   8   9   10  11
12  13  14  15  16  17  18
19  20  21  22  23  24  25
26  27  28  29  30  31
```

## 验证方法

可以使用以下JavaScript代码验证：

```javascript
// 2024年12月1号
new Date(2024, 11, 1).getDay()  // 返回 0 (周日)

// 2025年1月1号
new Date(2025, 0, 1).getDay()   // 返回 3 (周三)

// 2025年2月1号
new Date(2025, 1, 1).getDay()   // 返回 6 (周六)
```

## 当前代码逻辑

```typescript
static generateCalendarDays(year: number, month: number): DayInfo[] {
  const days: DayInfo[] = [];
  const firstDay = CalendarUtil.getFirstDayOfMonth(year, month);  // 获取1号是星期几
  const daysInMonth = CalendarUtil.getDaysInMonth(year, month);
  
  // 添加空白填充
  for (let i = 0; i < firstDay; i++) {
    // 添加 firstDay 个空白单元格
    const dayInfo = new DayInfo();
    dayInfo.day = 0;  // 0 表示空白
    days.push(dayInfo);
  }
  
  // 添加当月日期
  for (let day = 1; day <= daysInMonth; day++) {
    const dayInfo = new DayInfo();
    dayInfo.day = day;
    days.push(dayInfo);
  }
  
  return days;
}
```

**这个逻辑是正确的！**

## 可能的问题

如果您看到"每月第一天都是周一"，可能的原因：

1. **缓存问题**：应用没有重新加载最新代码
2. **数据问题**：显示的不是1号，而是其他日期
3. **视觉误解**：可能是在看不同的月份

## 建议

1. 完全关闭应用并重新启动
2. 检查多个不同的月份（2024年12月、2025年1月、2025年2月）
3. 使用console.log输出firstDay的值来调试

```typescript
const firstDay = CalendarUtil.getFirstDayOfMonth(year, month);
console.log(`${year}年${month}月1号是星期${firstDay}`);
```
