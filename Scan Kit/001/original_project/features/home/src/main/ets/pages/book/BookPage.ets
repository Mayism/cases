import { CommonPage } from 'common';
import { BookFilterListCom } from '../../components/book/BookFilterListCom';
import { BookStoreListCom } from '../../components/book/BookStoreListCom';
import { BookVM } from '../../viewmodels/BookVM';

@ComponentV2
export struct BookPage {
  vm: BookVM = BookVM.instance;

  async aboutToAppear() {
    this.vm.resetBookParams();
  }

  build() {
    CommonPage({
      title: '预约订座',
      mainUi: () => {
        this.bookMainUiBuilder();
      },
    })
  }

  @Builder
  bookMainUiBuilder() {
    /** 搜索框 **/
    Search({ value: $$this.vm.query, placeholder: '搜索门店' }).margin(0)

    /** 筛选栏 **/
    BookFilterListCom()

    /** 门店列表 **/
    BookStoreListCom().constraintSize({ minHeight: '48%' }).layoutWeight(1)
  }
}

@Builder
export function bookPageBuilder() {
  BookPage()
}