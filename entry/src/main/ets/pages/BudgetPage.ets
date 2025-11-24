// 预算管理页面
import { Budget, BudgetProgress } from '../models/Budget';
import { AccountRecord } from '../models/AccountRecord';
import { BudgetUtil } from '../utils/BudgetUtil';
import { StorageUtil } from '../utils/StorageUtil';
import { ThemeUtil } from '../utils/ThemeUtil';
import { CategoryUtil } from '../utils/CategoryUtil';
import { LIGHT_COLOR_SCHEME, DARK_COLOR_SCHEME } from '../constants/ColorSchemes';
import { EXPENSE_CATEGORIES, Category } from '../constants/Constants';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct BudgetPage {
  @State budgets: Budget[] = [];
  @State records: AccountRecord[] = [];
  @State budgetProgresses: BudgetProgress[] = [];
  @State showAddDialog: boolean = false;
  @State newCategory: string = '';
  @State newAmount: string = '';
  @State newPeriod: 'week' | 'month' | 'year' = 'month';
  @State totalBudget: number = 0;
  @State totalUsed: number = 0;
  @State totalRemaining: number = 0;
  @State totalPercentage: number = 0;
  @State availableCategories: Category[] = [];
  @State showCustomCategoryDialog: boolean = false;
  @State customCategoryName: string = '';

  async aboutToAppear() {
    const context = getContext(this) as common.UIAbilityContext;
    await BudgetUtil.init(context);
    await this.loadData();
    await this.loadCategories();
  }

  async loadData() {
    this.budgets = await BudgetUtil.getAllBudgets();
    this.records = await StorageUtil.getRecords();
    this.calculateProgress();
  }

  async loadCategories() {
    const customCategories = await CategoryUtil.getCustomCategories();
    this.availableCategories = [...EXPENSE_CATEGORIES, ...customCategories];
  }

  calculateProgress() {
    this.budgetProgresses = [];
    this.totalBudget = 0;
    this.totalUsed = 0;

    this.budgets.forEach(budget => {
      const usedAmount = this.records
        .filter(r => r.category === budget.category && r.type === 'expense')
        .reduce((sum, r) => sum + r.amount, 0);

      const remainingAmount = budget.amount - usedAmount;
      const percentage = budget.amount > 0 ? (usedAmount / budget.amount) * 100 : 0;
      const status = percentage > 100 ? 'exceeded' :
                     percentage >= budget.warningThreshold ? 'warning' : 'normal';

      this.budgetProgresses.push({
        budgetId: budget.id,
        category: budget.category,
        budgetAmount: budget.amount,
        usedAmount: usedAmount,
        remainingAmount: remainingAmount,
        percentage: percentage,
        status: status,
        recordCount: this.records.filter(r => r.category === budget.category).length
      });

      this.totalBudget += budget.amount;
      this.totalUsed += usedAmount;
    });

    this.totalRemaining = this.totalBudget - this.totalUsed;
    this.totalPercentage = this.totalBudget > 0 ? (this.totalUsed / this.totalBudget) * 100 : 0;
  }

  async addBudget() {
    if (!this.newCategory || !this.newAmount) {
      promptAction.showToast({ message: '请填写完整信息', duration: 2000 });
      return;
    }

    const amount = parseFloat(this.newAmount);
    if (isNaN(amount) || amount <= 0) {
      promptAction.showToast({ message: '请输入有效金额', duration: 2000 });
      return;
    }

    const budget: Budget = {
      id: '',
      bookId: '',
      category: this.newCategory,
      amount: amount,
      period: this.newPeriod,
      warningThreshold: 90,
      createTime: ''
    };

    await BudgetUtil.saveBudget(budget);
    await this.loadData();

    this.showAddDialog = false;
    this.newCategory = '';
    this.newAmount = '';
    this.newPeriod = 'month';

    promptAction.showToast({ message: '添加成功', duration: 1500 });
  }

  async deleteBudget(budgetId: string) {
    await BudgetUtil.deleteBudget(budgetId);
    await this.loadData();
    promptAction.showToast({ message: '删除成功', duration: 1500 });
  }

  getColorScheme() {
    return ThemeUtil.getTheme() === 'light' ? LIGHT_COLOR_SCHEME : DARK_COLOR_SCHEME;
  }

  getProgressColor(status: string): string {
    switch (status) {
      case 'normal':
        return this.getColorScheme().STAT_CARD.incomeColor;
      case 'warning':
        return '#FFA500';
      case 'exceeded':
        return this.getColorScheme().STAT_CARD.expenseColor;
      default:
        return this.getColorScheme().STAT_CARD.incomeColor;
    }
  }

  getCategoryColor(category: string): string {
    const colors = [
      '#E8A5A5', // 食物 - 红色系
      '#8FAADC', // 交通 - 蓝色系
      '#E8C9A5', // 娱乐 - 橙色系
      '#C9B6D6', // 购物 - 紫色系
      '#95D1B3', // 医疗 - 绿色系
      '#A5C8E8', // 教育 - 浅蓝色
      '#B8B5B2', // 住房 - 灰色系
      '#D6C9B6', // 其他 - 棕色系
      '#FFB6C1', // 额外颜色1
      '#98D8C8'  // 额外颜色2
    ];
    
    // 根据分类名称生成一个稳定的索引
    let hash = 0;
    for (let i = 0; i < category.length; i++) {
      hash = category.charCodeAt(i) + ((hash << 5) - hash);
    }
    const index = Math.abs(hash) % colors.length;
    return colors[index];
  }

  build() {
    Stack() {
      Column() {
        // 导航栏
        Row() {
          Button({ type: ButtonType.Circle }) {
            Text('←').fontSize(20).fontColor(this.getColorScheme().NAVBAR.backButtonColor)
          }
          .width(36).height(36)
          .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
          .onClick(() => router.back())

          Text('预算管理')
            .fontSize(18).fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().NAVBAR.titleColor)
            .layoutWeight(1).textAlign(TextAlign.Center)

          Button({ type: ButtonType.Circle }) {
            Text('+').fontSize(24).fontColor(this.getColorScheme().NAVBAR.titleColor)
          }
          .width(36).height(36)
          .backgroundColor(this.getColorScheme().NAVBAR.buttonBackground)
          .onClick(() => { this.showAddDialog = true; })
        }
        .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
        .border({ width: { bottom: 1 }, color: this.getColorScheme().NAVBAR.borderColor })

      Scroll() {
        Column() {
          // 总体概览
          Column() {
            Text('本月预算概览')
              .fontSize(16).fontWeight(FontWeight.Bold)
              .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
              .margin({ bottom: 12 })

            Row() {
              Column() {
                Text('总预算').fontSize(12).fontColor(this.getColorScheme().STAT_CARD.labelColor)
                Text(`¥${this.totalBudget.toFixed(0)}`)
                  .fontSize(18).fontWeight(FontWeight.Bold)
                  .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
              }.layoutWeight(1)

              Column() {
                Text('已使用').fontSize(12).fontColor(this.getColorScheme().STAT_CARD.labelColor)
                Text(`¥${this.totalUsed.toFixed(0)}`)
                  .fontSize(18).fontWeight(FontWeight.Bold)
                  .fontColor(this.getColorScheme().STAT_CARD.expenseColor)
              }.layoutWeight(1)

              Column() {
                Text('剩余').fontSize(12).fontColor(this.getColorScheme().STAT_CARD.labelColor)
                Text(`¥${this.totalRemaining.toFixed(0)}`)
                  .fontSize(18).fontWeight(FontWeight.Bold)
                  .fontColor(this.getColorScheme().STAT_CARD.incomeColor)
              }.layoutWeight(1)
            }.width('100%').margin({ bottom: 12 })

            Progress({ value: this.totalPercentage, total: 100, type: ProgressType.Linear })
              .width('100%').height(8)
              .color(this.totalPercentage > 100 ? this.getColorScheme().STAT_CARD.expenseColor :
                     this.totalPercentage >= 80 ? '#FFA500' :
                     this.getColorScheme().STAT_CARD.incomeColor)

            Text(`${this.totalPercentage.toFixed(1)}%`)
              .fontSize(14).fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
              .margin({ top: 8 })
          }
          .width('100%').padding(16)
          .backgroundColor(this.getColorScheme().STAT_CARD.backgroundColor)
          .borderRadius(12).margin({ bottom: 16 })

          // 预算占比环形图
          if (this.budgetProgresses.length > 0) {
            this.buildBudgetPieChart()
          }

          // 预算列表
          if (this.budgetProgresses.length === 0) {
            Column() {
              Text('暂无预算设置')
                .fontSize(16).fontColor(this.getColorScheme().LIST_CONTAINER.emptyTextColor)
                .margin({ top: 40 })
            }.width('100%')
          } else {
            ForEach(this.budgetProgresses, (progress: BudgetProgress) => {
              this.buildBudgetItem(progress)
            }, (progress: BudgetProgress) => progress.budgetId)
          }
        }
        .width('100%').padding(16)
      }
      .layoutWeight(1)
      }
      .width('100%').height('100%')
      .backgroundImage(ThemeUtil.getBackgroundImage(ThemeUtil.getTheme()))
      .backgroundImageSize(ImageSize.Cover)
      .backgroundImagePosition(Alignment.Center)

      // 添加预算对话框
      if (this.showAddDialog) {
        this.buildAddDialog()
      }

      // 自定义分类对话框
      if (this.showCustomCategoryDialog) {
        this.buildCustomCategoryDialog()
      }
    }
    .width('100%').height('100%')
    .alignContent(Alignment.Center)
  }

  @Builder
  buildBudgetPieChart() {
    Column() {
      Text('预算分类占比')
        .fontSize(16).fontWeight(FontWeight.Bold)
        .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
        .margin({ bottom: 16 })

      // 环形图可视化
      Stack() {
        ForEach(this.budgetProgresses.slice(0, 5), (progress: BudgetProgress, index: number) => {
          Progress({
            value: (progress.budgetAmount / this.totalBudget) * 100,
            total: 100,
            type: ProgressType.Ring
          })
            .width(180 - index * 20)
            .height(180 - index * 20)
            .color(this.getCategoryColor(progress.category))
            .style({ strokeWidth: 15 })
        }, (progress: BudgetProgress) => progress.budgetId)

        // 中心显示总预算
        Column() {
          Text('总预算')
            .fontSize(12)
            .fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
          Text(`¥${this.totalBudget.toFixed(0)}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
        }
      }
      .width('100%')
      .height(180)
      .alignContent(Alignment.Center)
      .margin({ bottom: 16 })

      // 图例
      Column() {
        ForEach(this.budgetProgresses, (progress: BudgetProgress) => {
          Row() {
            Row()
              .width(12)
              .height(12)
              .backgroundColor(this.getCategoryColor(progress.category))
              .borderRadius(2)
              .margin({ right: 8 })

            Text(progress.category)
              .fontSize(14)
              .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
              .layoutWeight(1)

            Text(`${((progress.budgetAmount / this.totalBudget) * 100).toFixed(1)}%`)
              .fontSize(12)
              .fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
              .margin({ right: 8 })

            Text(`¥${progress.budgetAmount.toFixed(0)}`)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
          .borderRadius(8)
          .margin({ bottom: 8 })
        }, (progress: BudgetProgress) => progress.budgetId)
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.getColorScheme().CHART_CONTAINER.backgroundColor)
    .borderRadius(12)
    .margin({ bottom: 16 })
  }

  @Builder
  buildBudgetItem(progress: BudgetProgress) {
    Column() {
      Row() {
        Row() {
          Text(progress.category)
            .fontSize(16).fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
          
          // 超支或预警标识
          if (progress.status === 'exceeded' || progress.status === 'warning') {
            Image($r('app.media.clock'))
              .width(16).height(16)
              .margin({ left: 6 })
            Text(progress.status === 'exceeded' ? '超支' : '预警')
              .fontSize(12)
              .fontColor(progress.status === 'exceeded' ? 
                this.getColorScheme().STAT_CARD.expenseColor : '#FFA500')
              .fontWeight(FontWeight.Bold)
              .margin({ left: 2 })
          }
        }.layoutWeight(1)

        Button('删除')
          .fontSize(12).height(28)
          .backgroundColor('#E8A5A5').fontColor('#FFFFFF')
          .onClick(() => { this.deleteBudget(progress.budgetId); })
      }.width('100%').margin({ bottom: 8 })

      Row() {
        Text(`¥${progress.usedAmount.toFixed(0)}`)
          .fontSize(14).fontColor(this.getColorScheme().STAT_CARD.expenseColor)
        Text(' / ')
          .fontSize(14).fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
        Text(`¥${progress.budgetAmount.toFixed(0)}`)
          .fontSize(14).fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
      }.width('100%').margin({ bottom: 8 })

      Progress({ value: Math.min(progress.percentage, 100), total: 100, type: ProgressType.Linear })
        .width('100%').height(8)
        .color(this.getProgressColor(progress.status))
        .margin({ bottom: 8 })

      Row() {
        Text(`${progress.percentage.toFixed(1)}%`)
          .fontSize(12).fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
        Text(progress.status === 'exceeded' ? `超支 ¥${Math.abs(progress.remainingAmount).toFixed(0)}` :
             `剩余 ¥${progress.remainingAmount.toFixed(0)}`)
          .fontSize(12)
          .fontColor(progress.status === 'exceeded' ?
            this.getColorScheme().STAT_CARD.expenseColor :
            this.getColorScheme().STAT_CARD.incomeColor)
          .layoutWeight(1).textAlign(TextAlign.End)
      }.width('100%')
    }
    .width('100%').padding(16)
    .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
    .borderRadius(12).margin({ bottom: 12 })
  }

  @Builder
  buildAddDialog() {
    Column() {
      Column() {
        Text('添加预算')
          .fontSize(18).fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().DIALOG.titleColor)
          .margin({ bottom: 20 })

        Text('分类').fontSize(14).fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
          .alignSelf(ItemAlign.Start).margin({ bottom: 8 })

        Scroll() {
          Row() {
            ForEach(this.availableCategories, (cat: Category) => {
              Button() {
                Column() {
                  Text(cat.icon).fontSize(20)
                  Text(cat.name).fontSize(10).fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
                }
              }
              .width(60).height(60)
              .backgroundColor(this.newCategory === cat.name ?
                this.getColorScheme().TYPE_SELECTOR.activeBackground :
                this.getColorScheme().LIST_ITEM.backgroundColor)
              .borderRadius(8).margin({ right: 8 })
              .onClick(() => { this.newCategory = cat.name; })
            }, (cat: Category) => cat.name)
            
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
            .height(60)
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
        .scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off)
        .width('100%').margin({ bottom: 16 })

        Text('金额').fontSize(14).fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
          .alignSelf(ItemAlign.Start).margin({ bottom: 8 })

        TextInput({ placeholder: '请输入预算金额', text: this.newAmount })
          .type(InputType.Number).width('100%').height(44)
          .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
          .placeholderColor('#999999')
          .onChange((value: string) => { this.newAmount = value; })
          .margin({ bottom: 16 })

        Text('周期').fontSize(14).fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
          .alignSelf(ItemAlign.Start).margin({ bottom: 8 })

        Row() {
          Button('周')
            .width('30%').height(36)
            .backgroundColor(this.newPeriod === 'week' ?
              this.getColorScheme().TYPE_SELECTOR.activeBackground :
              this.getColorScheme().LIST_ITEM.backgroundColor)
            .fontColor(this.newPeriod === 'week' ? '#FFFFFF' :
              this.getColorScheme().LIST_ITEM.categoryColor)
            .onClick(() => { this.newPeriod = 'week'; })
            .margin({ right: 8 })

          Button('月')
            .width('30%').height(36)
            .backgroundColor(this.newPeriod === 'month' ?
              this.getColorScheme().TYPE_SELECTOR.activeBackground :
              this.getColorScheme().LIST_ITEM.backgroundColor)
            .fontColor(this.newPeriod === 'month' ? '#FFFFFF' :
              this.getColorScheme().LIST_ITEM.categoryColor)
            .onClick(() => { this.newPeriod = 'month'; })
            .margin({ right: 8 })

          Button('年')
            .width('30%').height(36)
            .backgroundColor(this.newPeriod === 'year' ?
              this.getColorScheme().TYPE_SELECTOR.activeBackground :
              this.getColorScheme().LIST_ITEM.backgroundColor)
            .fontColor(this.newPeriod === 'year' ? '#FFFFFF' :
              this.getColorScheme().LIST_ITEM.categoryColor)
            .onClick(() => { this.newPeriod = 'year'; })
        }.width('100%').margin({ bottom: 20 })

        Row() {
          Button('取消')
            .width('48%').height(44)
            .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
            .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
            .onClick(() => {
              this.showAddDialog = false;
              this.newCategory = '';
              this.newAmount = '';
            })

          Button('确定')
            .width('48%').height(44)
            .backgroundColor(this.getColorScheme().TYPE_SELECTOR.activeBackground)
            .fontColor('#FFFFFF')
            .onClick(() => { this.addBudget(); })
        }.width('100%').justifyContent(FlexAlign.SpaceBetween)
      }
      .width('85%').padding(20)
      .backgroundColor(this.getColorScheme().DIALOG.backgroundColor)
      .borderRadius(12).shadow({ radius: 20, color: '#00000040' })
    }
    .width('100%').height('100%')
    .backgroundColor('#00000040')
    .justifyContent(FlexAlign.Center)
    .onClick(() => { this.showAddDialog = false; })
  }

  @Builder
  buildCustomCategoryDialog() {
    Column() {
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
            .onClick(async () => {
              if (this.customCategoryName) {
                // 添加自定义分类到存储
                const newCategory: Category = {
                  name: this.customCategoryName,
                  icon: '📌',
                  color: '#B8B5B2'
                };
                await CategoryUtil.addCustomCategory(newCategory);
                
                // 重新加载分类列表
                await this.loadCategories();
                this.newCategory = this.customCategoryName;
                this.showCustomCategoryDialog = false;
                this.customCategoryName = '';
                
                promptAction.showToast({
                  message: '自定义分类已添加',
                  duration: 1500
                });
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
    .width('100%')
    .height('100%')
    .backgroundColor('#00000040')
    .justifyContent(FlexAlign.Center)
    .onClick(() => { this.showCustomCategoryDialog = false; })
  }
}
