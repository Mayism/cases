import { BasicDataSource } from '../common/BasicDataSource';
import { Constants } from '../common/Constant';
import { GridRowColSetting } from '../common/GridRowColSetting';
import { GuessLike } from '../components/GuessLike';
import { HistorySearch } from '../components/HistorySearch';
import { HotSearch } from '../components/HotSearch';
import { SearchAutoComplete } from '../components/SearchAutoComplete';
import { SearchBar } from '../components/SearchBar';
import { SearchResult } from '../components/SearchResult';
import { SearchItem, SearchSource } from '../types/Type';
import { SearchViewModel } from '../viewmodel/SearchViewModel';

@Builder
export function ResultPageBuilder() {
  ResultPage()
}

@ComponentV2
export struct ResultPage {
  @Local curTabIndex: number = 0;
  @Local vm: SearchViewModel = SearchViewModel.getInstance();
  @Local routerStack: NavPathStack = new NavPathStack();
  @Local dataSource: BasicDataSource<SearchItem> = new BasicDataSource();
  @Local columnWidth: number = 0;
  @Local maxLen: number = 0;
  @Local containerWidth: number = 0;
  @Local bp: string = 'sm';
  uiContext: UIContext = this.getUIContext();

  aboutToAppear(): void {
    if (this.vm.searchResults.length) {
      this.dataSource.setData(this.vm.searchResults[this.curTabIndex].itemList);
    }
    this.vm.isResultPopup = true;
    this.vm.showPopupInResult = false;
    this.bp = this.vm.breakpoint;
  };

  aboutToDisappear(): void {
    this.vm.isResultPopup = false;
  }

  @Monitor('curTabIndex')
  onListChange() {
    this.dataSource.setData(this.vm.searchResults[this.curTabIndex].itemList);
  }

  @Monitor('bp')
  onChange() {
    this.calculateWidth();
    this.vm.closePop();
    this.vm.toggleState(this.bp);
  }

