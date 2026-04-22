import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import {
  FilterTagAndList,
  SearchItem,
  SearchSource,
  SearchViewController,
  SearchWordItem,
  SetValueParams,
  TextSegment,
} from '../types/Type';

@ObservedV2
export class SearchViewModel {
  private static _instance: SearchViewModel | null;
  @Trace breakpoint: string = 'sm';
  @Trace searchWords: string = '';
  @Trace routerStack: NavPathStack = new NavPathStack();
  @Trace searchSuggestionList: SearchWordItem[] = [];
  @Trace matchWords: string[] = [];
  @Trace searchResults: FilterTagAndList[] = [];
  @Trace showSearchSuggestionRsp: boolean = false;
  @Trace showSearchRsp: boolean = false;
  @Trace showSearchSuggestionRspInResult: boolean = false;
  @Trace confirmKeyWord: boolean = false; // 确认关键词或用户输入
  @Trace isTabletBar: boolean = false;
  @Trace showPopup: boolean = false;
  @Trace showPopupInResult: boolean = false;
  @Trace isFocus: boolean = false;
  @Trace isResultPopup: boolean = false;
  @Trace searchController: SearchController = new SearchController();
  @Trace searchResultController: SearchController = new SearchController();
  @Trace placeholder: string[] = ['Search'];
  @Trace themeColor: ResourceColor = '#0A59F7';
  @Trace showFilterTag: boolean = true;
  @Trace showGuessLike: boolean = true;
  @Trace showHotSearch: boolean = true;
  @Trace isShallowWindow: boolean = false;
  @Trace tabBarScroller: Scroller = new Scroller();
  @Trace scroller: Scroller = new Scroller();
  @Trace controller: SearchViewController = new SearchViewController();
  @Trace linkChangeStatus: number = 0;
  @Trace resultsChangeStatus: number = 0;
  timer: number | null = null;
  suggestionItemBuilderParam: WrappedBuilder<[string, number]> | undefined = undefined;
  guessItemBuilderParam: WrappedBuilder<[string]> | undefined = undefined;
  hotItemBuilderParam: WrappedBuilder<[SearchItem, number]> | undefined = undefined;
  resultItemBuilderParam: WrappedBuilder<[SearchItem]> | undefined = undefined;
  private lastRequestTime = 0;

  public static getInstance(reCreate: boolean = false) {
    if (!SearchViewModel._instance || reCreate) {
      SearchViewModel._instance = new SearchViewModel();
    }
    return SearchViewModel._instance;
  }

  public static processText(input: string, keywords: string[]): TextSegment[] {
    const segments: TextSegment[] = [];
    let lastIndex = 0;

    // 生成一个正则表达式，将所有的关键词组合成一个或逻辑
    const escapedKeywords = keywords.map(keyword =>
    keyword.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'),
    );
    const regex = new RegExp(escapedKeywords.join('|'), 'gi');

    input.replace(regex, (match, offset: number) => {
      // 添加非高亮部分
      if (offset > lastIndex) {
        segments.push({
          text: input.substring(lastIndex, offset),
          isHighlight: false,
        });
      }

      // 添加高亮部分
      segments.push({
        text: match,
        isHighlight: true,
      });

      lastIndex = offset + match.length;
      return match;
    });

    if (lastIndex < input.length) {
      segments.push({
        text: input.substring(lastIndex),
        isHighlight: false,
      });
    }
    return segments;
  }

  handleSearch: (keyWord: string | SearchWordItem | SearchItem,
    searchSource: SearchSource) => Promise<FilterTagAndList[]> =
    () => Promise.resolve([]);
  searchSuggestion: (keyWord: string) => Promise<[SearchWordItem[], string[]]> = () => Promise.resolve([[], []]);
  getMore: () => void = () => {
  }
  onClickResultItem: (listItem: SearchItem) => void = () => {
  }
  queryHistoryList: () => Promise<SearchWordItem[]> = () => Promise.resolve([]);
  deleteHistoryList: () => Promise<SearchWordItem[]> = () => Promise.resolve([]);
  queryGuessList: () => Promise<SearchWordItem[]> = () => Promise.resolve([]);
  queryHotSearchList: () => Promise<SearchItem[]> = () => Promise.resolve([]);

  setValue(params: SetValueParams) {
    this.routerStack = params.routerStack!;
    this.placeholder = params.placeholder!;
    this.themeColor = params.themeColor!;
    this.showFilterTag = params.showFilterTag!;
    this.showGuessLike = params.showGuessLike!;
    this.showHotSearch = params.showHotSearch!;
    this.isShallowWindow = params.isShallowWindow!;
    this.tabBarScroller = params.tabBarScroller!;
    this.scroller = params.scroller!;
    this.controller = params.controller!;
    this.handleSearch = params.handleSearch!;
    this.searchSuggestion = params.searchSuggestion!;
    this.getMore = params.getMore!;
    this.onClickResultItem = params.onClickResultItem!;
    this.queryHistoryList = params.queryHistoryList!;
    this.queryGuessList = params.queryGuessList!;
    this.queryHotSearchList = params.queryHotSearchList!;
    this.suggestionItemBuilderParam = params.suggestionItemBuilderParam;
    this.guessItemBuilderParam = params.guessItemBuilderParam;
    this.hotItemBuilderParam = params.hotItemBuilderParam;
    this.resultItemBuilderParam = params.resultItemBuilderParam;
    this.deleteHistoryList = params.deleteHistoryList!;
  }

