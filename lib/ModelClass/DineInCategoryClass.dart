class CATEGORY {
  String id;
  String title;
  String isSelect;
  List<ITEM> itemList;
  CATEGORY(
    this.id,
    this.title,
    this.isSelect,
    this.itemList,
  );
}

class ITEM {
  String id;
  String itemName;
  String itemContent;
  String quantity;
  String note;
  String isAddedtoCart;
  String actualPrice;
  String image;
  List<SIZE> itemSize;
  List<EXTRA> itemextra;
  ITEM(
    this.id,
    this.itemName,
    this.itemContent,
    this.quantity,
    this.note,
    this.isAddedtoCart,
    this.actualPrice,
    this.image,
    this.itemSize,
    this.itemextra,
  );
}

class SIZE {
  String title;
  String extraPrice;
  String isSelected;
  SIZE(
    this.title,
    this.extraPrice,
    this.isSelected,
  );
}

class EXTRA {
  String title;
  String extraPrice;
  String isSelected;
  EXTRA(
    this.title,
    this.extraPrice,
    this.isSelected,
  );
}