  build() {
    NavDestination() {
      Column() {
        Row({ space: Constants.SPACE_S }) {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_left'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize(Constants.CHEVRON_WIDTH)
          }
          .width(Constants.BACK_BACKGROUND_WIDTH)
          .height(Constants.BACK_BACKGROUND_HEIGHT)
          .backgroundColor($r('sys.color.comp_background_tertiary'))

          Text(this.vm.placeholder[0])
            .fontSize($r('sys.float.Title_S'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('sys.color.font_primary'))
        }
        .margin({
          left: GridRowColSetting.getPageMargin(this.bp),
          right: GridRowColSetting.getPageMargin(this.bp),
        })
        .padding({ top: Constants.PADDING_S, bottom: Constants.PADDING_S })
        .width(Constants.FULL_PERCENT)
        .constraintSize({ maxWidth: Constants.FULL_PERCENT })
        .onClick(() => {
          this.routerStack?.pop?.();
          if ((['lg', 'xl'].includes(this.bp)) && this.vm.isShallowWindow) {
            this.vm.showPopupInResult = false;
            this.vm.isResultPopup = false;
            this.vm.initSearchParam();
          }
        });

        GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
          GridCol({
            span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS,
          }) {
            Row() {
              SearchBar({
                placeholder: this.vm.placeholder,
                searchWords: this.vm.searchWords,
                themeColor: this.vm.themeColor,
                controller: this.vm.searchResultController,
                isResult: this.vm.isResultPopup,
                updateSearchWords: (value) => {
                  if ((['lg', 'xl'].includes(this.bp)) && this.vm.isShallowWindow) {
                    if (this.vm.isResultPopup) {
                      this.vm.searchQuery(value, this.vm.searchSuggestion)
                    }
                  } else {
                    this.vm.searchQuery(value, this.vm.searchSuggestion)
                  }
                },
                submitSearch: (value) => {
                  this.vm.submitSearch(this.uiContext, value, SearchSource.USER_INPUT, this.vm.handleSearch);
                  if ((['lg', 'xl'].includes(this.bp)) && this.vm.isShallowWindow) {
                    this.vm.closePop();
                  }
                },
              })
                .layoutWeight(1)
                .constraintSize({
                  maxWidth: ((['lg', 'xl'].includes(this.bp)) && this.vm.isShallowWindow) ?
                    GridRowColSetting.DIALOG_MAX_WIDTH : 'auto',
                })
                .bindPopup(this.vm.showPopupInResult, {
                  builder: this.searchWindowBuilder(),
                  width: GridRowColSetting.DIALOG_MAX_WIDTH,
                  targetSpace: Constants.SPACE_S,
                  placement: Placement.Bottom,
                  enableArrow: false,
                  mask: false,
                  autoCancel: false,
                  onWillDismiss: () => {
                    this.vm.closePop();
                  },
                  onStateChange: (event) => {
                    console.log('onStateChange========' + event.isVisible);
                  },
                })
            }
            .onSizeChange((oldSize, newSize) => {
              this.containerWidth = newSize.width as number
              this.calculateWidth()
            })
            .justifyContent(FlexAlign.SpaceBetween)
            .width(Constants.FULL_PERCENT)
          }
        }
        .margin({
          left: GridRowColSetting.getPageMargin(this.bp),
          right: GridRowColSetting.getPageMargin(this.bp),
        })
        .onBreakpointChange((bp) => {
          this.bp = bp;
          this.vm.breakpoint = bp;
        })

        if ((['lg', 'xl'].includes(this.bp)) && this.vm.isShallowWindow) {
          SearchResult({
            themeColor: this.vm.themeColor,
            breakpoint: 'lg',
            showFilterTag: this.vm.showFilterTag,
            tabBarScroller: this.vm.tabBarScroller,
            scroller: this.vm.scroller,
            itemBuilderParam: this.vm.resultItemBuilderParam,
            onClickResultItem: this.vm.onClickResultItem,
          })

        } else {
          if (this.vm.showSearchSuggestionRsp) {
            SearchAutoComplete({
              themeColor: this.vm.themeColor,
              breakpoint: this.bp,
              itemBuilderParam: this.vm.suggestionItemBuilderParam,
              selectSuggestionItem: (value) => {
                this.vm.submitSearch(this.uiContext, value, SearchSource.SUGGESTION, this.vm.handleSearch);
              },
            })

          } else if (this.vm.showSearchRsp) {
            SearchResult({
              themeColor: this.vm.themeColor,
              breakpoint: this.bp,
              showFilterTag: this.vm.showFilterTag,
              tabBarScroller: this.vm.tabBarScroller,
              scroller: this.vm.scroller,
              itemBuilderParam: this.vm.resultItemBuilderParam,
              onClickResultItem: this.vm.onClickResultItem,
            })

          } else {
            Scroll() {
              Column() {
                HistorySearch({
                  breakpoint: this.bp,
                  maxLen: this.maxLen,
                  columnWidth: this.columnWidth,
                  deleteHistoryList: this.vm.deleteHistoryList,
                  selectHistoryItem: (value) => {
                    this.vm.submitSearch(this.uiContext, value, SearchSource.HISTORY, this.vm.handleSearch);
                  },
                  queryHistoryList: this.vm.queryHistoryList,
                })

                if (this.vm.showGuessLike) {
                  GuessLike({
                    breakpoint: this.bp,
                    itemBuilderParam: this.vm.guessItemBuilderParam,
                    selectGuessLikeItem: (value) => {
                      this.vm.submitSearch(this.uiContext, value, SearchSource.RECOMMEND, this.vm.handleSearch);
                    },
                    queryGuessList: this.vm.queryGuessList,
                  })
                }

                if (this.vm.showHotSearch) {
                  HotSearch({
                    breakpoint: this.bp,
                    itemBuilderParam: this.vm.hotItemBuilderParam,
                    getMore: this.vm.getMore,
                    selectHotSearchItem: (value) => {
                      this.vm.submitSearch(this.uiContext, value, SearchSource.HOT_SEARCH, this.vm.handleSearch);
                    },
                    queryHotSearchList: this.vm.queryHotSearchList,
                  })
                }
              }
            }
            .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
            .align(Alignment.Top)
            .scrollBar(BarState.Off)
            .layoutWeight(1)
            .margin({
              left: GridRowColSetting.getPageMargin(this.bp),
              right: GridRowColSetting.getPageMargin(this.bp),
            })
          }
        }
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.End)
      .height(Constants.FULL_PERCENT)
      .width(Constants.FULL_PERCENT)
      .onClick(() => {
        if ((['lg', 'xl'].includes(this.bp)) && this.vm.isShallowWindow) {
          this.vm.closePop();
        }
      })
    }
    .onBackPressed(() => {
      if (this.vm.searchWords.length) {
        this.vm.initSearchParam();
        return true;
      }
      return false;
    })
    .onShown(() => {
      this.vm.setWindowScreen(false, this.getUIContext().getHostContext()!)
    })
    .onHidden(() => {
      this.vm.setWindowScreen(true, this.getUIContext().getHostContext()!)
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.routerStack = ctx.pathStack;
    })
  }

  @Builder
  searchWindowBuilder() {
    if (this.vm.showSearchSuggestionRspInResult) {
      SearchAutoComplete({
        breakpoint: 'sm',
        themeColor: this.vm.themeColor,
        itemBuilderParam: this.vm.suggestionItemBuilderParam,
        selectSuggestionItem: (value) => {
          this.vm.closePop();
          this.vm.submitSearch(this.uiContext, value, SearchSource.SUGGESTION, this.vm.handleSearch);
        },
      })
        .constraintSize({ maxHeight: 'calc(100% - 148vp)' })

    } else {
      Scroll() {
        Column() {
          HistorySearch({
            breakpoint: 'sm',
            maxLen: 2 * ((400 - 56) / 4) + 8,
            columnWidth: (400 - 56) / 4,
            deleteHistoryList: this.vm.deleteHistoryList,
            selectHistoryItem: (value) => {
              this.vm.closePop();
              this.vm.submitSearch(this.uiContext, value, SearchSource.HISTORY, this.vm.handleSearch);
            },
            queryHistoryList: this.vm.queryHistoryList,
          })

          if (this.vm.showGuessLike) {
            GuessLike({
              breakpoint: 'sm',
              itemBuilderParam: this.vm.guessItemBuilderParam,
              selectGuessLikeItem: (value) => {
                this.vm.closePop();
                this.vm.submitSearch(this.uiContext, value, SearchSource.RECOMMEND, this.vm.handleSearch);
              },
              queryGuessList: this.vm.queryGuessList,
            })
          }

          if (this.vm.showHotSearch) {
            HotSearch({
              breakpoint: 'sm',
              itemBuilderParam: this.vm.hotItemBuilderParam,
              getMore: this.vm.getMore,
              selectHotSearchItem: (value) => {
                this.vm.closePop();
                this.vm.submitSearch(this.uiContext, value, SearchSource.HOT_SEARCH, this.vm.handleSearch);
              },
              queryHotSearchList: this.vm.queryHotSearchList,
            })
          }
        }
      }
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .constraintSize({ maxHeight: 'calc(100% - 148vp)' })
      .margin({
        left: Constants.PADDING_XL,
        right: Constants.PADDING_XL,
      })
    }
  }

  calculateWidth = () => {
    this.columnWidth = (this.containerWidth - GridRowColSetting.getGutter(this.bp) *
      (GridRowColSetting.getWindowColumn(this.bp) - 1)) /
    GridRowColSetting.getWindowColumn(this.bp);
    this.maxLen = GridRowColSetting.getMaxColumns(this.bp) * this.columnWidth +
      GridRowColSetting.getMaxGutter(this.bp) * GridRowColSetting.getGutter(this.bp)
  }
}