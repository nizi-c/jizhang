import { AccountRecord } from '../models/AccountRecord';
import { AccountViewModel, QueryFilters } from '../viewmodel/AccountViewModel';
import { COLORS, DynamicColors, EXPENSE_CATEGORIES, INCOME_CATEGORIES, Category } from '../constants/Constants';
import { LIGHT_COLOR_SCHEME, DARK_COLOR_SCHEME } from '../constants/ColorSchemes';
import { ThemeUtil } from '../utils/ThemeUtil';
import { StorageUtil } from '../utils/StorageUtil';
import { CalendarUtil, DayInfo } from '../utils/CalendarUtil';
import { ExportUtil } from '../utils/ExportUtil';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';

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
  @State currentYear: number = new Date().getFullYear();
  @State currentMonth: number = new Date().getMonth() + 1;
  @State calendarDays: DayInfo[] = [];
  @State selectedDate: string = '';
  @State selectedDateRecords: AccountRecord[] = [];
  @State isExporting: boolean = false;

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
    this.updateCalendar();
  }

  getColorScheme() {
    return ThemeUtil.getTheme() === 'light' ? LIGHT_COLOR_SCHEME : DARK_COLOR_SCHEME;
  }

  private updateCalendar() {
    this.calendarDays = CalendarUtil.generateCalendarDays(this.currentYear, this.currentMonth);
    
    // 计算每天的收支和主导心情
    this.calendarDays.forEach(day => {
      const dayRecords = this.filteredRecords.filter(r => r.dateStr === day.dateStr);
      day.income = dayRecords.filter(r => r.type === 'income').reduce((sum, r) => sum + r.amount, 0);
      day.expense = dayRecords.filter(r => r.type === 'expense').reduce((sum, r) => sum + r.amount, 0);
      day.balance = day.income - day.expense;
      
      // 计算主导心情
      if (dayRecords.length > 0) {
        const moodCounts: Record<string, number> = {};
        dayRecords.forEach(r => {
          if (r.mood) {
            // 提取emoji部分（前两个字符）
            const moodEmoji = r.mood.substring(0, 2);
            moodCounts[moodEmoji] = (moodCounts[moodEmoji] || 0) + 1;
          }
        });
        
        let maxCount = 0;
        let dominantMood = '';
        Object.keys(moodCounts).forEach(mood => {
          if (moodCounts[mood] > maxCount) {
            maxCount = moodCounts[mood];
            dominantMood = mood;
          }
        });
        day.dominantMood = dominantMood;
      }
    });
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

    this.updateCalendar();
  }

  private previousMonth() {
    const prev = CalendarUtil.getPreviousMonth(this.currentYear, this.currentMonth);
    this.currentYear = prev.year;
    this.currentMonth = prev.month;
    this.updateCalendar();
  }

  private nextMonth() {
    const next = CalendarUtil.getNextMonth(this.currentYear, this.currentMonth);
    this.currentYear = next.year;
    this.currentMonth = next.month;
    this.updateCalendar();
  }

  private selectDate(day: DayInfo) {
    this.selectedDate = day.dateStr;
    this.selectedDateRecords = this.filteredRecords.filter(r => r.dateStr === day.dateStr);
  }

  private async deleteRecord(recordId: string) {
    try {
      // 保存当前选中的日期
      const currentSelectedDate = this.selectedDate;
      
      // 从records中删除
      this.records = this.records.filter(r => r.id !== recordId);
      await StorageUtil.saveRecords(this.records);
      
      // 重新加载数据
      await this.loadRecords();
      
      // 更新选中日期的记录列表
      if (currentSelectedDate) {
        this.selectedDateRecords = this.filteredRecords.filter(r => r.dateStr === currentSelectedDate);
      }
      
      promptAction.showToast({
        message: '删除成功',
        duration: 1500
      });
    } catch (error) {
      promptAction.showToast({
        message: '删除失败',
        duration: 2000
      });
    }
  }

  private async exportData() {
    if (this.isExporting) {
      return;
    }

    if (this.filteredRecords.length === 0) {
      promptAction.showToast({
        message: '暂无数据可导出',
        duration: 2000
      });
      return;
    }

    this.isExporting = true;

    try {
      // 生成CSV内容
      const csvContent = ExportUtil.exportToCSV(this.filteredRecords);
      
      // 生成文件名
      const fileName = ExportUtil.generateFileName();
      
      // 获取context
      const context = getContext(this) as common.UIAbilityContext;
      
      // 使用DocumentPicker让用户选择保存位置
      try {
        const fileUri = await ExportUtil.saveToPublicDirectory(csvContent, fileName, context);
        
        promptAction.showToast({
          message: `导出成功！共${this.filteredRecords.length}条记录\n文件：${fileName}\n\n文件已保存到您选择的位置`,
          duration: 3000
        });
        
        console.log(`CSV文件已导出: ${fileUri}`);
      } catch (saveError) {
        // 用户取消或保存失败，降级到缓存目录
        const error = saveError as BusinessError;
        console.log('用户取消保存或保存失败，使用缓存目录:', error.message);
        
        const filePath = await ExportUtil.saveCSVFile(csvContent, fileName, context);
        
        promptAction.showToast({
          message: `导出成功！共${this.filteredRecords.length}条记录\n文件：${fileName}\n\n已保存到应用缓存目录`,
          duration: 3000
        });
        
        console.log(`CSV文件已导出到缓存目录: ${filePath}`);
      }
    } catch (error) {
      promptAction.showToast({
        message: '导出失败，请重试',
        duration: 2000
      });
      console.error('导出失败:', error);
    } finally {
      this.isExporting = false;
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
          Image($r('app.media.daochu'))
            .width(24)
            .height(24)
        }
        .width(36)
        .height(36)
        .backgroundColor(this.getColorScheme().NAVBAR.buttonBackground)
        .margin({ right: 8 })
        .onClick(() => {
          this.exportData();
        })

        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Image($r('app.media.find'))
            .width(24)
            .height(24)
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
        this.buildFilterPanel()
      }

      // 月份选择器
      Row() {
        Button('<')
          .width(40)
          .height(36)
          .backgroundColor(this.getColorScheme().MONTH_PICKER.buttonBackground)
          .fontColor(this.getColorScheme().MONTH_PICKER.buttonTextColor)
          .onClick(() => {
            this.previousMonth();
          })

        Text(CalendarUtil.formatMonth(this.currentYear, this.currentMonth))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().MONTH_PICKER.textColor)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('>')
          .width(40)
          .height(36)
          .backgroundColor(this.getColorScheme().MONTH_PICKER.buttonBackground)
          .fontColor(this.getColorScheme().MONTH_PICKER.buttonTextColor)
          .onClick(() => {
            this.nextMonth();
          })
      }
      .width('100%')
      .padding(12)
      .backgroundColor(this.getColorScheme().MONTH_PICKER.backgroundColor)

      // 星期标题（周一开始）
      Row() {
        Text('一')
          .fontSize(12)
          .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
          .width(`${100 / 7}%`)
          .textAlign(TextAlign.Center)
        Text('二')
          .fontSize(12)
          .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
          .width(`${100 / 7}%`)
          .textAlign(TextAlign.Center)
        Text('三')
          .fontSize(12)
          .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
          .width(`${100 / 7}%`)
          .textAlign(TextAlign.Center)
        Text('四')
          .fontSize(12)
          .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
          .width(`${100 / 7}%`)
          .textAlign(TextAlign.Center)
        Text('五')
          .fontSize(12)
          .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
          .width(`${100 / 7}%`)
          .textAlign(TextAlign.Center)
        Text('六')
          .fontSize(12)
          .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
          .width(`${100 / 7}%`)
          .textAlign(TextAlign.Center)
        Text('日')
          .fontSize(12)
          .fontColor(this.getColorScheme().CHART_CONTAINER.titleColor)
          .width(`${100 / 7}%`)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({ top: 8, bottom: 8 })

      // 日历网格
      if (this.selectedDate === '') {
        Scroll() {
          Column() {
            this.buildCalendarGrid()
          }
          .width('100%')
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        // 显示选中日期的记录
        Column() {
          Row() {
            Button('← 返回日历')
              .fontSize(14)
              .fontColor(this.getColorScheme().NAVBAR.backButtonColor)
              .backgroundColor(this.getColorScheme().CHART_CONTAINER.backgroundColor)
              .onClick(() => {
                this.selectedDate = '';
              })
              .margin({ bottom: 8 })
          }
          .width('100%')
          .padding(12)

          if (this.selectedDateRecords.length === 0) {
            Column() {
              Text('当天暂无记录')
                .fontSize(16)
                .fontColor(this.getColorScheme().LIST_CONTAINER.emptyTextColor)
            }
            .width('100%')
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          } else {
            List() {
              ForEach(this.selectedDateRecords, (record: AccountRecord) => {
                ListItem() {
                  this.buildRecordItem(record)
                }
                .swipeAction({ end: this.buildDeleteButton(record) })
              }, (record: AccountRecord) => record.id)
            }
            .width('100%')
            .layoutWeight(1)
            .divider({ strokeWidth: 1, color: this.getColorScheme().LIST_ITEM.dividerColor })
          }
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundImage(ThemeUtil.getBackgroundImage(ThemeUtil.getTheme()))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
  }

  @Builder
  buildCalendarGrid() {
    Grid() {
      ForEach(this.calendarDays, (day: DayInfo, index: number) => {
        GridItem() {
          this.buildDayCell(day)
        }
      }, (day: DayInfo, index: number) => `${this.currentYear}-${this.currentMonth}-${index}`)
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
    .rowsGap(1)
    .columnsGap(1)
    .width('100%')
    .backgroundColor(this.getColorScheme().LIST_ITEM.dividerColor)
  }

  @Builder
  buildDayCell(day: DayInfo) {
    Column() {
      if (day.day > 0) {
        // 心情（如果有）
        if (day.dominantMood) {
          Text(day.dominantMood)
            .fontSize(18)
            .margin({ bottom: 2 })
        }
        
        // 日期
        Text(String(day.day))
          .fontSize(16)
          .fontColor(day.isToday ? (ThemeUtil.getTheme() === 'light' ? '#7B9BC8' : this.getColorScheme().NAVBAR.buttonBackground) : this.getColorScheme().LIST_ITEM.categoryColor)
          .fontWeight(day.isToday ? FontWeight.Bold : FontWeight.Normal)
          .margin({ bottom: 4 })

        // 结余信息
        if (day.income > 0 || day.expense > 0) {
          Text(`¥${day.balance.toFixed(0)}`)
            .fontSize(11)
            .fontColor(day.balance >= 0 ? 
              this.getColorScheme().LIST_ITEM.amountIncomeColor : 
              this.getColorScheme().LIST_ITEM.amountExpenseColor)
            .fontWeight(FontWeight.Bold)
        }
      }
    }
    .width('100%')
    .height(80)
    .padding(6)
    .backgroundColor(day.day > 0 ? this.getColorScheme().LIST_ITEM.backgroundColor : this.getColorScheme().LIST_CONTAINER.backgroundColor)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      if (day.day > 0) {
        this.selectDate(day);
      }
    })
  }

  @Builder
  buildFilterPanel() {
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

          Row().width('5%')

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

          Row().width('5%')

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

        // 分类输入框
        TextInput({ placeholder: '输入分类名称', text: this.selectedCategory })
          .width('100%')
          .height(40)
          .padding({ left: 10, right: 10 })
          .backgroundColor(COLORS.inputBg)
          .borderRadius(6)
          .onChange((value: string) => {
            this.selectedCategory = value;
            this.applyFilters();
          })
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
              Button() {
                Column() {
                  Text(category.icon)
                    .fontSize(16)
                  Text(category.name)
                    .fontSize(10)
                    .fontColor(COLORS.text)
                }
              }
              .width(60)
              .height(60)
              .backgroundColor(this.selectedCategory === category.name ? '#CCFDF0CE' : COLORS.background)
              .borderRadius(8)
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

          Row().width('4%')

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
          TextInput({ placeholder: '开始日期 YYYY-MM-DD', text: this.startDate })
            .width('48%')
            .height(40)
            .padding({ left: 10, right: 10 })
            .backgroundColor(COLORS.inputBg)
            .borderRadius(6)
            .onChange((value: string) => {
              this.startDate = value;
              this.applyFilters();
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
                    this.applyFilters();
                  }
                }
              });
            })

          Row().width('4%')

          TextInput({ placeholder: '结束日期 YYYY-MM-DD', text: this.endDate })
            .width('48%')
            .height(40)
            .padding({ left: 10, right: 10 })
            .backgroundColor(COLORS.inputBg)
            .borderRadius(6)
            .onChange((value: string) => {
              this.endDate = value;
              this.applyFilters();
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
                    this.applyFilters();
                  }
                }
              });
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

  @Builder
  buildDeleteButton(record: AccountRecord) {
    Button() {
      Text('删除')
        .fontSize(14)
        .fontColor('#FFFFFF')
    }
    .width(80)
    .height('100%')
    .backgroundColor('#E8A5A5')
    .onClick(() => {
      this.deleteRecord(record.id);
    })
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

  private getAvailableCategories(): Category[] {
    if (this.queryType === 'income') {
      return INCOME_CATEGORIES;
    } else if (this.queryType === 'expense') {
      return EXPENSE_CATEGORIES;
    }
    return [...INCOME_CATEGORIES, ...EXPENSE_CATEGORIES];
  }
}
