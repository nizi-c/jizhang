import { AccountRecord } from '../models/AccountRecord';
import { AccountViewModel, QueryFilters } from '../viewmodel/AccountViewModel';
import { StorageUtil } from '../utils/StorageUtil';
import { COLORS } from '../constants/Constants';
import router from '@ohos.router';

@Entry
@Component
struct ListPage {
  @State records: AccountRecord[] = [];
  @State filteredRecords: AccountRecord[] = [];
  @State viewModel: AccountViewModel = new AccountViewModel();
  @State queryFilters: QueryFilters = {};

  aboutToAppear() {
    StorageUtil.setContext(getContext(this));
    const params = router.getParams() as Record<string, QueryFilters>;
    if (params && params.queryFilters) {
      this.queryFilters = params.queryFilters;
    }
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

  private applyFilters() {
    if (Object.keys(this.queryFilters).length === 0) {
      this.filteredRecords = this.records;
    } else {
      this.filteredRecords = this.viewModel.queryRecords(this.queryFilters);
    }
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

        Text('流水')
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

      // 流水列表
      if (this.filteredRecords.length === 0) {
        Column() {
          Text('暂无记录')
            .fontSize(16)
            .fontColor(COLORS.textLight)
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .height('100%')
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
        .height('100%')
        .listDirection(Axis.Vertical)
        .divider({ strokeWidth: 1, color: COLORS.border })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLORS.background)
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
        })
    }
    .indicator(false)
  }
}
