import { AccountRecord } from '../models/AccountRecord';
import { StorageUtil } from '../utils/StorageUtil';
import { DateUtil } from '../utils/DateUtil';
import { COLORS, EXPENSE_CATEGORIES, INCOME_CATEGORIES, Category } from '../constants/Constants';
import router from '@ohos.router';

@Entry
@Component
struct AddRecordPage {
  @State recordType: 'income' | 'expense' = 'expense';
  @State selectedCategory: string = '';
  @State amount: string = '';
  @State description: string = '';
  @State selectedDate: string = DateUtil.getTodayStr();
  @State categories: Category[] = [];

  aboutToAppear() {
    StorageUtil.setContext(getContext(this));
    this.updateCategories();
  }

  updateCategories() {
    this.categories = this.recordType === 'income' ? INCOME_CATEGORIES : EXPENSE_CATEGORIES;
    this.selectedCategory = this.categories[0]?.name || '';
  }

  async saveRecord() {
    if (!this.amount || !this.selectedCategory) {
      return;
    }

    const record: AccountRecord = {
      id: StorageUtil.generateId(),
      type: this.recordType,
      category: this.selectedCategory,
      amount: parseFloat(this.amount),
      description: this.description,
      date: DateUtil.parseDate(this.selectedDate),
      dateStr: this.selectedDate
    };

    const records = await StorageUtil.getRecords();
    records.unshift(record);
    await StorageUtil.saveRecords(records);

    router.back();
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

        Text('添加账单')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLORS.text)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row()
          .width(36)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 类型选择
          Row() {
            Button('支出')
              .width('48%')
              .height(44)
              .backgroundColor(this.recordType === 'expense' ? COLORS.primary : COLORS.background)
              .fontColor(this.recordType === 'expense' ? '#FFFFFF' : COLORS.text)
              .onClick(() => {
                this.recordType = 'expense';
                this.updateCategories();
              })

            Row()
              .width('4%')

            Button('收入')
              .width('48%')
              .height(44)
              .backgroundColor(this.recordType === 'income' ? '#6BCB77' : COLORS.background)
              .fontColor(this.recordType === 'income' ? '#FFFFFF' : COLORS.text)
              .onClick(() => {
                this.recordType = 'income';
                this.updateCategories();
              })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 分类选择
          Text('分类')
            .fontSize(12)
            .fontColor(COLORS.textLight)
            .margin({ bottom: 8 })

          Scroll() {
            Row() {
              ForEach(this.categories, (category: Category) => {
                Column() {
                  Text(category.icon)
                    .fontSize(24)
                    .margin({ bottom: 4 })
                  Text(category.name)
                    .fontSize(10)
                    .fontColor(COLORS.text)
                }
                .width(60)
                .height(80)
                .padding(8)
                .backgroundColor(this.selectedCategory === category.name ? category.color + '20' : COLORS.background)
                .borderRadius(8)
                .border({
                  width: this.selectedCategory === category.name ? 2 : 0,
                  color: category.color
                })
                .margin({ right: 8 })
                .onClick(() => {
                  this.selectedCategory = category.name;
                })
              }, (category: Category) => category.name)
            }
            .width('100%')
            .margin({ bottom: 16 })
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)

          // 金额输入
          Text('金额')
            .fontSize(12)
            .fontColor(COLORS.textLight)
            .margin({ bottom: 8 })

          TextInput({ placeholder: '请输入金额', text: this.amount })
            .type(InputType.Number)
            .width('100%')
            .height(44)
            .padding({ left: 12, right: 12 })
            .backgroundColor(COLORS.background)
            .borderRadius(8)
            .onChange((value: string) => {
              this.amount = value;
            })
            .margin({ bottom: 16 })

          // 用途描述
          Text('用途')
            .fontSize(12)
            .fontColor(COLORS.textLight)
            .margin({ bottom: 8 })

          TextInput({ placeholder: '请输入用途描述' })
            .width('100%')
            .height(44)
            .padding({ left: 12, right: 12 })
            .backgroundColor(COLORS.background)
            .borderRadius(8)
            .onChange((value: string) => {
              this.description = value;
            })
            .margin({ bottom: 16 })

          // 日期选择
          Text('日期')
            .fontSize(12)
            .fontColor(COLORS.textLight)
            .margin({ bottom: 8 })

          TextInput({ placeholder: 'YYYY-MM-DD', text: this.selectedDate })
            .width('100%')
            .height(44)
            .padding({ left: 12, right: 12 })
            .backgroundColor(COLORS.background)
            .borderRadius(8)
            .onChange((value: string) => {
              this.selectedDate = value;
            })
            .margin({ bottom: 24 })

          // 按钮
          Row() {
            Button('取消')
              .width('48%')
              .height(44)
              .backgroundColor(COLORS.background)
              .fontColor(COLORS.text)
              .onClick(() => {
                router.back();
              })

            Row()
              .width('4%')

            Button('保存')
              .width('48%')
              .height(44)
              .backgroundColor(COLORS.primary)
              .fontColor('#FFFFFF')
              .onClick(() => {
                this.saveRecord();
              })
          }
          .width('100%')
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
}
