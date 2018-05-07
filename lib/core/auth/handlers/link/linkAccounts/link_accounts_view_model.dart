import 'dart:async';

import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:meta/meta.dart';

class ViewModelItem {
  ViewModelItem(
      {@required this.isActive,
      @required this.providerName,
      @required this.title,
      this.subTitle,
      this.linkableProvider});

  bool isActive;

  String providerName;
  String title;
  String subTitle;

  LinkableProvider linkableProvider;
}

class ViewModel {
  List<ViewModelItem> items;

  Future<ViewModel> loadItems(AuthService authService) async {
    var viewModels = new List<ViewModelItem>();
    var user = await authService.currentUser();

    //have the active accounts displayed first
    for (var authProv in user.providerAccounts) {
      viewModels.add(new ViewModelItem(
          isActive: true,
          providerName: authProv.providerName,
          title: authProv.email));
    }

    // and then the available ones after
    for (var linkProv in authService.linkProviders) {
      if (!viewModels.any((vm) => vm.providerName == linkProv.providerName)) {
        viewModels.add(new ViewModelItem(
            isActive: false,
            providerName: linkProv.providerName,
            linkableProvider: linkProv,
            title: 'Add ${linkProv.providerDisplayName} Account'));
      }
    }

    items = viewModels;

    return this;
  }
}
