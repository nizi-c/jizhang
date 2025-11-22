import { AccountRecord } from '../models/AccountRecord';
import { AccountViewModel } from '../viewmodel/AccountViewModel';
import { StorageUtil } from '../utils/StorageUtil';
import { DateUtil } from '../utils/DateUtil';
import { COLORS } from '../constants/Constants';
import router from '@ohos.router';
import { QueryPage } from './QueryPage';
import { ChartPage } from './ChartPage';

@Entry
@Component
struct Index {
  @State todayIncome: number = 0;
  @State todayExpense: number = 0;
  @State monthIncome: number = 0;
  @State monthExpense: number = 0;
  @State records: AccountRecord[] = [];
  @State viewModel: AccountViewModel = new AccountViewModel();
  menuDialogController: CustomDialogController | undefined = undefined;

  aboutToAppear() {
    StorageUtil.setContext(getContext(this));
    this.loadRecords();
  }

  onPageShow() {
    this.loadRecords();
  }

  async loadRecords() {
    this.records = await StorageUtil.getRecords();
    this.viewModel.records = this.records;
    this.updateSummary();
  }

  updateSummary() {
    const today = this.viewModel.getTodaySummary();
    this.todayIncome = today.income;
    this.todayExpense = today.expense;

    const month = this.viewModel.getMonthSummary();
    this.monthIncome = month.income;
    this.monthExpense = month.expense;
  }

  openMenuDialog() {
    let self = this;
    this.menuDialogController = new CustomDialogController({
      builder: () => {
        self.buildMenuDialog();
      },
      autoCancel: true,
      alignment: DialogAlignment.Center,
      customStyle: true
    });
    this.menuDialogController?.open();
  }

  @Builder
  buildMenuDialog() {
    Column() {
      Button('添加账单')
        .width('100%')
        .height(44)
        .backgroundColor('#FFFFFF')
        .fontColor(COLORS.primary)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.menuDialogController?.close();
          router.pushUrl({ url: 'pages/AddRecordPage' });
        })

      Divider()
        .strokeWidth(1)
        .color(COLORS.border)

      Button('流水')
        .width('100%')
        .height(44)
        .backgroundColor('#FFFFFF')
        .fontColor(COLORS.text)
        .onClick(() => {
          this.menuDialogController?.close();
          router.pushUrl({ url: 'pages/RecordsPage' });
        })

      Divider()
        .strokeWidth(1)
        .color(COLORS.border)

      Button('统计')
        .width('100%')
        .height(44)
        .backgroundColor('#FFFFFF')
        .fontColor(COLORS.text)
        .onClick(() => {
          this.menuDialogController?.close();
          router.pushUrl({ url: 'pages/ChartPageEntry' });
        })
    }
    .width('70%')
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('记账本')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLORS.text)
        Row()
          .layoutWeight(1)
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Text('⋮')
            .fontSize(24)
            .fontColor(COLORS.text)
        }
        .width(44)
        .height(44)
        .backgroundColor(COLORS.background)
        .onClick(() => {
          this.openMenuDialog();
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor('#FFFFFF')

      // 首页内容
      this.buildHomeTab()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLORS.background)
  }



  @Builder
  buildHomeTab() {
    Column() {
      // 今日统计卡片
      Column() {
        Text('今日收支')
          .fontSize(14)
          .fontColor(COLORS.textLight)
          .margin({ bottom: 12 })

        Row() {
          Column() {
            Text('收入')
              .fontSize(12)
              .fontColor(COLORS.textLight)
              .margin({ bottom: 4 })
            Text(`¥${this.todayIncome.toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#6BCB77')
          }
          .layoutWeight(1)

          Column() {
            Text('支出')
              .fontSize(12)
              .fontColor(COLORS.textLight)
              .margin({ bottom: 4 })
            Text(`¥${this.todayExpense.toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(COLORS.primary)
          }
          .layoutWeight(1)

          Column() {
            Text('结余')
              .fontSize(12)
              .fontColor(COLORS.textLight)
              .margin({ bottom: 4 })
            Text(`¥${(this.todayIncome - this.todayExpense).toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.todayIncome - this.todayExpense >= 0 ? '#6BCB77' : COLORS.primary)
          }
          .layoutWeight(1)
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ left: 16, right: 16, top: 16, bottom: 12 })

      // 本月统计卡片
      Column() {
        Text('本月收支')
          .fontSize(14)
          .fontColor(COLORS.textLight)
          .margin({ bottom: 12 })

        Row() {
          Column() {
            Text('收入')
              .fontSize(12)
              .fontColor(COLORS.textLight)
              .margin({ bottom: 4 })
            Text(`¥${this.monthIncome.toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#6BCB77')
          }
          .layoutWeight(1)

          Column() {
            Text('支出')
              .fontSize(12)
              .fontColor(COLORS.textLight)
              .margin({ bottom: 4 })
            Text(`¥${this.monthExpense.toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(COLORS.primary)
          }
          .layoutWeight(1)

          Column() {
            Text('结余')
              .fontSize(12)
              .fontColor(COLORS.textLight)
              .margin({ bottom: 4 })
            Text(`¥${(this.monthIncome - this.monthExpense).toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.monthIncome - this.monthExpense >= 0 ? '#6BCB77' : COLORS.primary)
          }
          .layoutWeight(1)
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ left: 16, right: 16, bottom: 12 })

      // 最近记录
      Column() {
        Text('最近记录')
          .fontSize(14)
          .fontColor(COLORS.textLight)
          .margin({ bottom: 12 })

        if (this.records.length === 0) {
          Text('暂无记录')
            .fontSize(14)
            .fontColor(COLORS.textLight)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(20)
        } else {
          List() {
            ForEach(this.records.slice(0, 5), (record: AccountRecord) => {
              ListItem() {
                this.buildRecordItem(record)
              }
            }, (record: AccountRecord) => record.id)
          }
          .width('100%')
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 1, color: COLORS.border })
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .padding({ bottom: 16 })
  }



  @Builder
  buildRecordItem(record: AccountRecord) {
    Row() {
      Column() {
        Text(record.category)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLORS.text)
        Text(record.description)
          .fontSize(12)
          .fontColor(COLORS.textLight)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(`${record.type === 'income' ? '+' : '-'}¥${record.amount.toFixed(2)}`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(record.type === 'income' ? '#6BCB77' : COLORS.primary)
        Text(record.dateStr)
          .fontSize(12)
          .fontColor(COLORS.textLight)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
  }

  @Builder
  buildRecordItemWithSwipe(record: AccountRecord) {
    Swiper() {
      this.buildRecordItem(record)

      Button('删除')
        .width('100%')
        .height('100%')
        .backgroundColor(COLORS.primary)
        .fontColor('#FFFFFF')
        .onClick(() => {
          this.viewModel.deleteRecord(record.id);
          this.records = this.records.filter(r => r.id !== record.id);
          this.updateSummary();
        })
    }
    .indicator(false)
  }


}
