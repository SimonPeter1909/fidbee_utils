import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PullToRefresh {
  RefreshController _refreshController;

  PullToRefresh(this._refreshController);

  RefreshController get refreshController => _refreshController;

  onRefreshComplete() {
    refreshController.refreshCompleted();
  }

  listView({@required Function refresh, @required Widget listViewBuilder}) {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: refresh,
      child: listViewBuilder,
      header: WaterDropHeader(),
    );
  }
}
