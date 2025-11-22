import { AccountRecord, CategorySummary } from '../models/AccountRecord';
import { AccountViewModel } from '../viewmodel/AccountViewModel';
import { COLORS } from '../constants/Constants';
import { DateUtil } from '../utils/DateUtil';
import { StorageUtil } from '../utils/StorageUtil';
import router from '@ohos.router';

@Entry
@Component
struct ChartPageEntry {
  @State records: AccountRecord[] = [];
  @State viewModel: AccountViewModel = new AccountViewModel();
  @State selectedMonth: string = DateUtil.getThisMonthStr();
  @State expenseCategories: CategorySummary[] = [];
  @State incomeCategories: CategorySummary[] = [];

  aboutToAppear() {
    StorageUtil.setContext(getContext(this));
    this.loadRecords();
  }

  async loadRecords() {
    this.records = await StorageUtil.getRecords();
    this.viewModel.records = this.records;
    this.updateCharts();
  }

  updateCharts() {
    this.expenseCategories = this.viewModel.getCategorySummary('expense', this.selectedMonth);
    this.incomeCategories = this.viewModel.getCategorySummary('income', this.selectedMonth);
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Text('←')
            .fontSize(20)
            .fontColor(COLORS.text)
        }
        .width(36)
        .height(36)
        .backgroundColor(COLORS.background)
        .onClick(() => {
          router.back();
        })

        Text('统计')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLORS.text)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row()
          .width(36)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor('#FFFFFF')

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
      .margin({ left: 16, right: 16, top: 12, bottom: 12 })

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
          .margin({ left: 16, right: 16, bottom: 16 })

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
          .margin({ left: 16, right: 16, bottom: 16 })

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
          .margin({ left: 16, right: 16 })
        }
        .width('100%')
        .padding(16)
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLORS.background)
  }

  @Builder
  buildPieChart(categories: CategorySummary[], type: string) {
    Column() {
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