  pushResultPage(uiContext: UIContext, value: string | SearchWordItem | SearchItem, searchSource: SearchSource) {
    this.showPopup = false;
    this.isTabletBar = true;
    this.submitSearch(uiContext, value, searchSource, this.handleSearch);
    this.routerStack.pushPathByName('ResultPage', null)
  }

  submitSearch(uiContext: UIContext,
    keyword: string | SearchWordItem | SearchItem,
    searchSource: SearchSource,
    callback: (value: string | SearchWordItem | SearchItem,
      searchSource: SearchSource) => Promise<FilterTagAndList[]>) {

    // 时间戳过滤过期请求
    const requestTime = Date.now();
    this.lastRequestTime = requestTime;
    this.confirmKeyWord = true;

    if (searchSource === SearchSource.USER_INPUT) {
      let keywordValue: string;
      keywordValue = keyword as string;
      if (keywordValue.length === 0) {
        uiContext.getPromptAction().showToast({
          message: '输入内容不能为空',
        });
        return;
      }
      this.searchWords = keywordValue;
    }

    if ([1, 2, 4].includes(searchSource)) {
      let keywordValue: SearchWordItem;
      keywordValue = keyword as SearchWordItem;
      if (keywordValue.content.length === 0) {
        uiContext.getPromptAction().showToast({
          message: '输入内容不能为空',
        });
        return;
      }
      this.searchWords = keywordValue.content;
    }

    if (searchSource === SearchSource.HOT_SEARCH) {
      let keywordValue: SearchItem;
      keywordValue = keyword as SearchItem;
      if (keywordValue.title.length === 0) {
        uiContext.getPromptAction().showToast({
          message: '输入内容不能为空',
        });
        return;
      }
      this.searchWords = keywordValue.title;
    }
    callback(keyword, searchSource).then((searchResults) => {
      if (requestTime === this.lastRequestTime) {
        this.searchResults = searchResults;
        this.resultsChangeStatus = Date.now();
        if ((['lg', 'xl'].includes(this.breakpoint)) && this.isShallowWindow) {
          this.showSearchSuggestionRspInResult = this.searchSuggestionList.length ? true : false;
        }
        this.showSearchRsp = true;
        this.showSearchSuggestionRsp = false;
        setTimeout(() => {
          this.confirmKeyWord = false;
        }, 100)
      }

    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'SearchView', `SubmitSearch failed. Code: ${err.code}, message: ${err.message}`);
    });
    ;
  }

  searchQuery(input: string, callback: (value: string) => Promise<[SearchWordItem[], string[]]>) {
    this.searchWords = input;
    if (this.confirmKeyWord) {
      this.confirmKeyWord = false;
      if (this.searchWords.length === 0) {
        this.initSearchParam();
      }
      return;
    }

    // 时间戳过滤过期请求
    const requestTime = Date.now();
    this.lastRequestTime = requestTime;

    if (this.searchWords.length === 0) {
      this.initSearchParam();
      return;
    }

    // 防抖
    if (this.timer !== null) {
      clearTimeout(this.timer);
    }

    this.timer = setTimeout(async () => {
      callback(this.searchWords).then((result) => {
        if (requestTime === this.lastRequestTime) {
          this.searchSuggestionList = result[0];
          this.matchWords = result[1];
          this.linkChangeStatus = Date.now();
          if ((['lg', 'xl'].includes(this.breakpoint)) && this.isShallowWindow) {
            this.showSearchSuggestionRspInResult = true;
          }
          this.showSearchSuggestionRsp = true;
          this.showSearchRsp = false;
        }

      }).catch((err: BusinessError) => {
        hilog.error(0x0000, 'SearchView', `SearchQuery failed. Code: ${err.code}, message: ${err.message}`);
      });

    }, 300)
  }

  initSearchParam = () => {
    this.showSearchSuggestionRsp = false;
    this.showSearchSuggestionRspInResult = false;
    this.showSearchRsp = false;
    if ((['lg', 'xl'].includes(this.breakpoint)) && this.isShallowWindow) {
      this.searchController.stopEditing();
      this.searchResultController.stopEditing();
    }
    this.searchWords = '';
    this.searchSuggestionList = [];
  }
  closePop = () => {
    this.showPopup = false;
    this.showPopupInResult = false;
    this.searchController.stopEditing();
    this.searchResultController.stopEditing();
  }

  toggleState(bp: string) {
    if (!this.isTabletBar && (['lg', 'xl'].includes(bp)) && !this.showSearchRsp) {
      this.isTabletBar = true;
      this.routerStack.pop(false);
    }
  }

  setWindowScreen(isFull: boolean, _context: Context) {
    window.getLastWindow(_context).then((win) => {
      win.setWindowLayoutFullScreen(isFull).catch((err: BusinessError) => {
        hilog.error(0x0000, 'SearchView', 'set window layout failed. error: ' + JSON.stringify(err))
      })
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'SearchView', 'get last window failed. error: ' + JSON.stringify(err))
    })
  }
}