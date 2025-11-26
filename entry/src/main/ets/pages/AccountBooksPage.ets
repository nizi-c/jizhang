// 账本管理页面
import { AccountBook } from '../models/AccountBook';
import { AccountBookUtil } from '../utils/AccountBookUtil';
import { ThemeUtil } from '../utils/ThemeUtil';
import { LIGHT_COLOR_SCHEME, DARK_COLOR_SCHEME } from '../constants/ColorSchemes';
import { EventBus, Events } from '../utils/EventBus';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct AccountBooksPage {
  @State books: AccountBook[] = [];
  @State currentBookId: string = '';
  @State showCreateDialog: boolean = false;
  @State showRenameDialog: boolean = false;
  @State newBookName: string = '';
  @State newBookIcon: string = '📒';
  @State renameBook: AccountBook | null = null;
  @State renameBookName: string = '';

  private bookIcons: string[] = ['📒', '💰', '💳', '🏦', '📊', '💵', '🎯', '📝', '🔖', '📌'];
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    // 确保AccountBookUtil已初始化
    const context = getContext(this) as common.UIAbilityContext;
    if (!AccountBookUtil.getCurrentBookId()) {
      AccountBookUtil.init(context).then(() => {
        this.loadBooks();
      });
    } else {
      this.loadBooks();
    }
    
    // 滚动到顶部
    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Top);
    }, 200);
  }

  loadBooks() {
    AccountBookUtil.getAllBooks().then((books: AccountBook[]) => {
      this.books = [...books];
      this.currentBookId = AccountBookUtil.getCurrentBookId();
      console.log('AccountBooksPage: 账本列表已加载，总数:', this.books.length);
    }).catch((error: Error) => {
      console.error('AccountBooksPage: 加载账本失败:', error);
    });
  }

  getColorScheme() {
    return ThemeUtil.getTheme() === 'light' ? LIGHT_COLOR_SCHEME : DARK_COLOR_SCHEME;
  }

  switchBook(bookId: string) {
    AccountBookUtil.setCurrentBook(bookId).then(() => {
      this.currentBookId = bookId;
      console.log('AccountBooksPage: 已切换账本:', bookId);
      
      // 发送账本切换事件
      EventBus.emit(Events.BOOK_SWITCHED, bookId);
      
      promptAction.showToast({
        message: '已切换账本',
        duration: 1500
      });
      
      // 延迟返回首页刷新数据
      setTimeout(() => {
        console.log('AccountBooksPage: 返回首页');
        router.back();
      }, 1200);
    });
  }

  createBook() {
    if (!this.newBookName.trim()) {
      promptAction.showToast({
        message: '请输入账本名称',
        duration: 2000
      });
      return;
    }

    AccountBookUtil.createBook(this.newBookName.trim(), this.newBookIcon).then(() => {
      this.loadBooks();
      
      this.showCreateDialog = false;
      this.newBookName = '';
      this.newBookIcon = '📒';
      
      promptAction.showToast({
        message: '创建成功',
        duration: 1500
      });
    }).catch((error: Error) => {
      console.error('AccountBooksPage: 创建账本失败:', error);
      promptAction.showToast({
        message: '创建失败',
        duration: 2000
      });
    });
  }

  deleteBook(book: AccountBook) {
    if (book.isDefault) {
      promptAction.showToast({
        message: '不能删除默认账本',
        duration: 2000
      });
      return;
    }

    if (book.id === this.currentBookId) {
      promptAction.showToast({
        message: '不能删除当前账本',
        duration: 2000
      });
      return;
    }

    AccountBookUtil.deleteBook(book.id).then((success: boolean) => {
      if (success) {
        this.loadBooks();
        promptAction.showToast({
          message: '删除成功',
          duration: 1500
        });
      } else {
        promptAction.showToast({
          message: '删除失败',
          duration: 2000
        });
      }
    });
  }

  showRenameBookDialog(book: AccountBook) {
    this.renameBook = book;
    this.renameBookName = book.name;
    this.showRenameDialog = true;
  }

  renameBookConfirm() {
    if (!this.renameBook) return;

    if (!this.renameBookName.trim()) {
      promptAction.showToast({
        message: '请输入账本名称',
        duration: 2000
      });
      return;
    }

    this.renameBook.name = this.renameBookName.trim();
    AccountBookUtil.saveBook(this.renameBook).then(() => {
      this.loadBooks();
      console.log('AccountBooksPage: 账本已重命名为:', this.renameBook?.name);

      promptAction.showToast({
        message: '重命名成功',
        duration: 1500
      });

      // 发送账本更新事件
      console.log('AccountBooksPage: 发送 BOOK_UPDATED 事件');
      if (this.renameBook) {
        EventBus.emit(Events.BOOK_UPDATED, this.renameBook);
      }

      this.showRenameDialog = false;
      this.renameBook = null;
      this.renameBookName = '';

      // 延迟返回，确保事件已被处理
      setTimeout(() => {
        console.log('AccountBooksPage: 返回首页');
        router.back();
      }, 1200);
    }).catch((error: Error) => {
      console.error('AccountBooksPage: 重命名失败:', error);
      promptAction.showToast({
        message: '重命名失败',
        duration: 2000
      });
    });
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

        Text('账本管理')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().NAVBAR.titleColor)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Text('+')
            .fontSize(24)
            .fontColor(this.getColorScheme().NAVBAR.titleColor)
        }
        .width(36)
        .height(36)
        .backgroundColor(this.getColorScheme().NAVBAR.buttonBackground)
        .onClick(() => {
          this.showCreateDialog = true;
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
      .border({ width: { bottom: 1 }, color: this.getColorScheme().NAVBAR.borderColor })

      // 账本列表
      Scroll(this.scroller) {
        Column() {
          if (this.books.length === 0) {
            Column() {
              Text('暂无账本')
                .fontSize(16)
                .fontColor(this.getColorScheme().LIST_CONTAINER.emptyTextColor)
                .margin({ top: 40 })
            }
            .width('100%')
          } else {
            ForEach(this.books, (book: AccountBook) => {
              this.buildBookItem(book)
            }, (book: AccountBook) => book.id)
          }
        }
        .width('100%')
        .padding({ top: 8, left: 16, right: 16, bottom: 16 })
      }
      .scrollable(ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.Top)
      .layoutWeight(1)

      // 创建账本对话框
      if (this.showCreateDialog) {
        this.buildCreateDialog()
      }

      // 重命名对话框
      if (this.showRenameDialog) {
        this.buildRenameDialog()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundImage(ThemeUtil.getBackgroundImage(ThemeUtil.getTheme()))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
  }

  @Builder
  buildBookItem(book: AccountBook) {
    Row() {
      // 图标
      Text(book.icon)
        .fontSize(32)
        .margin({ right: 16 })

      // 名称和信息
      Column() {
        Row() {
          Text(book.name)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
            .onClick(() => {
              this.showRenameBookDialog(book);
            })
          
          if (book.isDefault) {
            Text('默认')
              .fontSize(10)
              .fontColor('#FFFFFF')
              .backgroundColor(this.getColorScheme().STAT_CARD.incomeColor)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(4)
              .margin({ left: 8 })
          }

          if (book.id === this.currentBookId) {
            Text('当前')
              .fontSize(10)
              .fontColor('#FFFFFF')
              .backgroundColor('#7B9BC8')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(4)
              .margin({ left: 8 })
          }
        }

        Text(`创建于 ${this.formatDate(book.createTime)}`)
          .fontSize(12)
          .fontColor(this.getColorScheme().LIST_ITEM.descriptionColor)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 操作按钮
      Row() {
        if (book.id !== this.currentBookId) {
          Button('切换')
            .fontSize(14)
            .height(32)
            .backgroundColor(this.getColorScheme().NAVBAR.buttonBackground)
            .fontColor(this.getColorScheme().NAVBAR.titleColor)
            .onClick(() => {
              this.switchBook(book.id);
            })
            .margin({ right: 8 })
        }

        if (!book.isDefault && book.id !== this.currentBookId) {
          Button('删除')
            .fontSize(14)
            .height(32)
            .backgroundColor('#E8A5A5')
            .fontColor('#FFFFFF')
            .onClick(() => {
              this.deleteBook(book);
            })
        }
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
    .borderRadius(12)
    .margin({ bottom: 12 })
    .shadow({ radius: 4, color: this.getColorScheme().STAT_CARD.shadowColor })
  }

  @Builder
  buildCreateDialog() {
    Column() {
      Column() {
        Text('创建新账本')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().DIALOG.titleColor)
          .margin({ bottom: 20 })

        // 账本名称
        Text('账本名称')
          .fontSize(14)
          .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入账本名称', text: this.newBookName })
          .width('100%')
          .height(44)
          .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
          .onChange((value: string) => {
            this.newBookName = value;
          })
          .margin({ bottom: 16 })

        // 选择图标
        Text('选择图标')
          .fontSize(14)
          .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 8 })

        Grid() {
          ForEach(this.bookIcons, (icon: string) => {
            GridItem() {
              Text(icon)
                .fontSize(32)
                .width(60)
                .height(60)
                .textAlign(TextAlign.Center)
                .backgroundColor(this.newBookIcon === icon ? 
                  this.getColorScheme().TYPE_SELECTOR.activeBackground : 
                  this.getColorScheme().LIST_ITEM.backgroundColor)
                .borderRadius(8)
                .onClick(() => {
                  this.newBookIcon = icon;
                })
            }
          }, (icon: string) => icon)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
        .rowsGap(8)
        .columnsGap(8)
        .width('100%')
        .height(140)
        .margin({ bottom: 20 })

        // 按钮
        Row() {
          Button('取消')
            .width('48%')
            .height(44)
            .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
            .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
            .onClick(() => {
              this.showCreateDialog = false;
              this.newBookName = '';
              this.newBookIcon = '📒';
            })

          Button('创建')
            .width('48%')
            .height(44)
            .backgroundColor(this.getColorScheme().TYPE_SELECTOR.activeBackground)
            .fontColor('#FFFFFF')
            .onClick(() => {
              this.createBook();
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('85%')
      .padding(20)
      .backgroundColor(this.getColorScheme().DIALOG.backgroundColor)
      .borderRadius(12)
      .shadow({ radius: 20, color: '#00000040' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#00000040')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.showCreateDialog = false;
    })
  }

  @Builder
  buildRenameDialog() {
    Column() {
      Column() {
        Text('重命名账本')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getColorScheme().DIALOG.titleColor)
          .margin({ bottom: 20 })

        // 账本名称
        Text('新名称')
          .fontSize(14)
          .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入新名称', text: this.renameBookName })
          .width('100%')
          .height(44)
          .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
          .onChange((value: string) => {
            this.renameBookName = value;
          })
          .margin({ bottom: 20 })

        // 按钮
        Row() {
          Button('取消')
            .width('48%')
            .height(44)
            .backgroundColor(this.getColorScheme().LIST_ITEM.backgroundColor)
            .fontColor(this.getColorScheme().LIST_ITEM.categoryColor)
            .onClick(() => {
              this.showRenameDialog = false;
              this.renameBook = null;
              this.renameBookName = '';
            })

          Button('确定')
            .width('48%')
            .height(44)
            .backgroundColor(this.getColorScheme().TYPE_SELECTOR.activeBackground)
            .fontColor('#FFFFFF')
            .onClick(() => {
              this.renameBookConfirm();
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('85%')
      .padding(20)
      .backgroundColor(this.getColorScheme().DIALOG.backgroundColor)
      .borderRadius(12)
      .shadow({ radius: 20, color: '#00000040' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#00000040')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.showRenameDialog = false;
    })
  }

  formatDate(isoString: string): string {
    const date = new Date(isoString);
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  }
}
