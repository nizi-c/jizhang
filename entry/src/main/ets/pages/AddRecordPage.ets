import { AccountRecord } from '../models/AccountRecord';
import { StorageUtil } from '../utils/StorageUtil';
import { DateUtil } from '../utils/DateUtil';
import { COLORS, DynamicColors, EXPENSE_CATEGORIES, INCOME_CATEGORIES, Category } from '../constants/Constants';
import { LIGHT_COLOR_SCHEME, DARK_COLOR_SCHEME } from '../constants/ColorSchemes';
import { ThemeUtil } from '../utils/ThemeUtil';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct AddRecordPage {
  @State recordType: 'income' | 'expense' = 'expense';
  @State selectedCategory: string = '';
  @State amount: string = '';
  @State description: string = '';
  @State selectedDate: string = DateUtil.getTodayStr();
  @State categories: Category[] = [];
  @State selectedMood: string = '😊满意'; // 默认满意
  @State customCategoryName: string = '';
  @State showCustomCategoryDialog: boolean = false;

  aboutToAppear() {
    StorageUtil.setContext(getContext(this));
    this.updateCategories();
  }

  updateCategories() {
    this.categories = this.recordType === 'income' ? INCOME_CATEGORIES : EXPENSE_CATEGORIES;
    this.selectedCategory = this.categories[0]?.name || '';
  }

  getColorScheme() {
    return ThemeUtil.getTheme() === 'light' ? LIGHT_COLOR_SCHEME : DARK_COLOR_SCHEME;
  }

  async saveRecord() {
    if (!this.amount || !this.selectedCategory) {
      promptAction.showToast({
        message: '请输入金额和选择分类',
        duration: 2000
      });
      return;
    }

    try {
      const record: AccountRecord = {
        id: StorageUtil.generateId(),
        type: this.recordType,
        category: this.selectedCategory,
        amount: parseFloat(this.amount),
        description: this.description,
        date: DateUtil.parseDate(this.selectedDate),
        dateStr: this.selectedDate,
        mood: this.selectedMood
      };

      const records = await StorageUtil.getRecords();
      records.unshift(record);
      await StorageUtil.saveRecords(records);

      promptAction.showToast({
        message: '保存成功',
        duration: 1500
      });

      // 延迟返回，让用户看到提示
      setTimeout(() => {
        router.back();
      }, 500);
    } catch (error) {
      console.error('保存记录失败:', error);
      promptAction.showToast({
        message: '保存失败，请重试',
        duration: 2000
      });
    }
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

        Text('添加账单')
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
          // 类型选择
          Row() {
            Button('支出')
              .width('48%')
              .height(44)
              .backgroundColor(this.recordType === 'expense' ? this.getColorScheme().TYPE_SELECTOR.expenseActiveBackground : this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
              .fontColor(this.recordType === 'expense' ? this.getColorScheme().TYPE_SELECTOR.activeTextColor : this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
              .onClick(() => {
                this.recordType = 'expense';
                this.updateCategories();
              })

            Row()
              .width('4%')

            Button('收入')
              .width('48%')
              .height(44)
              .backgroundColor(this.recordType === 'income' ? this.getColorScheme().TYPE_SELECTOR.incomeActiveBackground : this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
              .fontColor(this.recordType === 'income' ? this.getColorScheme().TYPE_SELECTOR.activeTextColor : this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
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
            .fontColor(this.getColorScheme().INPUT_SECTION.labelColor)
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
                    .fontColor(this.selectedCategory === category.name ? this.getColorScheme().CATEGORY_GRID.activeTextColor : this.getColorScheme().CATEGORY_GRID.textColor)
                }
                .width(60)
                .height(80)
                .padding(8)
                .backgroundColor(this.selectedCategory === category.name ? this.getColorScheme().CATEGORY_GRID.activeBackground : this.getColorScheme().CATEGORY_GRID.itemBackground)
                .borderRadius(8)
                .border({
                  width: this.selectedCategory === category.name ? 2 : 0,
                  color: this.getColorScheme().CATEGORY_GRID.activeBorderColor
                })
                .margin({ right: 8 })
                .onClick(() => {
                  this.selectedCategory = category.name;
                })
              }, (category: Category) => category.name)
              
              // 添加自定义分类按钮
              Column() {
                Text('➕')
                  .fontSize(24)
                  .margin({ bottom: 4 })
                Text('自定义')
                  .fontSize(10)
                  .fontColor(this.getColorScheme().CATEGORY_GRID.textColor)
              }
              .width(60)
              .height(80)
              .padding(8)
              .backgroundColor(this.getColorScheme().CATEGORY_GRID.itemBackground)
              .borderRadius(8)
              .border({
                width: 1,
                color: this.getColorScheme().CATEGORY_GRID.activeBorderColor,
                style: BorderStyle.Dashed
              })
              .onClick(() => {
                this.showCustomCategoryDialog = true;
              })
            }
          }
          .width('100%')
          .height(90)
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .margin({ bottom: 16 })

          // 金额输入
          Text('金额')
            .fontSize(12)
            .fontColor(this.getColorScheme().INPUT_SECTION.labelColor)
            .margin({ bottom: 8 })

          TextInput({ placeholder: '请输入金额', text: this.amount })
            .type(InputType.Number)
            .width('100%')
            .height(44)
            .padding({ left: 12, right: 12 })
            .backgroundColor(this.getColorScheme().INPUT_SECTION.inputBackground)
            .borderRadius(8)
            .placeholderColor(this.getColorScheme().INPUT_SECTION.placeholderColor)
            .onChange((value: string) => {
              this.amount = value;
            })
            .margin({ bottom: 16 })

          // 用途描述
          Text('用途')
            .fontSize(12)
            .fontColor(this.getColorScheme().INPUT_SECTION.labelColor)
            .margin({ bottom: 8 })

          TextInput({ placeholder: '请输入用途描述' })
            .width('100%')
            .height(44)
            .padding({ left: 12, right: 12 })
            .backgroundColor(this.getColorScheme().INPUT_SECTION.inputBackground)
            .borderRadius(8)
            .placeholderColor(this.getColorScheme().INPUT_SECTION.placeholderColor)
            .onChange((value: string) => {
              this.description = value;
            })
            .margin({ bottom: 16 })

          // 日期选择
          Text('日期')
            .fontSize(12)
            .fontColor(this.getColorScheme().INPUT_SECTION.labelColor)
            .margin({ bottom: 8 })

          TextInput({ placeholder: 'YYYY-MM-DD', text: this.selectedDate })
            .width('100%')
            .height(44)
            .padding({ left: 12, right: 12 })
            .backgroundColor(this.getColorScheme().INPUT_SECTION.inputBackground)
            .borderRadius(8)
            .placeholderColor(this.getColorScheme().INPUT_SECTION.placeholderColor)
            .onChange((value: string) => {
              this.selectedDate = value;
            })
            .margin({ bottom: 16 })

          // 心情选择
          Text('心情')
            .fontSize(12)
            .fontColor(this.getColorScheme().INPUT_SECTION.labelColor)
            .margin({ bottom: 8 })

          Scroll() {
            Row() {
              Button('😊满意')
                .height(44)
                .padding({ left: 16, right: 16 })
                .backgroundColor(this.selectedMood === '😊满意' ? this.getColorScheme().TYPE_SELECTOR.activeBackground : this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
                .fontColor(this.selectedMood === '😊满意' ? this.getColorScheme().TYPE_SELECTOR.activeTextColor : this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
                .onClick(() => {
                  this.selectedMood = '😊满意';
                })
                .margin({ right: 8 })

              Button('😟后悔')
                .height(44)
                .padding({ left: 16, right: 16 })
                .backgroundColor(this.selectedMood === '😟后悔' ? this.getColorScheme().TYPE_SELECTOR.activeBackground : this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
                .fontColor(this.selectedMood === '😟后悔' ? this.getColorScheme().TYPE_SELECTOR.activeTextColor : this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
                .onClick(() => {
                  this.selectedMood = '😟后悔';
                })
                .margin({ right: 8 })

              Button('🎉惊喜')
                .height(44)
                .padding({ left: 16, right: 16 })
                .backgroundColor(this.selectedMood === '🎉惊喜' ? this.getColorScheme().TYPE_SELECTOR.activeBackground : this.getColorScheme().TYPE_SELECTOR.inactiveBackground)
                .fontColor(this.selectedMood === '🎉惊喜' ? this.getColorScheme().TYPE_SELECTOR.activeTextColor : this.getColorScheme().TYPE_SELECTOR.inactiveTextColor)
                .onClick(() => {
                  this.selectedMood = '🎉惊喜';
                })
            }
          }
          .width('100%')
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .margin({ bottom: 24 })

          // 按钮
          Row() {
            Button('取消')
              .width('48%')
              .height(44)
              .backgroundColor(this.getColorScheme().BUTTON_SECTION.cancelBackground)
              .fontColor(this.getColorScheme().BUTTON_SECTION.cancelTextColor)
              .onClick(() => {
                router.back();
              })

            Row()
              .width('4%')

            Button('保存')
              .width('48%')
              .height(44)
              .backgroundColor(this.getColorScheme().BUTTON_SECTION.saveBackground)
              .fontColor(this.getColorScheme().BUTTON_SECTION.saveTextColor)
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
      
      // 自定义分类对话框
      if (this.showCustomCategoryDialog) {
        Column() {
          Text('添加自定义分类')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().DIALOG.titleColor)
            .margin({ bottom: 16 })

          TextInput({ placeholder: '请输入分类名称', text: this.customCategoryName })
            .width('100%')
            .height(44)
            .backgroundColor(this.getColorScheme().INPUT_SECTION.inputBackground)
            .borderRadius(8)
            .onChange((value: string) => {
              this.customCategoryName = value;
            })
            .margin({ bottom: 16 })

          Row() {
            Button('取消')
              .width('48%')
              .height(40)
              .backgroundColor(this.getColorScheme().BUTTON_SECTION.cancelBackground)
              .fontColor(this.getColorScheme().BUTTON_SECTION.cancelTextColor)
              .onClick(() => {
                this.showCustomCategoryDialog = false;
                this.customCategoryName = '';
              })

            Row().width('4%')

            Button('确定')
              .width('48%')
              .height(40)
              .backgroundColor(this.getColorScheme().BUTTON_SECTION.saveBackground)
              .fontColor(this.getColorScheme().BUTTON_SECTION.saveTextColor)
              .onClick(() => {
                if (this.customCategoryName) {
                  // 添加自定义分类到当前分类列表
                  const newCategory: Category = {
                    name: this.customCategoryName,
                    icon: '📌',
                    color: '#B8B5B2'
                  };
                  this.categories.push(newCategory);
                  this.selectedCategory = this.customCategoryName;
                  this.showCustomCategoryDialog = false;
                  this.customCategoryName = '';
                }
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
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Center)
  }
}
