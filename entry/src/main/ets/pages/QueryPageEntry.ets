import { AccountRecord } from '../models/AccountRecord';
import { AccountViewModel, QueryFilters } from '../viewmodel/AccountViewModel';
import { COLORS, EXPENSE_CATEGORIES, INCOME_CATEGORIES, Category } from '../constants/Constants';
import { StorageUtil } from '../utils/StorageUtil';
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

  aboutToAppear() {
    StorageUtil.setContext(getContext(this));
    this.loadRecords();
  }

  async loadRecords() {
    this.records = await StorageUtil.getRecords();
    this.viewModel.records = this.records;
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

        Text('查询')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLORS.text)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Text('✓')
            .fontSize(20)
            .fontColor('#FFFFFF')
        }
        .width(36)
        .height(36)
        .backgroundColor(COLORS.primary)
        .onClick(() => {
          this.applyFilters();
          router.back();
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor('#FFFFFF')

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
                })
                .margin({ right: 8 })

              ForEach(this.getAvailableCategories(), (category: Category) => {
                Button(category.name)
                  .width(60)
                  .height(36)
                  .backgroundColor(this.selectedCategory === category.name ? category.color : COLORS.background)
                  .fontColor(this.selectedCategory === category.name ? '#FFFFFF' : COLORS.text)
                  .fontSize(11)
                  .onClick(() => {
                    this.selectedCategory = category.name;
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
            TextInput({ placeholder: '开始日期 YYYY-MM-DD' })
              .width('48%')
              .height(40)
              .padding({ left: 10, right: 10 })
              .backgroundColor(COLORS.background)
              .borderRadius(6)
              .onChange((value: string) => {
                this.startDate = value;
              })

            Row()
              .width('4%')

            TextInput({ placeholder: '结束日期 YYYY-MM-DD' })
              .width('48%')
              .height(40)
              .padding({ left: 10, right: 10 })
              .backgroundColor(COLORS.background)
              .borderRadius(6)
              .onChange((value: string) => {
                this.endDate = value;
              })
          }
          .width('100%')
          .margin({ bottom: 24 })

          // 查询按钮
          Button('查询')
            .width('100%')
            .height(44)
            .backgroundColor(COLORS.primary)
            .fontColor('#FFFFFF')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.performQuery();
            })
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
                          Text(record.category)
                            .fontSize(13)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(COLORS.text)
                          Text(record.description)
                            .fontSize(11)
                            .fontColor(COLORS.textLight)
                            .margin({ top: 4 })
                        }
                        .layoutWeight(1)
                        .alignItems(HorizontalAlign.Start)

                        Column() {
                          Text(`${record.type === 'income' ? '+' : '-'}¥${record.amount.toFixed(2)}`)
                            .fontSize(13)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(record.type === 'income' ? '#6BCB77' : COLORS.primary)
                          Text(record.dateStr)
                            .fontSize(11)
                            .fontColor(COLORS.textLight)
                            .margin({ top: 4 })
                        }
                        .alignItems(HorizontalAlign.End)
                      }
                      .width('100%')
                      .padding(12)
                      .backgroundColor('#FFFFFF')
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
    .backgroundColor(COLORS.background)
  }

  private getAvailableCategories(): Category[] {
    if (this.queryType === 'income') {
      return INCOME_CATEGORIES;
    } else if (this.queryType === 'expense') {
      return EXPENSE_CATEGORIES;
    }
    return [...INCOME_CATEGORIES, ...EXPENSE_CATEGORIES];
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
