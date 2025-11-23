import { AccountRecord, CategorySummary } from '../models/AccountRecord';
import { AccountViewModel } from '../viewmodel/AccountViewModel';
import { COLORS } from '../constants/Constants';
import { DateUtil } from '../utils/DateUtil';
import { ThemeUtil } from '../utils/ThemeUtil';

@Component
export struct ChartPage {
  // 修复：为属性提供默认值
  records: AccountRecord[] = [];
  viewModel: AccountViewModel = new AccountViewModel();

  @State selectedMonth: string = DateUtil.getThisMonthStr();
  @State expenseCategories: CategorySummary[] = [];
  @State incomeCategories: CategorySummary[] = [];

  aboutToAppear() {
    this.updateCharts();
  }

  updateCharts() {
    this.expenseCategories = this.viewModel.getCategorySummary('expense', this.selectedMonth);
    this.incomeCategories = this.viewModel.getCategorySummary('income', this.selectedMonth);
  }

  build() {
    Column() {
      // 月份选择
      Row() {
        Button('<')
          .width(40)
          .height(36)
          .backgroundColor(COLORS.background)
          .fontColor(COLORS.text)
          .onClick(() => {
            this.previousMonth();
          })

        Row()
          .layoutWeight(1)

        Text(this.selectedMonth)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLORS.text)

        Row()
          .layoutWeight(1)

        Button('>')
          .width(40)
          .height(36)
          .backgroundColor(COLORS.background)
          .fontColor(COLORS.text)
          .onClick(() => {
            this.nextMonth();
          })
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(8)
      .margin({ bottom: 16 })

      Scroll() {
        Column() {
          // 支出饼图
          Column() {
            Text('支出分类分布')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(COLORS.text)
              .margin({ bottom: 12 })

            if (this.expenseCategories.length === 0) {
              Text('暂无数据')
                .fontSize(12)
                .fontColor(COLORS.textLight)
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding(20)
            } else {
              this.buildPieChart(this.expenseCategories, 'expense')
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .margin({ bottom: 16 })

          // 收入饼图
          Column() {
            Text('收入分类分布')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(COLORS.text)
              .margin({ bottom: 12 })

            if (this.incomeCategories.length === 0) {
              Text('暂无数据')
                .fontSize(12)
                .fontColor(COLORS.textLight)
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding(20)
            } else {
              this.buildPieChart(this.incomeCategories, 'income')
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .margin({ bottom: 16 })

          // 详细列表
          Column() {
            Text('详细统计')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(COLORS.text)
              .margin({ bottom: 12 })

            Column() {
              Text('支出')
                .fontSize(12)
                .fontColor(COLORS.textLight)
                .margin({ bottom: 8 })

              ForEach(this.expenseCategories, (item: CategorySummary) => {
                Row() {
                  Text(item.category)
                    .fontSize(12)
                    .fontColor(COLORS.text)
                    .layoutWeight(1)
                  Text(`¥${item.amount.toFixed(2)}`)
                    .fontSize(12)
                    .fontColor(COLORS.primary)
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')
                .padding(8)
                .backgroundColor(COLORS.background)
                .borderRadius(4)
                .margin({ bottom: 6 })
              }, (item: CategorySummary) => item.category)

              Text('收入')
                .fontSize(12)
                .fontColor(COLORS.textLight)
                .margin({ bottom: 8, top: 16 })

              ForEach(this.incomeCategories, (item: CategorySummary) => {
                Row() {
                  Text(item.category)
                    .fontSize(12)
                    .fontColor(COLORS.text)
                    .layoutWeight(1)
                  Text(`¥${item.amount.toFixed(2)}`)
                    .fontSize(12)
                    .fontColor('#6BCB77')
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')
                .padding(8)
                .backgroundColor(COLORS.background)
                .borderRadius(4)
                .margin({ bottom: 6 })
              }, (item: CategorySummary) => item.category)
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
        }
        .width('100%')
        .padding(16)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLORS.background)
  }

  @Builder
  buildPieChart(categories: CategorySummary[], type: string) {
    Column() {
      // 简单的饼图表示（使用进度条模拟）
      ForEach(categories, (item: CategorySummary) => {
        Column() {
          Row() {
            Text(item.category)
              .fontSize(12)
              .fontColor(COLORS.text)
              .layoutWeight(1)
            Text(`${item.percentage.toFixed(1)}%`)
              .fontSize(12)
              .fontColor(COLORS.textLight)
          }
          .width('100%')
          .margin({ bottom: 6 })

          Row() {
            Progress({
              value: item.percentage,
              total: 100,
              type: ProgressType.Linear
            })
              .width('100%')
              .height(6)
              .color(type === 'expense' ? COLORS.primary : '#6BCB77')
              .backgroundColor(COLORS.background)
              .borderRadius(3)
          }
          .width('100%')
        }
        .width('100%')
        .margin({ bottom: 12 })
      }, (item: CategorySummary) => item.category)
    }
    .width('100%')
    .height('100%')
    .backgroundImage(ThemeUtil.getBackgroundImage(ThemeUtil.getTheme()))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
  }

  private previousMonth() {
    const parts: string[] = this.selectedMonth.split('-');
    const year: string = parts[0];
    const month: string = parts[1];
    let m: number = parseInt(month) - 1;
    let y: number = parseInt(year);
    if (m === 0) {
      m = 12;
      y--;
    }
    this.selectedMonth = `${y}-${String(m).padStart(2, '0')}`;
    this.updateCharts();
  }

  private nextMonth() {
    const parts: string[] = this.selectedMonth.split('-');
    const year: string = parts[0];
    const month: string = parts[1];
    let m: number = parseInt(month) + 1;
    let y: number = parseInt(year);
    if (m === 13) {
      m = 1;
      y++;
    }
    this.selectedMonth = `${y}-${String(m).padStart(2, '0')}`;
    this.updateCharts();
  }
}