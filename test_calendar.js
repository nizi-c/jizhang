const months = [
  [2024, 10, '11月'],
  [2024, 11, '12月'],
  [2025, 0, '1月'],
  [2025, 1, '2月'],
  [2025, 2, '3月'],
  [2025, 3, '4月']
];

months.forEach(([year, month, name]) => {
  const firstDay = new Date(year, month, 1).getDay();
  const blanks = (firstDay + 6) % 7;
  const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  console.log(`${year}年${name}: 1号是${weekDays[firstDay]}(getDay=${firstDay}), 空白数=${blanks}`);
});
