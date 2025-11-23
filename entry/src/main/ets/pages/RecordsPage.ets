import { AccountRecord } from '../models/AccountRecord';
import { AccountViewModel, QueryFilters } from '../viewmodel/AccountViewModel';
import { COLORS, DynamicColors, EXPENSE_CATEGORIES, INCOME_CATEGORIES, Category } from '../constants/Constants';
import { LIGHT_COLOR_SCHEME, DARK_COLOR_SCHEME } from '../constants/ColorSchemes';
import { ThemeUtil } from '../utils/ThemeUtil';
import { StorageUtil } from '../utils/StorageUtil';
import router from '@ohos.router';

@Entry
@Component
struct RecordsPage {
  @State records: AccountRecord[] = [];
  @State filteredRecords: AccountRecord[] = [];
  @State viewModel: AccountViewModel = new AccountViewModel();
  @State showFilters: boolean = false;
  @State queryType: 'income' | 'expense' | 'all' = 'all';
  @State selectedCategory: string = '';
  @State minAmount: string = '';
  @State maxAmount: string = '';
  @State startDate: string = '';
  @State endDate: string = '';

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
    this.applyFilters();
  }

  getColorScheme() {
    return ThemeUtil.getTheme() === 'light' ? LIGHT_COLOR_SCHEME : DARK_COLOR_SCHEME;
  }

  private applyFilters() {
    const filters: QueryFilters = {};

    if (this.queryType !== 'all') {
      filters.type = this.queryType;
    }

    if (this.selectedCategory) {
      filters.category = this.selectedCategory;
    }

    if (this.minAmount) {
      filters.minAmount = parseFloat(this.minAmount);
    }

    if (this.maxAmount) {
      filters.maxAmount = parseFloat(this.maxAmount);
    }

    if (this.startDate) {
      filters.startDate = this.startDate;
    }

    if (this.endDate) {
      filters.endDate = this.endDate;
    }

    if (Object.keys(filters).length === 0) {
      this.filteredRecords = this.records;
    } else {
      this.filteredRecords = this.viewModel.queryRecords(filters);
    }
  }

  build() {
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

        Text('流水')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().NAVBAR.titleColor)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Text(this.showFilters ? '✓' : '🔍')
            .fontSize(20)
            .fontColor(this.getColorScheme().NAVBAR.buttonTextColor)
        }
        .width(36)
        .height(36)
        .backgroundColor(this.getColorScheme().NAVBAR.buttonBackground)
        .onClick(() => {
          this.showFilters = !this.showFilters;
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
      .border({ width: { bottom: 1 }, color: this.getColorScheme().NAVBAR.borderColor })

      // 筛选条件面板
      if (this.showFilters) {
        Scroll() {
          Column() {
            // 类型筛选
            Text('交易类型')
              .fontSize(12)
              .fontColor(COLORS.textLight)
              .margin({ bottom: 8 })

            Row() {
              Button('全部')
                .width('30%')
                .height(36)
                .backgroundColor(this.queryType === 'all' ? COLORS.primary : COLORS.background)
                .fontColor(this.queryType === 'all' ? '#FFFFFF' : COLORS.text)
                .fontSize(12)
                .onClick(() => {
                  this.queryType = 'all';
                  this.applyFilters();
                })

              Row()
                .width('5%')

              Button('支出')
                .width('30%')
                .height(36)
                .backgroundColor(this.queryType === 'expense' ? COLORS.primary : COLORS.background)
                .fontColor(this.queryType === 'expense' ? '#FFFFFF' : COLORS.text)
                .fontSize(12)
                .onClick(() => {
                  this.queryType = 'expense';
                  this.applyFilters();
                })

              Row()
                .width('5%')

              Button('收入')
                .width('30%')
                .height(36)
                .backgroundColor(this.queryType === 'income' ? '#6BCB77' : COLORS.background)
                .fontColor(this.queryType === 'income' ? '#FFFFFF' : COLORS.text)
                .fontSize(12)
                .onClick(() => {
                  this.queryType = 'income';
                  this.applyFilters();
                })
            }
            .width('100%')
            .margin({ bottom: 16 })

            // 分类筛选
            Text('分类')
              .fontSize(12)
              .fontColor(COLORS.textLight)
              .margin({ bottom: 8 })

            Scroll() {
              Row() {
                Button('全部')
                  .width(60)
                  .height(36)
                  .backgroundColor(this.selectedCategory === '' ? COLORS.primary : COLORS.background)
                  .fontColor(this.selectedCategory === '' ? '#FFFFFF' : COLORS.text)
                  .fontSize(11)
                  .onClick(() => {
                    this.selectedCategory = '';
                    this.applyFilters();
                  })
                  .margin({ right: 8 })

                ForEach(this.getAvailableCategories(), (category: Category) => {
                  Button(category.name)
                    .width(60)
                    .height(36)
                    .backgroundColor(this.selectedCategory === category.name ? this.getColorScheme().FILTER_SECTION.categoryActiveBackground : this.getColorScheme().FILTER_SECTION.categoryInactiveBackground)
                    .fontColor(this.selectedCategory === category.name ? this.getColorScheme().FILTER_SECTION.categoryActiveTextColor : this.getColorScheme().FILTER_SECTION.categoryInactiveTextColor)
                    .fontSize(11)
                    .onClick(() => {
                      this.selectedCategory = category.name;
                      this.applyFilters();
                    })
                    .margin({ right: 8 })
                }, (category: Category) => category.name)
              }
              .width('100%')
              .margin({ bottom: 16 })
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)

            // 金额范围
            Text('金额范围')
              .fontSize(12)
              .fontColor(COLORS.textLight)
              .margin({ bottom: 8 })

            Row() {
              TextInput({ placeholder: '最小金额', text: this.minAmount })
                .type(InputType.Number)
                .width('48%')
                .height(40)
                .padding({ left: 10, right: 10 })
                .backgroundColor(COLORS.inputBg)
                .borderRadius(6)
                .onChange((value: string) => {
                  this.minAmount = value;
                  this.applyFilters();
                })

              Row()
                .width('4%')

              TextInput({ placeholder: '最大金额', text: this.maxAmount })
                .type(InputType.Number)
                .width('48%')
                .height(40)
                .padding({ left: 10, right: 10 })
                .backgroundColor(COLORS.inputBg)
                .borderRadius(6)
                .onChange((value: string) => {
                  this.maxAmount = value;
                  this.applyFilters();
                })
            }
            .width('100%')
            .margin({ bottom: 16 })

            // 日期范围
            Text('日期范围')
              .fontSize(12)
              .fontColor(COLORS.textLight)
              .margin({ bottom: 8 })

            Row() {
              TextInput({ placeholder: '开始日期', text: this.startDate })
                .width('48%')
                .height(40)
                .padding({ left: 10, right: 10 })
                .backgroundColor(COLORS.inputBg)
                .borderRadius(6)
                .onChange((value: string) => {
                  this.startDate = value;
                  this.applyFilters();
                })

              Row()
                .width('4%')

              TextInput({ placeholder: '结束日期', text: this.endDate })
                .width('48%')
                .height(40)
                .padding({ left: 10, right: 10 })
                .backgroundColor(COLORS.inputBg)
                .borderRadius(6)
                .onChange((value: string) => {
                  this.endDate = value;
                  this.applyFilters();
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
        }
        .width('100%')
        .padding(16)
        .backgroundColor(COLORS.queryBg)
        .height('auto')
      }

      // 流水列表
      if (this.filteredRecords.length === 0) {
        Column() {
          Text('暂无记录')
            .fontSize(16)
            .fontColor(this.getColorScheme().LIST_CONTAINER.emptyTextColor)
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        List() {
          ForEach(this.filteredRecords, (record: AccountRecord) => {
            ListItem() {
              this.buildRecordItemWithSwipe(record)
            }
          }, (record: AccountRecord) => record.id)
        }
        .width('100%')
        .layoutWeight(1)
        .listDirection(Axis.Vertical)
        .divider({ strokeWidth: 1, color: this.getColorScheme().LIST_ITEM.dividerColor })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.getColorScheme().LIST_CONTAINER.backgroundColor)
  }

  @Builder
  buildRecordItem(record: AccountRecord) {
    Row() {
      Column() {
        Text(record.category)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
        Text(record.description)
          .fontSize(12)
          .fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(`${record.type === 'income' ? '+' : '-'}¥${record.amount.toFixed(2)}`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(record.type === 'income' ? this.getColorScheme().LIST_ITEM.amountIncomeColor : this.getColorScheme().LIST_ITEM.amountExpenseColor)
        Text(record.dateStr)
          .fontSize(12)
          .fontColor(this.getColorScheme().LIST_ITEM.dateColor)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
    .height(68)
  }

  @Builder
  buildRecordItemWithSwipe(record: AccountRecord) {
    Swiper() {
      this.buildRecordItem(record)

      Button('删除')
        .width(20)
        .height(68)
        .backgroundColor(COLORS.primary)
        .fontColor('#FFFFFF')
        .fontSize(12)
        .onClick(() => {
          this.viewModel.deleteRecord(record.id);
          this.records = this.records.filter(r => r.id !== record.id);
          StorageUtil.saveRecords(this.records);
          this.applyFilters();
        })
    }
    .indicator(false)
  }

  private getAvailableCategories(): Category[] {
    if (this.queryType === 'income') {
      return INCOME_CATEGORIES;
    } else if (this.queryType === 'expense') {
      return EXPENSE_CATEGORIES;
    }
    return [...INCOME_CATEGORIES, ...EXPENSE_CATEGORIES];
  }
}
