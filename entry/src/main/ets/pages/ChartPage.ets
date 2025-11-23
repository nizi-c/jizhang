import { AccountRecord, CategorySummary } from '../models/AccountRecord';
import { AccountViewModel } from '../viewmodel/AccountViewModel';
import { COLORS } from '../constants/Constants';
import { StorageUtil } from '../utils/StorageUtil';
import { ThemeUtil } from '../utils/ThemeUtil';
import { LIGHT_COLOR_SCHEME, DARK_COLOR_SCHEME } from '../constants/ColorSchemes';
import router from '@ohos.router';

@Component
export struct ChartPage {
  records: AccountRecord[] = [];
  viewModel: AccountViewModel = new AccountViewModel();

  // 时间维度和图表类型
  @State timeDimension: 'week' | 'month' | 'year' = 'month';
  @State chartType: 'pie' | 'line' | 'bar' = 'pie';
  @State currentDate: Date = new Date();
  @State showMenu: boolean = false;

  // 统计数据
  @State totalIncome: number = 0;
  @State totalExpense: number = 0;
  @State expenseCategories: CategorySummary[] = [];
  @State incomeCategories: CategorySummary[] = [];
  
  // 折线图数据
  @State trendLabels: string[] = [];
  @State trendIncomeData: number[] = [];
  @State trendExpenseData: number[] = [];
  
