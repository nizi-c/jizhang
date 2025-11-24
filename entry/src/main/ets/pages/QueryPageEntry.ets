import { AccountRecord } from '../models/AccountRecord';
import { AccountViewModel, QueryFilters } from '../viewmodel/AccountViewModel';
import { COLORS, EXPENSE_CATEGORIES, INCOME_CATEGORIES, Category } from '../constants/Constants';
import { LIGHT_COLOR_SCHEME, DARK_COLOR_SCHEME } from '../constants/ColorSchemes';
import { StorageUtil } from '../utils/StorageUtil';
import { ThemeUtil } from '../utils/ThemeUtil';
import { CategoryUtil } from '../utils/CategoryUtil';
import router from '@ohos.router';

@Entry
@Component
struct QueryPageEntry {
  @State records: AccountRecord[] = [];
  @State viewModel: AccountViewModel = new AccountViewModel();
  @State queryType: 'income' | 'expense' | 'all' = 'all';
  @State selectedCategory: string = '';
  @State minAmount: string = '';
  @State maxAmount: string = '';
  @State startDate: string = '';
  @State endDate: string = '';
  @State queryResults: AccountRecord[] = [];
  @State hasQueried: boolean = false;
  @State availableCategories: Category[] = [];

  async aboutToAppear() {
    StorageUtil.setContext(getContext(this));
    await this.loadRecords();
    await this.loadCategories();
  }

  onPageShow() {
    this.loadCategories();
  }

  async loadRecords() {
    this.records = await StorageUtil.getRecords();
    this.viewModel.records = this.records;
  }

  async loadCategories() {
    const customCategories = await CategoryUtil.getCustomCategories();
    if (this.queryType === 'income') {
      this.availableCategories = INCOME_CATEGORIES;
    } else if (this.queryType === 'expense') {
      this.availableCategories = [...EXPENSE_CATEGORIES, ...customCategories];
    } else {
      this.availableCategories = [...INCOME_CATEGORIES, ...EXPENSE_CATEGORIES, ...customCategories];
    }
  }

