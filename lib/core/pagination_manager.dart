mixin PaginationManager<M> {
  final List<M> _models = [];
  bool _isLoadingNow = false;
  bool _hasNext = false;
  bool _hasPrevious = true;

  List<M> get getUpdatedData => _models;

  bool get currentLoadingState => _isLoadingNow;

  bool get shouldLoadMore {
    return (!_isLoadingNow && _hasNext);
  }

  void startPaginationLoading() {
    _isLoadingNow = true;
  }

  void stopPaginationLoading() {
    _isLoadingNow = false;
  }

  void resetPagination() {
    _models.clear();
  }

  void alignPaginationWithApi(bool hasPrevious, bool hasNext, List<M> models) {
    _setData(hasPrevious, hasNext, models);
    _fireCallbacks();
  }

  void _setData(bool hasPrevious, bool hasNext, List<M> models) {
    _hasPrevious = hasPrevious;
    _hasNext = hasNext;
    if (!_hasPrevious) _models.clear();
    _models.addAll(models);
  }

  void _fireCallbacks() {
    if (!_hasPrevious && !_hasNext) {
      onlyOnePageCallback();
    } else {
      if (!_hasPrevious) firstPageCallback();
      if (!_hasNext) lastPageCallback();
    }

    receivedData(_models);
  }

  // option to have callbacks

  void receivedData(List<M> models) {}

  void firstPageCallback() {}

  void lastPageCallback() {}

  void onlyOnePageCallback() {}
}
