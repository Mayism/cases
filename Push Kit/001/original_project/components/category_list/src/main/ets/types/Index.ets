export interface CategoryItem {
  id: string;
  label: string;
  iconUrl?: ResourceStr;
  subCategoryId?: string[];
}

export interface StoreItem {
  distance: string;
  name: string;
  address: string;
  categoryName: string;
}

export interface SubCategoryItem {
  id: string;
  label: string;
  itemList: ItemInfo[];
}

export interface ItemInfo {
  id: string;
  title: string;
  imgSrc?: ResourceStr;
  description?: string;
}