  // Canvas上下文
  private chartContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true));

  aboutToAppear() {
    this.loadData();
  }

  async loadData() {
    this.records = await StorageUtil.getRecords();
    this.viewModel.records = this.records;
    this.updateCharts();
  }

  getColorScheme() {
    return ThemeUtil.getTheme() === 'light' ? LIGHT_COLOR_SCHEME : DARK_COLOR_SCHEME;
  }

  // 获取时间标签
  getTimeLabel(): string {
    const year = this.currentDate.getFullYear();
    const month = this.currentDate.getMonth() + 1;
    
    switch (this.timeDimension) {
      case 'week':
        const weekNum = this.getWeekNumber(this.currentDate);
        return `${year}年第${weekNum}周`;
      case 'month':
        return `${year}年${month}月`;
      case 'year':
        return `${year}年`;
    }
  }

  // 获取周数
  getWeekNumber(date: Date): number {
    const firstDay = new Date(date.getFullYear(), 0, 1);
    const days = Math.floor((date.getTime() - firstDay.getTime()) / (24 * 60 * 60 * 1000));
    return Math.ceil((days + firstDay.getDay() + 1) / 7);
  }

  // 上一个时间段
  previousPeriod() {
    const newDate = new Date(this.currentDate);
    switch (this.timeDimension) {
      case 'week':
        newDate.setDate(newDate.getDate() - 7);
        break;
      case 'month':
        newDate.setMonth(newDate.getMonth() - 1);
        break;
      case 'year':
        newDate.setFullYear(newDate.getFullYear() - 1);
        break;
    }
    this.currentDate = newDate;
    this.updateCharts();
  }

  // 下一个时间段
  nextPeriod() {
    const newDate = new Date(this.currentDate);
    switch (this.timeDimension) {
      case 'week':
        newDate.setDate(newDate.getDate() + 7);
        break;
      case 'month':
        newDate.setMonth(newDate.getMonth() + 1);
        break;
      case 'year':
        newDate.setFullYear(newDate.getFullYear() + 1);
        break;
    }
    this.currentDate = newDate;
    this.updateCharts();
  }

  // 获取开始日期
  getStartDate(): Date {
    const date = new Date(this.currentDate);
    switch (this.timeDimension) {
      case 'week':
        const day = date.getDay();
        date.setDate(date.getDate() - day);
        date.setHours(0, 0, 0, 0);
        return date;
      case 'month':
        return new Date(date.getFullYear(), date.getMonth(), 1);
      case 'year':
        return new Date(date.getFullYear(), 0, 1);
    }
  }

  // 获取结束日期
  getEndDate(): Date {
    const date = new Date(this.currentDate);
    switch (this.timeDimension) {
      case 'week':
        const day = date.getDay();
        date.setDate(date.getDate() + (6 - day));
        date.setHours(23, 59, 59, 999);
        return date;
      case 'month':
        return new Date(date.getFullYear(), date.getMonth() + 1, 0, 23, 59, 59, 999);
      case 'year':
        return new Date(date.getFullYear(), 11, 31, 23, 59, 59, 999);
    }
  }

  // 更新图表数据
  updateCharts() {
    const startDate = this.getStartDate();
    const endDate = this.getEndDate();

    // 筛选时间范围内的记录
    const filteredRecords = this.records.filter(record => {
      const recordDate = new Date(record.dateStr);
      return recordDate >= startDate && recordDate <= endDate;
    });

    // 计算总收入和总支出
    this.totalIncome = filteredRecords
      .filter(r => r.type === 'income')
      .reduce((sum, r) => sum + r.amount, 0);

    this.totalExpense = filteredRecords
      .filter(r => r.type === 'expense')
      .reduce((sum, r) => sum + r.amount, 0);

    // 计算分类汇总
    this.expenseCategories = this.calculateCategorySummary(filteredRecords, 'expense');
    this.incomeCategories = this.calculateCategorySummary(filteredRecords, 'income');
    
    // 计算趋势数据
    this.calculateTrendData(filteredRecords);
    
    // 重新绘制折线图
    setTimeout(() => {
      this.drawLineChart();
    }, 100);
  }
  
  // 计算趋势数据
  calculateTrendData(records: AccountRecord[]) {
    const labels: string[] = [];
    const incomeData: number[] = [];
    const expenseData: number[] = [];
    
    if (this.timeDimension === 'week') {
      // 按天统计（7天）
      for (let i = 6; i >= 0; i--) {
        const date = new Date(this.currentDate);
        date.setDate(date.getDate() - (6 - i));
        const dateStr = this.formatDateShort(date);
        labels.push(dateStr);
        
        const dayRecords = records.filter(r => r.dateStr === this.formatDateFull(date));
        const income = dayRecords.filter(r => r.type === 'income').reduce((sum, r) => sum + r.amount, 0);
        const expense = dayRecords.filter(r => r.type === 'expense').reduce((sum, r) => sum + r.amount, 0);
        
        incomeData.push(income);
        expenseData.push(expense);
      }
    } else if (this.timeDimension === 'month') {
      // 按周统计（4周）
      for (let i = 3; i >= 0; i--) {
        const weekStart = new Date(this.currentDate);
        weekStart.setDate(1 + i * 7);
        labels.push(`第${i + 1}周`);
        
        const weekEnd = new Date(weekStart);
        weekEnd.setDate(weekStart.getDate() + 6);
        
        const weekRecords = records.filter(r => {
          const recordDate = new Date(r.dateStr);
          return recordDate >= weekStart && recordDate <= weekEnd;
        });
        
        const income = weekRecords.filter(r => r.type === 'income').reduce((sum, r) => sum + r.amount, 0);
        const expense = weekRecords.filter(r => r.type === 'expense').reduce((sum, r) => sum + r.amount, 0);
        
        incomeData.push(income);
        expenseData.push(expense);
      }
    } else {
      // 按月统计（12个月）
      for (let i = 11; i >= 0; i--) {
        const monthDate = new Date(this.currentDate.getFullYear(), 11 - i, 1);
        labels.push(`${monthDate.getMonth() + 1}月`);
        
        const monthStr = `${monthDate.getFullYear()}-${String(monthDate.getMonth() + 1).padStart(2, '0')}`;
        const monthRecords = records.filter(r => r.dateStr.startsWith(monthStr));
        
        const income = monthRecords.filter(r => r.type === 'income').reduce((sum, r) => sum + r.amount, 0);
        const expense = monthRecords.filter(r => r.type === 'expense').reduce((sum, r) => sum + r.amount, 0);
        
        incomeData.push(income);
        expenseData.push(expense);
      }
    }
    
    this.trendLabels = labels;
    this.trendIncomeData = incomeData;
    this.trendExpenseData = expenseData;
  }
  
  // 格式化日期（短格式）
  formatDateShort(date: Date): string {
    return `${date.getMonth() + 1}/${date.getDate()}`;
  }
  
  // 格式化日期（完整格式）
  formatDateFull(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  // 计算分类汇总
  calculateCategorySummary(records: AccountRecord[], type: 'income' | 'expense'): CategorySummary[] {
    const filtered = records.filter(r => r.type === type);
    const total = filtered.reduce((sum, r) => sum + r.amount, 0);

    if (total === 0) return [];

    const categoryMap = new Map<string, number>();
    filtered.forEach(record => {
      const current = categoryMap.get(record.category) || 0;
      categoryMap.set(record.category, current + record.amount);
    });

    const summaries: CategorySummary[] = [];
    categoryMap.forEach((amount, category) => {
      summaries.push({
        category: category,
        amount: amount,
        percentage: (amount / total) * 100,
        color: this.getCategoryColor(category)
      });
    });

    return summaries.sort((a, b) => b.amount - a.amount);
  }

  // 获取分类颜色
  getCategoryColor(category: string): string {
    const colors: Record<string, string> = {
      '食物': '#E8A5A5',
      '交通': '#8FAADC',
      '娱乐': '#E8C9A5',
      '购物': '#C9B6D6',
      '医疗': '#95D1B3',
      '教育': '#A5C8E8',
      '住房': '#B8B5B2',
      '工资': '#95D1B3',
      '奖金': '#E8C9A5',
      '投资': '#8FAADC',
      '兼职': '#C9B6D6',
      '其他': '#D6C9B6'
    };
    return colors[category] || '#B8B5B2';
  }

  build() {
    Stack() {
      Column() {
        // 顶部导航栏
        Row() {
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Text('←')
              .fontSize(20)
              .fontColor(this.getColorScheme().NAVBAR.backButtonColor)
          }
          .width(36)
          .height(36)
          .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
          .onClick(() => {
            router.back();
          })

          Text('统计')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().NAVBAR.titleColor)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Text('⋮')
              .fontSize(24)
              .fontColor(this.getColorScheme().NAVBAR.titleColor)
          }
          .width(36)
          .height(36)
          .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
          .onClick(() => {
            this.showMenu = !this.showMenu;
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
        .border({ width: { bottom: 1 }, color: this.getColorScheme().NAVBAR.borderColor })

        Scroll() {
          Column() {
            // 时间选择器
            Row() {
              Button('<')
                .width(40)
                .height(36)
                .backgroundColor(this.getColorScheme().MONTH_PICKER.buttonBackground)
                .fontColor(this.getColorScheme().MONTH_PICKER.buttonTextColor)
                .onClick(() => {
                  this.previousPeriod();
                })

              Text(this.getTimeLabel())
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.getColorScheme().MONTH_PICKER.textColor)
                .layoutWeight(1)
                .textAlign(TextAlign.Center)

              Button('>')
                .width(40)
                .height(36)
                .backgroundColor(this.getColorScheme().MONTH_PICKER.buttonBackground)
                .fontColor(this.getColorScheme().MONTH_PICKER.buttonTextColor)
                .onClick(() => {
                  this.nextPeriod();
                })
            }
            .width('100%')
            .padding(12)
            .backgroundColor(this.getColorScheme().MONTH_PICKER.backgroundColor)
            .margin({ bottom: 16 })

            // 收支概览卡片
            Row() {
              Column() {
                Text('收入')
                  .fontSize(12)
                  .fontColor(this.getColorScheme().STAT_CARD.labelColor)
                  .margin({ bottom: 4 })
                Text(`¥${this.totalIncome.toFixed(2)}`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getColorScheme().STAT_CARD.incomeColor)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)

              Column() {
                Text('支出')
                  .fontSize(12)
                  .fontColor(this.getColorScheme().STAT_CARD.labelColor)
                  .margin({ bottom: 4 })
                Text(`¥${this.totalExpense.toFixed(2)}`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getColorScheme().STAT_CARD.expenseColor)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)

              Column() {
                Text('结余')
                  .fontSize(12)
                  .fontColor(this.getColorScheme().STAT_CARD.labelColor)
                  .margin({ bottom: 4 })
                Text(`¥${(this.totalIncome - this.totalExpense).toFixed(2)}`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.totalIncome >= this.totalExpense ?
                    this.getColorScheme().STAT_CARD.incomeColor :
                    this.getColorScheme().STAT_CARD.expenseColor)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)
            }
            .width('100%')
            .padding(16)
            .backgroundColor(this.getColorScheme().STAT_CARD.backgroundColor)
            .borderRadius(8)
            .margin({ bottom: 16 })

            // 图表展示区（暂时显示简单列表）
            this.buildChartSection()
          }
          .width('100%')
          .padding(16)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundImage(ThemeUtil.getBackgroundImage(ThemeUtil.getTheme()))
      .backgroundImageSize(ImageSize.Cover)
      .backgroundImagePosition(Alignment.Center)

      // 菜单弹窗
      if (this.showMenu) {
        this.buildMenuDialog()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildMenuDialog() {
    Column() {
      Column() {
        // 时间维度选择
        Text('时间维度')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().DIALOG.titleColor)
          .margin({ bottom: 12 })

        Row() {
          Button('周')
            .width('30%')
            .height(36)
            .backgroundColor(this.timeDimension === 'week' ?
              this.getColorScheme().TYPE_SELECTOR.activeBackground :
              this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
            .fontColor(this.timeDimension === 'week' ?
              this.getColorScheme().TYPE_SELECTOR.activeTextColor :
              this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
            .fontSize(12)
            .onClick(() => {
              this.timeDimension = 'week';
              this.updateCharts();
            })

          Row().width('5%')

          Button('月')
            .width('30%')
            .height(36)
            .backgroundColor(this.timeDimension === 'month' ?
              this.getColorScheme().TYPE_SELECTOR.activeBackground :
              this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
            .fontColor(this.timeDimension === 'month' ?
              this.getColorScheme().TYPE_SELECTOR.activeTextColor :
              this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
            .fontSize(12)
            .onClick(() => {
              this.timeDimension = 'month';
              this.updateCharts();
            })

          Row().width('5%')

          Button('年')
            .width('30%')
            .height(36)
            .backgroundColor(this.timeDimension === 'year' ?
              this.getColorScheme().TYPE_SELECTOR.activeBackground :
              this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
            .fontColor(this.timeDimension === 'year' ?
              this.getColorScheme().TYPE_SELECTOR.activeTextColor :
              this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
            .fontSize(12)
            .onClick(() => {
              this.timeDimension = 'year';
              this.updateCharts();
            })
        }
        .width('100%')
        .margin({ bottom: 16 })

        Divider()
          .strokeWidth(1)
          .color(this.getColorScheme().DIALOG.borderColor)
          .margin({ bottom: 16 })

        // 图表类型选择
        Text('图表类型')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().DIALOG.titleColor)
          .margin({ bottom: 12 })

        Row() {
          Button('饼图')
            .width('30%')
            .height(36)
            .backgroundColor(this.chartType === 'pie' ?
              this.getColorScheme().TYPE_SELECTOR.activeBackground :
              this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
            .fontColor(this.chartType === 'pie' ?
              this.getColorScheme().TYPE_SELECTOR.activeTextColor :
              this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
            .fontSize(12)
            .onClick(() => {
              this.chartType = 'pie';
            })

          Row().width('5%')

          Button('折线图')
            .width('30%')
            .height(36)
            .backgroundColor(this.chartType === 'line' ?
              this.getColorScheme().TYPE_SELECTOR.activeBackground :
              this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
            .fontColor(this.chartType === 'line' ?
              this.getColorScheme().TYPE_SELECTOR.activeTextColor :
              this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
            .fontSize(12)
            .onClick(() => {
              this.chartType = 'line';
            })

          Row().width('5%')

          Button('柱状图')
            .width('30%')
            .height(36)
            .backgroundColor(this.chartType === 'bar' ?
              this.getColorScheme().TYPE_SELECTOR.activeBackground :
              this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
            .fontColor(this.chartType === 'bar' ?
              this.getColorScheme().TYPE_SELECTOR.activeTextColor :
              this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
            .fontSize(12)
            .onClick(() => {
              this.chartType = 'bar';
            })
        }
        .width('100%')
      }
      .width('80%')
      .padding(20)
      .backgroundColor(this.getColorScheme().DIALOG.backgroundColor)
      .borderRadius(12)
      .shadow({ radius: 20, color: '#00000040' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#00000040')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.showMenu = false;
    })
  }

  @Builder
  buildChartSection() {
    Column() {
      // 根据图表类型显示不同的图表
      if (this.chartType === 'pie') {
        this.buildPieCharts()
      } else if (this.chartType === 'bar') {
        this.buildBarCharts()
      } else if (this.chartType === 'line') {
        this.buildLineCharts()
      }
    }
    .width('100%')
  }

  @Builder
  buildPieCharts() {
    Column() {
      // 支出饼图
      if (this.expenseCategories.length > 0) {
        Column() {
          Text('支出分类分布')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
            .margin({ bottom: 16 })

          // 饼图可视化（使用圆形进度条模拟）
          Stack() {
            ForEach(this.expenseCategories.slice(0, 5), (cat: CategorySummary, index: number) => {
              Progress({
                value: cat.percentage,
                total: 100,
                type: ProgressType.Ring
              })
                .width(180 - index * 20)
                .height(180 - index * 20)
                .color(cat.color)
                .style({ strokeWidth: 15 })
            }, (cat: CategorySummary) => cat.category)
          }
          .width('100%')
          .height(180)
          .alignContent(Alignment.Center)
          .margin({ bottom: 16 })

          // 图例
          Column() {
            ForEach(this.expenseCategories, (cat: CategorySummary) => {
              Row() {
                Row()
                  .width(12)
                  .height(12)
                  .backgroundColor(cat.color)
                  .borderRadius(2)
                  .margin({ right: 8 })

                Text(cat.category)
                  .fontSize(14)
                  .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
                  .layoutWeight(1)

                Text(`${cat.percentage.toFixed(1)}%`)
                  .fontSize(12)
                  .fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
                  .margin({ right: 8 })

                Text(`¥${cat.amount.toFixed(2)}`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getColorScheme().LIST_ITEM.amountExpenseColor)
              }
              .width('100%')
              .padding(12)
              .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
              .borderRadius(8)
              .margin({ bottom: 8 })
            }, (cat: CategorySummary) => cat.category)
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor(this.getColorScheme().CHART_CONTAINER.backgroundColor)
        .borderRadius(8)
        .margin({ bottom: 16 })
      }

      // 收入饼图
      if (this.incomeCategories.length > 0) {
        Column() {
          Text('收入分类分布')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
            .margin({ bottom: 16 })

          // 饼图可视化
          Stack() {
            ForEach(this.incomeCategories.slice(0, 5), (cat: CategorySummary, index: number) => {
              Progress({
                value: cat.percentage,
                total: 100,
                type: ProgressType.Ring
              })
                .width(180 - index * 20)
                .height(180 - index * 20)
                .color(cat.color)
                .style({ strokeWidth: 15 })
            }, (cat: CategorySummary) => cat.category)
          }
          .width('100%')
          .height(180)
          .alignContent(Alignment.Center)
          .margin({ bottom: 16 })

          // 图例
          Column() {
            ForEach(this.incomeCategories, (cat: CategorySummary) => {
              Row() {
                Row()
                  .width(12)
                  .height(12)
                  .backgroundColor(cat.color)
                  .borderRadius(2)
                  .margin({ right: 8 })

                Text(cat.category)
                  .fontSize(14)
                  .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
                  .layoutWeight(1)

                Text(`${cat.percentage.toFixed(1)}%`)
                  .fontSize(12)
                  .fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
                  .margin({ right: 8 })

                Text(`¥${cat.amount.toFixed(2)}`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getColorScheme().LIST_ITEM.amountIncomeColor)
              }
              .width('100%')
              .padding(12)
              .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
              .borderRadius(8)
              .margin({ bottom: 8 })
            }, (cat: CategorySummary) => cat.category)
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor(this.getColorScheme().CHART_CONTAINER.backgroundColor)
        .borderRadius(8)
      }

      // 无数据提示
      if (this.expenseCategories.length === 0 && this.incomeCategories.length === 0) {
        Column() {
          Text('暂无数据')
            .fontSize(14)
            .fontColor(this.getColorScheme().CHART_CONTAINER.emptyTextColor)
            .padding(40)
        }
        .width('100%')
        .backgroundColor(this.getColorScheme().CHART_CONTAINER.backgroundColor)
        .borderRadius(8)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
  }

  @Builder
  buildBarCharts() {
    Column() {
      // 支出柱状图
      if (this.expenseCategories.length > 0) {
        Column() {
          Text('支出分类对比')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
            .margin({ bottom: 16 })

          ForEach(this.expenseCategories, (cat: CategorySummary) => {
            Column() {
              Row() {
                Text(cat.category)
                  .fontSize(14)
                  .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
                  .width(60)

                Column() {
                  Row()
                    .width(`${cat.percentage}%`)
                    .height(24)
                    .backgroundColor(cat.color)
                    .borderRadius(4)
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Text(`¥${cat.amount.toFixed(2)}`)
                  .fontSize(12)
                  .fontColor(this.getColorScheme().LIST_ITEM.amountExpenseColor)
                  .fontWeight(FontWeight.Bold)
                  .margin({ left: 8 })
                  .width(80)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
            }
            .width('100%')
            .margin({ bottom: 12 })
          }, (cat: CategorySummary) => cat.category)
        }
        .width('100%')
        .padding(16)
        .backgroundColor(this.getColorScheme().CHART_CONTAINER.backgroundColor)
        .borderRadius(8)
        .margin({ bottom: 16 })
      }

      // 收入柱状图
      if (this.incomeCategories.length > 0) {
        Column() {
          Text('收入分类对比')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
            .margin({ bottom: 16 })

          ForEach(this.incomeCategories, (cat: CategorySummary) => {
            Column() {
              Row() {
                Text(cat.category)
                  .fontSize(14)
                  .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
                  .width(60)

                Column() {
                  Row()
                    .width(`${cat.percentage}%`)
                    .height(24)
                    .backgroundColor(cat.color)
                    .borderRadius(4)
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Text(`¥${cat.amount.toFixed(2)}`)
                  .fontSize(12)
                  .fontColor(this.getColorScheme().LIST_ITEM.amountIncomeColor)
                  .fontWeight(FontWeight.Bold)
                  .margin({ left: 8 })
                  .width(80)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
            }
            .width('100%')
            .margin({ bottom: 12 })
          }, (cat: CategorySummary) => cat.category)
        }
        .width('100%')
        .padding(16)
        .backgroundColor(this.getColorScheme().CHART_CONTAINER.backgroundColor)
        .borderRadius(8)
      }

      // 无数据提示
      if (this.expenseCategories.length === 0 && this.incomeCategories.length === 0) {
        Column() {
          Text('暂无数据')
            .fontSize(14)
            .fontColor(this.getColorScheme().CHART_CONTAINER.emptyTextColor)
            .padding(40)
        }
        .width('100%')
        .backgroundColor(this.getColorScheme().CHART_CONTAINER.backgroundColor)
        .borderRadius(8)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
  }

  @Builder
  buildLineCharts() {
    Column() {
      // 收支趋势图
      Column() {
        Text('收支趋势')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
          .margin({ bottom: 16 })

        // 图例
        Row() {
          Row() {
            Row()
              .width(12)
              .height(3)
              .backgroundColor(this.getColorScheme().STAT_CARD.incomeColor)
              .margin({ right: 4 })
            Text('收入')
              .fontSize(12)
              .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
          }
          .margin({ right: 20 })

          Row() {
            Row()
              .width(12)
              .height(3)
              .backgroundColor(this.getColorScheme().STAT_CARD.expenseColor)
              .margin({ right: 4 })
            Text('支出')
              .fontSize(12)
              .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 16 })

        // 折线图区域
        if (this.trendLabels.length > 0) {
          Column() {
            // 图表主体
            Row() {
              // Y轴标签
              Column() {
                ForEach([4, 3, 2, 1, 0], (level: number) => {
                  Text(this.getYAxisLabel(level))
                    .fontSize(10)
                    .fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
                    .height(30)
                    .textAlign(TextAlign.End)
                }, (level: number) => level.toString())
              }
              .width(50)
              .alignItems(HorizontalAlign.End)
              .margin({ right: 8 })

              // 图表区域
              Stack() {
                // 网格线
                Column() {
                  ForEach([0, 1, 2, 3, 4], (line: number) => {
                    Row()
                      .width('100%')
                      .height(1)
                      .backgroundColor(this.getColorScheme().PROGRESS_CHART.trackColor)
                      .margin({ bottom: line < 4 ? 29 : 0 })
                  }, (line: number) => line.toString())
                }
                .height(150)
                .width('100%')

                // 使用Canvas绘制折线和点
                Canvas(this.chartContext)
                  .width('100%')
                  .height(150)
                  .onReady(() => {
                    this.drawLineChart();
                  })
              }
              .layoutWeight(1)
              .height(150)
            }
            .width('100%')
            .height(150)

            // X轴标签
            Row() {
              Row().width(58) // Y轴标签宽度 + margin

              Row() {
                ForEach(this.trendLabels, (label: string) => {
                  Text(label)
                    .fontSize(10)
                    .fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
                    .layoutWeight(1)
                    .textAlign(TextAlign.Center)
                    .maxLines(1)
                }, (label: string) => label)
              }
              .layoutWeight(1)
            }
            .width('100%')
            .margin({ top: 8 })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 数据表格
          Column() {
            // 表头
            Row() {
              Text('时间')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
                .width('30%')
                .textAlign(TextAlign.Center)
              Text('收入')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.getColorScheme().STAT_CARD.incomeColor)
                .width('35%')
                .textAlign(TextAlign.Center)
              Text('支出')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.getColorScheme().STAT_CARD.expenseColor)
                .width('35%')
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            .padding(8)
            .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
            .borderRadius(4)
            .margin({ bottom: 4 })

            // 数据行
            ForEach(this.trendLabels, (label: string, index: number) => {
              Row() {
                Text(label)
                  .fontSize(11)
                  .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
                  .width('30%')
                  .textAlign(TextAlign.Center)
                Text(`¥${this.trendIncomeData[index].toFixed(0)}`)
                  .fontSize(11)
                  .fontColor(this.getColorScheme().STAT_CARD.incomeColor)
                  .width('35%')
                  .textAlign(TextAlign.Center)
                Text(`¥${this.trendExpenseData[index].toFixed(0)}`)
                  .fontSize(11)
                  .fontColor(this.getColorScheme().STAT_CARD.expenseColor)
                  .width('35%')
                  .textAlign(TextAlign.Center)
              }
              .width('100%')
              .padding(6)
              .margin({ bottom: 2 })
            }, (label: string, index: number) => `table_${label}_${index}`)
          }
          .width('100%')
        } else {
          // 无数据提示
          Column() {
            Text('暂无趋势数据')
              .fontSize(14)
              .fontColor(this.getColorScheme().CHART_CONTAINER.emptyTextColor)
              .padding(40)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor(this.getColorScheme().CHART_CONTAINER.backgroundColor)
      .borderRadius(8)
    }
    .width('100%')
  }

  // 获取Y轴标签
  getYAxisLabel(level: number): string {
    const maxValue = Math.max(...this.trendIncomeData, ...this.trendExpenseData);
    if (maxValue === 0) return '0';

    const value = (maxValue / 4) * level;
    if (value >= 10000) {
      return `${(value / 10000).toFixed(1)}万`;
    } else if (value >= 1000) {
      return `${(value / 1000).toFixed(1)}k`;
    } else {
      return value.toFixed(0);
    }
  }

  // 获取柱状图高度
  getBarHeight(value: number): number {
    const maxValue = Math.max(...this.trendIncomeData, ...this.trendExpenseData);
    if (maxValue === 0) return 0;
    return Math.max(2, (value / maxValue) * 120); // 最小高度2，最大高度120
  }

  // 绘制折线图
  drawLineChart() {
    if (!this.chartContext || this.trendLabels.length === 0) return;
    
    const ctx = this.chartContext;
    const width = ctx.width;
    const height = 150;
    const totalPoints = this.trendLabels.length;
    
    // 清空画布
    ctx.clearRect(0, 0, width, height);
    
    if (totalPoints < 2) return;
    
    const pointSpacing = width / (totalPoints - 1);
    
    // 绘制收入折线
    ctx.beginPath();
    ctx.strokeStyle = this.getColorScheme().STAT_CARD.incomeColor;
    ctx.lineWidth = 2.5;
    ctx.lineJoin = 'round';
    ctx.lineCap = 'round';
    
    let hasIncomeData = false;
    for (let i = 0; i < totalPoints; i++) {
      const x = i * pointSpacing;
      const y = height - this.getBarHeight(this.trendIncomeData[i]);
      
      if (i === 0) {
        ctx.moveTo(x, y);
      } else {
        ctx.lineTo(x, y);
      }
      
      if (this.trendIncomeData[i] > 0) {
        hasIncomeData = true;
      }
    }
    
    if (hasIncomeData) {
      ctx.stroke();
    }
    
    // 绘制支出折线
    ctx.beginPath();
    ctx.strokeStyle = this.getColorScheme().STAT_CARD.expenseColor;
    ctx.lineWidth = 2.5;
    
    let hasExpenseData = false;
    for (let i = 0; i < totalPoints; i++) {
      const x = i * pointSpacing;
      const y = height - this.getBarHeight(this.trendExpenseData[i]);
      
      if (i === 0) {
        ctx.moveTo(x, y);
      } else {
        ctx.lineTo(x, y);
      }
      
      if (this.trendExpenseData[i] > 0) {
        hasExpenseData = true;
      }
    }
    
    if (hasExpenseData) {
      ctx.stroke();
    }
    
    // 绘制数据点
    for (let i = 0; i < totalPoints; i++) {
      const x = i * pointSpacing;
      
      // 收入数据点
      if (this.trendIncomeData[i] > 0) {
        const y = height - this.getBarHeight(this.trendIncomeData[i]);
        ctx.beginPath();
        ctx.arc(x, y, 4, 0, 2 * Math.PI);
        ctx.fillStyle = this.getColorScheme().STAT_CARD.incomeColor;
        ctx.fill();
        ctx.strokeStyle = '#FFFFFF';
        ctx.lineWidth = 2;
        ctx.stroke();
      }
      
      // 支出数据点
      if (this.trendExpenseData[i] > 0) {
        const y = height - this.getBarHeight(this.trendExpenseData[i]);
        ctx.beginPath();
        ctx.arc(x, y, 4, 0, 2 * Math.PI);
        ctx.fillStyle = this.getColorScheme().STAT_CARD.expenseColor;
        ctx.fill();
        ctx.strokeStyle = '#FFFFFF';
        ctx.lineWidth = 2;
        ctx.stroke();
      }
    }
  }
}
