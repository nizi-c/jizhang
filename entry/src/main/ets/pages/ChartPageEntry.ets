import { ChartPage } from './ChartPage';
import { StorageUtil } from '../utils/StorageUtil';

@Entry
@Component
struct ChartPageEntry {
  aboutToAppear() {
    StorageUtil.setContext(getContext(this));
  }

  build() {
    Column() {
      ChartPage()
    }
    .width('100%')
    .height('100%')
  }
}
