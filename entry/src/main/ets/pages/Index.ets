import { AccountRecord } from '../models/AccountRecord';
import { AccountViewModel } from '../viewmodel/AccountViewModel';
import { StorageUtil } from '../utils/StorageUtil';
import { DateUtil } from '../utils/DateUtil';
import { COLORS, DynamicColors, ColorScheme } from '../constants/Constants';
import { LIGHT_COLOR_SCHEME, DARK_COLOR_SCHEME } from '../constants/ColorSchemes';
import { ThemeUtil, ThemeType, ThemeColors } from '../utils/ThemeUtil';
import { MockData } from '../utils/MockData';
import { AccountBookUtil } from '../utils/AccountBookUtil';
import { ResponsiveUtil, DeviceType } from '../utils/ResponsiveUtil';
import { ResponsiveConstants } from '../constants/ResponsiveConstants';
import router from '@ohos.router';
import { QueryPage } from './QueryPage';
import { ChartPage } from './ChartPage';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';

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
  @State currentBookName: string = '默认账本';
  @State deviceType: DeviceType = ResponsiveUtil.getDeviceType();
  @State screenWidth: number = ResponsiveUtil.getScreenWidth();
  menuDialogController: CustomDialogController | undefined = undefined;

  async aboutToAppear() {
    const context = getContext(this);
    StorageUtil.setContext(context);
    
    // 初始化账本管理
    await AccountBookUtil.init(context as common.UIAbilityContext);
    
    ThemeUtil.initTheme().then(() => {
      this.currentTheme = ThemeUtil.getTheme();
      this.colors = ThemeUtil.getColors();
    });
    this.loadRecords();
  }

  async onPageShow() {
    await this.loadRecords();
    await this.loadCurrentBook();
  }

  async loadRecords() {
    this.records = await StorageUtil.getRecords();
    this.viewModel.records = this.records;
    this.updateSummary();
  }

  async loadCurrentBook() {
    const book = await AccountBookUtil.getCurrentBook();
    if (book) {
      this.currentBookName = book.name;
    }
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

  updateDeviceInfo() {
    this.deviceType = ResponsiveUtil.getDeviceType();
    this.screenWidth = ResponsiveUtil.getScreenWidth();
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
          Image($r('app.media.zhangben'))
            .width(ResponsiveConstants.getFontSize('body'))
            .height(ResponsiveConstants.getFontSize('body'))
            .margin({ right: ResponsiveConstants.getSpacing('small') })
          Text('账本管理')
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .fontColor(this.colors.primary)
            .fontWeight(FontWeight.Bold)
        }
      }
      .width('100%')
      .height(ResponsiveConstants.getButtonHeight('medium'))
      .backgroundColor(this.colors.cardBg)
      .onClick(() => {
        this.menuDialogController?.close();
        router.pushUrl({ url: 'pages/AccountBooksPage' });
      })

      Divider()
        .strokeWidth(1)
        .color(this.colors.border)

      Button() {
        Row() {
          Image($r('app.media.tianjia'))
            .width(ResponsiveConstants.getFontSize('body'))
            .height(ResponsiveConstants.getFontSize('body'))
            .margin({ right: ResponsiveConstants.getSpacing('small') })
          Text('添加账单')
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .fontColor(this.colors.textPrimary)
        }
      }
      .width('100%')
      .height(ResponsiveConstants.getButtonHeight('medium'))
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
            .width(ResponsiveConstants.getFontSize('body'))
            .height(ResponsiveConstants.getFontSize('body'))
            .margin({ right: ResponsiveConstants.getSpacing('small') })
          Text('流水')
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .fontColor(this.colors.textPrimary)
        }
      }
      .width('100%')
      .height(ResponsiveConstants.getButtonHeight('medium'))
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
            .width(ResponsiveConstants.getFontSize('body'))
            .height(ResponsiveConstants.getFontSize('body'))
            .margin({ right: ResponsiveConstants.getSpacing('small') })
          Text('统计')
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .fontColor(this.colors.textPrimary)
        }
      }
      .width('100%')
      .height(ResponsiveConstants.getButtonHeight('medium'))
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
          Image($r('app.media.yusuan'))
            .width(ResponsiveConstants.getFontSize('body'))
            .height(ResponsiveConstants.getFontSize('body'))
            .margin({ right: ResponsiveConstants.getSpacing('small') })
          Text('预算管理')
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .fontColor(this.colors.textPrimary)
        }
      }
      .width('100%')
      .height(ResponsiveConstants.getButtonHeight('medium'))
      .backgroundColor(this.colors.cardBg)
      .onClick(() => {
        this.menuDialogController?.close();
        router.pushUrl({ url: 'pages/BudgetPage' });
      })

      Divider()
        .strokeWidth(1)
        .color(this.colors.border)

      Button() {
        Row() {
          Image(this.currentTheme === 'light' ? $r('app.media.moon') : $r('app.media.sun'))
            .width(ResponsiveConstants.getFontSize('body'))
            .height(ResponsiveConstants.getFontSize('body'))
            .margin({ right: ResponsiveConstants.getSpacing('small') })
          Text(this.currentTheme === 'light' ? '深色模式' : '浅色模式')
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .fontColor(this.colors.textPrimary)
        }
      }
      .width('100%')
      .height(ResponsiveConstants.getButtonHeight('medium'))
      .backgroundColor(this.colors.cardBg)
      .onClick(() => {
        this.currentTheme = ThemeUtil.toggleTheme();
        this.colors = ThemeUtil.getColors();
        this.menuDialogController?.close();
      })

      Divider()
        .strokeWidth(1)
        .color(this.colors.border)

      Button() {
        Row() {
          Text('📊')
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .margin({ right: ResponsiveConstants.getSpacing('small') })
          Text('生成测试数据')
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .fontColor(this.colors.textPrimary)
        }
      }
      .width('100%')
      .height(ResponsiveConstants.getButtonHeight('medium'))
      .backgroundColor(this.colors.cardBg)
      .onClick(async () => {
        this.menuDialogController?.close();
        try {
          await MockData.generateMockData();
          promptAction.showToast({
            message: '已生成30天测试数据',
            duration: 2000
          });
          this.loadRecords();
        } catch (error) {
          promptAction.showToast({
            message: '生成数据失败',
            duration: 2000
          });
        }
      })
    }
    .width(ResponsiveUtil.isPhone() ? '85%' : '70%')
    .backgroundColor(this.colors.cardBg)
    .borderRadius(ResponsiveConstants.getBorderRadius('large'))
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Column() {
          Text('记账本')
            .fontSize(ResponsiveConstants.getFontSize('title'))
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().NAVBAR.titleColor)
          Text(this.currentBookName)
            .fontSize(ResponsiveConstants.getFontSize('caption'))
            .fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)
        
        Row()
          .layoutWeight(1)
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Text('⋮')
            .fontSize(ResponsiveConstants.getFontSize('title'))
            .fontColor(this.getColorScheme().NAVBAR.titleColor)
        }
        .width(ResponsiveConstants.getButtonHeight('medium'))
        .height(ResponsiveConstants.getButtonHeight('medium'))
        .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
        .onClick(() => {
          this.openMenuDialog();
        })
      }
      .width('100%')
      .padding({
        left: ResponsiveConstants.getPadding('medium'),
        right: ResponsiveConstants.getPadding('medium'),
        top: 8,
        bottom: 8
      })
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
    // 根据设备类型选择不同的布局
    if (ResponsiveUtil.isPhone()) {
      this.buildPhoneLayout();
    } else if (ResponsiveUtil.isTablet()) {
      this.buildTabletLayout();
    } else {
      this.buildLargeLayout();
    }
  }

  @Builder
  buildPhoneLayout() {
    // 手机布局：单列
    Column() {
      // 今日统计卡片
      this.buildStatCard('今日收支', this.todayIncome, this.todayExpense);
      
      // 本月统计卡片
      this.buildStatCard('本月收支', this.monthIncome, this.monthExpense);
      
      // 最近记录
      this.buildRecentRecords();
    }
    .width('100%')
    .padding({ bottom: ResponsiveConstants.getSpacing('large') })
  }

  @Builder
  buildTabletLayout() {
    // 平板布局：两列
    Column() {
      Row() {
        Column() {
          this.buildStatCard('今日收支', this.todayIncome, this.todayExpense);
        }
        .layoutWeight(1)
        .margin({ right: ResponsiveConstants.getSpacing('medium') })

        Column() {
          this.buildStatCard('本月收支', this.monthIncome, this.monthExpense);
        }
        .layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: ResponsiveConstants.getSpacing('large') })

      // 最近记录
      this.buildRecentRecords();
    }
    .width('100%')
    .padding({ bottom: ResponsiveConstants.getSpacing('large') })
  }

  @Builder
  buildLargeLayout() {
    // 大屏布局：三列或自适应
    Column() {
      Row() {
        Column() {
          this.buildStatCard('今日收支', this.todayIncome, this.todayExpense);
        }
        .layoutWeight(1)
        .margin({ right: ResponsiveConstants.getSpacing('large') })

        Column() {
          this.buildStatCard('本月收支', this.monthIncome, this.monthExpense);
        }
        .layoutWeight(1)
        .margin({ right: ResponsiveConstants.getSpacing('large') })

        Column() {
          this.buildRecentRecords();
        }
        .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding({ bottom: ResponsiveConstants.getSpacing('large') })
  }

  @Builder
  buildStatCard(title: string, income: number, expense: number) {
    Column() {
      Text(title)
        .fontSize(ResponsiveConstants.getFontSize('subtitle'))
        .fontColor(this.getColorScheme().STAT_CARD.titleColor)
        .margin({ bottom: ResponsiveConstants.getSpacing('medium') })

      Row() {
        Column() {
          Text('收入')
            .fontSize(ResponsiveConstants.getFontSize('caption'))
            .fontColor(this.getColorScheme().STAT_CARD.labelColor)
            .margin({ bottom: 4 })
          Text(`¥${income.toFixed(2)}`)
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().STAT_CARD.incomeColor)
        }
        .layoutWeight(1)

        Column() {
          Text('支出')
            .fontSize(ResponsiveConstants.getFontSize('caption'))
            .fontColor(this.getColorScheme().STAT_CARD.labelColor)
            .margin({ bottom: 4 })
          Text(`¥${expense.toFixed(2)}`)
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().STAT_CARD.expenseColor)
        }
        .layoutWeight(1)

        Column() {
          Text('结余')
            .fontSize(ResponsiveConstants.getFontSize('caption'))
            .fontColor(this.getColorScheme().STAT_CARD.labelColor)
            .margin({ bottom: 4 })
          Text(`¥${(income - expense).toFixed(2)}`)
            .fontSize(ResponsiveConstants.getFontSize('body'))
            .fontWeight(FontWeight.Bold)
            .fontColor(income >= expense ? 
              this.getColorScheme().STAT_CARD.incomeColor : 
              this.getColorScheme().STAT_CARD.expenseColor)
        }
        .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding(ResponsiveConstants.getPadding('medium'))
    .backgroundColor(this.getColorScheme().STAT_CARD.backgroundColor)
    .borderRadius(ResponsiveConstants.getBorderRadius('large'))
    .margin({
      left: ResponsiveConstants.getPadding('medium'),
      right: ResponsiveConstants.getPadding('medium'),
      bottom: ResponsiveConstants.getSpacing('medium')
    })
    .shadow(ResponsiveConstants.getShadow('medium'))
  }

  @Builder
  buildRecentRecords() {
    Column() {
      Text('最近记录')
        .fontSize(ResponsiveConstants.getFontSize('subtitle'))
        .fontColor(this.getColorScheme().RECENT_LIST.categoryColor)
        .margin({ bottom: ResponsiveConstants.getSpacing('medium') })

      if (this.records.length === 0) {
        Text('暂无记录')
          .fontSize(ResponsiveConstants.getFontSize('body'))
          .fontColor(this.getColorScheme().RECENT_LIST.descriptionColor)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(ResponsiveConstants.getPadding('large'))
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
    .padding(ResponsiveConstants.getPadding('medium'))
    .backgroundColor(this.getColorScheme().RECENT_LIST.backgroundColor)
    .borderRadius(ResponsiveConstants.getBorderRadius('large'))
    .margin({
      left: ResponsiveConstants.getPadding('medium'),
      right: ResponsiveConstants.getPadding('medium')
    })
    .shadow(ResponsiveConstants.getShadow('medium'))
  }



  @Builder
  buildRecordItem(record: AccountRecord) {
    Row() {
      Column() {
        Text(record.category)
          .fontSize(ResponsiveConstants.getFontSize('body'))
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().RECENT_LIST.categoryColor)
        Text(record.description)
          .fontSize(ResponsiveConstants.getFontSize('caption'))
          .fontColor(this.getColorScheme().RECENT_LIST.descriptionColor)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(`${record.type === 'income' ? '+' : '-'}¥${record.amount.toFixed(2)}`)
          .fontSize(ResponsiveConstants.getFontSize('body'))
          .fontWeight(FontWeight.Bold)
          .fontColor(record.type === 'income' ? this.getColorScheme().RECENT_LIST.incomeAmountColor : this.getColorScheme().RECENT_LIST.expenseAmountColor)
        Text(record.dateStr)
          .fontSize(ResponsiveConstants.getFontSize('caption'))
          .fontColor(this.getColorScheme().RECENT_LIST.dateColor)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(ResponsiveConstants.getSpacing('medium'))
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
