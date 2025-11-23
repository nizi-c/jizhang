import { AccountRecord } from '../models/AccountRecord';
import { AccountViewModel } from '../viewmodel/AccountViewModel';
import { StorageUtil } from '../utils/StorageUtil';
import { DateUtil } from '../utils/DateUtil';
import { COLORS, DynamicColors, ColorScheme } from '../constants/Constants';
import { LIGHT_COLOR_SCHEME, DARK_COLOR_SCHEME } from '../constants/ColorSchemes';
import { ThemeUtil, ThemeType, ThemeColors } from '../utils/ThemeUtil';
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
  @State currentTheme: ThemeType = 'light';
  @State colors: ThemeColors = ThemeUtil.LIGHT_THEME;
  menuDialogController: CustomDialogController | undefined = undefined;

  aboutToAppear() {
    StorageUtil.setContext(getContext(this));
    ThemeUtil.initTheme().then(() => {
      this.currentTheme = ThemeUtil.getTheme();
      this.colors = ThemeUtil.getColors();
    });
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

  getColorScheme() {
    return this.currentTheme === 'light' ? LIGHT_COLOR_SCHEME : DARK_COLOR_SCHEME;
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
      Button() {
        Row() {
          Image($r('app.media.tianjia'))
            .width(24)
            .height(24)
            .margin({ right: 8 })
          Text('添加账单')
            .fontColor(this.colors.primary)
            .fontWeight(FontWeight.Bold)
        }
      }
      .width('100%')
      .height(44)
      .backgroundColor(this.colors.cardBg)
      .onClick(() => {
        this.menuDialogController?.close();
        router.pushUrl({ url: 'pages/AddRecordPage' });
      })

      Divider()
        .strokeWidth(1)
        .color(this.colors.border)

      Button() {
        Row() {
          Image($r('app.media.liushui'))
            .width(24)
            .height(24)
            .margin({ right: 8 })
          Text('流水')
            .fontColor(this.colors.textPrimary)
        }
      }
      .width('100%')
      .height(44)
      .backgroundColor(this.colors.cardBg)
      .onClick(() => {
        this.menuDialogController?.close();
        router.pushUrl({ url: 'pages/RecordsPage' });
      })

      Divider()
        .strokeWidth(1)
        .color(this.colors.border)

      Button() {
        Row() {
          Image($r('app.media.tongji'))
            .width(24)
            .height(24)
            .margin({ right: 8 })
          Text('统计')
            .fontColor(this.colors.textPrimary)
        }
      }
      .width('100%')
      .height(44)
      .backgroundColor(this.colors.cardBg)
      .onClick(() => {
        this.menuDialogController?.close();
        router.pushUrl({ url: 'pages/ChartPageEntry' });
      })

      Divider()
        .strokeWidth(1)
        .color(this.colors.border)

      Button() {
        Row() {
          Image(this.currentTheme === 'light' ? $r('app.media.moon') : $r('app.media.sun'))
            .width(24)
            .height(24)
            .margin({ right: 8 })
          Text(this.currentTheme === 'light' ? '深色模式' : '浅色模式')
            .fontColor(this.colors.textPrimary)
        }
      }
      .width('100%')
      .height(44)
      .backgroundColor(this.colors.cardBg)
      .onClick(() => {
        this.currentTheme = ThemeUtil.toggleTheme();
        this.colors = ThemeUtil.getColors();
        this.menuDialogController?.close();
      })
    }
    .width('70%')
    .backgroundColor(this.colors.cardBg)
    .borderRadius(8)
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('记账本')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().NAVBAR.titleColor)
        Row()
          .layoutWeight(1)
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Text('⋮')
            .fontSize(24)
            .fontColor(this.getColorScheme().NAVBAR.titleColor)
        }
        .width(44)
        .height(44)
        .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
        .onClick(() => {
          this.openMenuDialog();
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
      .border({ width: { bottom: 1 }, color: this.getColorScheme().NAVBAR.borderColor })

      // 首页内容
      this.buildHomeTab()
    }
    .width('100%')
    .height('100%')
    .backgroundImage(ThemeUtil.getBackgroundImage(this.currentTheme))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
  }



  @Builder
  buildHomeTab() {
    Column() {
      // 今日统计卡片
      Column() {
        Text('今日收支')
          .fontSize(14)
          .fontColor(this.getColorScheme().STAT_CARD.titleColor)
          .margin({ bottom: 12 })

        Row() {
          Column() {
            Text('收入')
              .fontSize(12)
              .fontColor(this.getColorScheme().STAT_CARD.labelColor)
              .margin({ bottom: 4 })
            Text(`¥${this.todayIncome.toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.getColorScheme().STAT_CARD.incomeColor)
          }
          .layoutWeight(1)

          Column() {
            Text('支出')
              .fontSize(12)
              .fontColor(this.getColorScheme().STAT_CARD.labelColor)
              .margin({ bottom: 4 })
            Text(`¥${this.todayExpense.toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.getColorScheme().STAT_CARD.expenseColor)
          }
          .layoutWeight(1)

          Column() {
            Text('结余')
              .fontSize(12)
              .fontColor(this.getColorScheme().STAT_CARD.labelColor)
              .margin({ bottom: 4 })
            Text(`¥${(this.todayIncome - this.todayExpense).toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.todayIncome - this.todayExpense >= 0 ? this.getColorScheme().STAT_CARD.incomeColor : this.getColorScheme().STAT_CARD.expenseColor)
          }
          .layoutWeight(1)
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor(this.getColorScheme().STAT_CARD.backgroundColor)
      .borderRadius(12)
      .margin({ left: 16, right: 16, top: 16, bottom: 12 })
      .shadow({ radius: 8, color: this.getColorScheme().STAT_CARD.shadowColor })

      // 本月统计卡片
      Column() {
        Text('本月收支')
          .fontSize(14)
          .fontColor(this.getColorScheme().STAT_CARD.titleColor)
          .margin({ bottom: 12 })

        Row() {
          Column() {
            Text('收入')
              .fontSize(12)
              .fontColor(this.getColorScheme().STAT_CARD.labelColor)
              .margin({ bottom: 4 })
            Text(`¥${this.monthIncome.toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.getColorScheme().STAT_CARD.incomeColor)
          }
          .layoutWeight(1)

          Column() {
            Text('支出')
              .fontSize(12)
              .fontColor(this.getColorScheme().STAT_CARD.labelColor)
              .margin({ bottom: 4 })
            Text(`¥${this.monthExpense.toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.getColorScheme().STAT_CARD.expenseColor)
          }
          .layoutWeight(1)

          Column() {
            Text('结余')
              .fontSize(12)
              .fontColor(this.getColorScheme().STAT_CARD.labelColor)
              .margin({ bottom: 4 })
            Text(`¥${(this.monthIncome - this.monthExpense).toFixed(2)}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.monthIncome - this.monthExpense >= 0 ? this.getColorScheme().STAT_CARD.incomeColor : this.getColorScheme().STAT_CARD.expenseColor)
          }
          .layoutWeight(1)
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor(this.getColorScheme().STAT_CARD.backgroundColor)
      .borderRadius(12)
      .margin({ left: 16, right: 16, bottom: 12 })
      .shadow({ radius: 8, color: this.getColorScheme().STAT_CARD.shadowColor })

      // 最近记录
      Column() {
        Text('最近记录')
          .fontSize(14)
          .fontColor(this.getColorScheme().RECENT_LIST.categoryColor)
          .margin({ bottom: 12 })

        if (this.records.length === 0) {
          Text('暂无记录')
            .fontSize(14)
            .fontColor(this.getColorScheme().RECENT_LIST.descriptionColor)
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
          .divider({ strokeWidth: 1, color: this.getColorScheme().RECENT_LIST.dividerColor })
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor(this.getColorScheme().RECENT_LIST.backgroundColor)
      .borderRadius(12)
      .margin({ left: 16, right: 16 })
      .shadow({ radius: 8, color: this.getColorScheme().STAT_CARD.shadowColor })
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
          .fontColor(this.getColorScheme().RECENT_LIST.categoryColor)
        Text(record.description)
          .fontSize(12)
          .fontColor(this.getColorScheme().RECENT_LIST.descriptionColor)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(`${record.type === 'income' ? '+' : '-'}¥${record.amount.toFixed(2)}`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(record.type === 'income' ? this.getColorScheme().RECENT_LIST.incomeAmountColor : this.getColorScheme().RECENT_LIST.expenseAmountColor)
        Text(record.dateStr)
          .fontSize(12)
          .fontColor(this.getColorScheme().RECENT_LIST.dateColor)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(this.getColorScheme().RECENT_LIST.itemBackground)
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