  getColorScheme() {
    return ThemeUtil.getTheme() === 'light' ? LIGHT_COLOR_SCHEME : DARK_COLOR_SCHEME;
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

        Text('查询')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().NAVBAR.titleColor)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row()
          .width(36)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
      .border({ width: { bottom: 1 }, color: this.getColorScheme().NAVBAR.borderColor })

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
                this.loadCategories();
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
                this.loadCategories();
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
                this.loadCategories();
              })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 分类筛选
          Text('分类')
            .fontSize(12)
            .fontColor(COLORS.textLight)
            .margin({ bottom: 8 })

          // 分类输入框
          TextInput({ placeholder: '输入分类名称', text: this.selectedCategory })
            .width('100%')
            .height(40)
            .padding({ left: 10, right: 10 })
            .backgroundColor(COLORS.inputBg)
            .borderRadius(6)
            .onChange((value: string) => {
              this.selectedCategory = value;
            })
            .margin({ bottom: 8 })

          // 分类横向滚动区域
          Column() {
            Scroll() {
              Row() {
                Button('全部')
                  .width(60)
                  .height(60)
                  .backgroundColor(this.selectedCategory === '' ? COLORS.primary : COLORS.background)
                  .fontColor(this.selectedCategory === '' ? '#FFFFFF' : COLORS.text)
                  .fontSize(12)
                  .borderRadius(8)
                  .onClick(() => {
                    this.selectedCategory = '';
                  })
                  .margin({ right: 8 })

                ForEach(this.getAvailableCategories(), (category: Category) => {
                  Button() {
                    Column() {
                      Text(category.icon)
                        .fontSize(20)
                        .margin({ bottom: 4 })
                      Text(category.name)
                        .fontSize(10)
                        .fontColor(this.selectedCategory === category.name ? '#FFFFFF' : COLORS.text)
                    }
                  }
                  .width(60)
                  .height(60)
                  .backgroundColor(this.selectedCategory === category.name ? COLORS.primary : COLORS.background)
                  .borderRadius(8)
                  .onClick(() => {
                    this.selectedCategory = category.name;
                  })
                  .margin({ right: 8 })
                }, (category: Category) => category.name)
              }
              .height(70)
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
            .width('100%')
            .height(70)
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 金额范围
          Text('金额范围')
            .fontSize(12)
            .fontColor(COLORS.textLight)
            .margin({ bottom: 8 })

          Row() {
            TextInput({ placeholder: '最小金额' })
              .type(InputType.Number)
              .width('48%')
              .height(40)
              .padding({ left: 10, right: 10 })
              .backgroundColor(COLORS.background)
              .borderRadius(6)
              .onChange((value: string) => {
                this.minAmount = value;
              })

            Row()
              .width('4%')

            TextInput({ placeholder: '最大金额' })
              .type(InputType.Number)
              .width('48%')
              .height(40)
              .padding({ left: 10, right: 10 })
              .backgroundColor(COLORS.background)
              .borderRadius(6)
              .onChange((value: string) => {
                this.maxAmount = value;
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
              .backgroundColor(COLORS.background)
              .borderRadius(6)
              .onChange((value: string) => {
                this.startDate = value;
              })
              .onClick(() => {
                DatePickerDialog.show({
                  selected: this.startDate ? new Date(this.startDate) : new Date(),
                  onAccept: (value: DatePickerResult) => {
                    if (value.year !== undefined && value.month !== undefined && value.day !== undefined) {
                      const year = value.year;
                      const month = String(value.month + 1).padStart(2, '0');
                      const day = String(value.day).padStart(2, '0');
                      this.startDate = `${year}-${month}-${day}`;
                    }
                  }
                });
              })

            Row()
              .width('4%')

            TextInput({ placeholder: '结束日期', text: this.endDate })
              .width('48%')
              .height(40)
              .padding({ left: 10, right: 10 })
              .backgroundColor(COLORS.background)
              .borderRadius(6)
              .onChange((value: string) => {
                this.endDate = value;
              })
              .onClick(() => {
                DatePickerDialog.show({
                  selected: this.endDate ? new Date(this.endDate) : new Date(),
                  onAccept: (value: DatePickerResult) => {
                    if (value.year !== undefined && value.month !== undefined && value.day !== undefined) {
                      const year = value.year;
                      const month = String(value.month + 1).padStart(2, '0');
                      const day = String(value.day).padStart(2, '0');
                      this.endDate = `${year}-${month}-${day}`;
                    }
                  }
                });
              })
          }
          .width('100%')
          .margin({ bottom: 24 })

          // 查询按钮
          Row() {
            Button('重置')
              .width('30%')
              .height(44)
              .backgroundColor('#F5F5F5')
              .fontColor('#333333')
              .fontSize(14)
              .borderRadius(8)
              .onClick(() => {
                this.resetQuery();
              })

            Row().width('5%')

            Button('确定查询')
              .width('65%')
              .height(44)
              .backgroundColor(COLORS.primary)
              .fontColor('#FFFFFF')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .borderRadius(8)
              .onClick(() => {
                this.performQuery();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: 16 })

          // 查询结果
          if (this.hasQueried) {
            Column() {
              Text(`查询结果 (${this.queryResults.length}条)`)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(COLORS.text)
                .margin({ bottom: 12 })

              if (this.queryResults.length === 0) {
                Text('未找到匹配的记录')
                  .fontSize(12)
                  .fontColor(COLORS.textLight)
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .padding(20)
              } else {
                List() {
                  ForEach(this.queryResults, (record: AccountRecord) => {
                    ListItem() {
                      Row() {
                        Column() {
                          Row() {
                            Text(record.category)
                              .fontSize(14)
                              .fontWeight(FontWeight.Bold)
                              .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
                            if (record.mood) {
                              Text(record.mood.substring(0, 2))
                                .fontSize(14)
                                .margin({ left: 6 })
                            }
                          }
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
                            .fontColor(record.type === 'income' ? 
                              this.getColorScheme().LIST_ITEM.amountIncomeColor : 
                              this.getColorScheme().LIST_ITEM.amountExpenseColor)
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
                    }
                  }, (record: AccountRecord) => record.id)
                }
                .width('100%')
                .listDirection(Axis.Vertical)
                .divider({ strokeWidth: 1, color: COLORS.border })
              }
            }
            .width('100%')
            .padding(12)
            .backgroundColor(COLORS.background)
            .borderRadius(8)
          }
        }
        .width('100%')
        .padding(16)
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundImage(ThemeUtil.getBackgroundImage(ThemeUtil.getTheme()))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
  }

  private getAvailableCategories(): Category[] {
    return this.availableCategories;
  }

  private resetQuery(): void {
    this.queryType = 'all';
    this.selectedCategory = '';
    this.minAmount = '';
    this.maxAmount = '';
    this.startDate = '';
    this.endDate = '';
    this.queryResults = [];
    this.hasQueried = false;
  }

  private performQuery(): void {
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

    this.queryResults = this.viewModel.queryRecords(filters);
    this.hasQueried = true;
  }

  private applyFilters(): void {
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

    router.back({
      url: 'pages/ListPage',
      params: { queryFilters: filters }
    });
  }
}
