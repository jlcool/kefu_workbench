import 'package:kefu_workbench/provider/global.dart';

import '../core_flutter.dart';

class HomeProvide with ChangeNotifier {

  static HomeProvide instance;

   // 单例
  static HomeProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = HomeProvide();
    return instance;
  }


  /// 是否显示loading
  bool isFullLoading = false;

  ///  所有未读消息
  int get contactReadCount{
    int count = 0;
    for(var i =0; i<GlobalProvide.getInstance().contacts.length; i++){
      count = count + GlobalProvide.getInstance().contacts[i].read;
    }
    return count;
  }

  /// 选中用户
  void selectContact(ContactModel contact){
    GlobalProvide.getInstance().setCurrentContact(contact);
  }

  /// 刷新
  Future<bool> onRefresh() async{
    await getContacts();
    UX.showToast("刷新成功~", position: ToastPosition.top);
    return true;
  }

  /// 设置是否显示loading
  void setFullLoading(bool isShow){
    isFullLoading = isShow;
    notifyListeners();
  }

   /// MessageService
  MessageService messageService = MessageService.getInstance();

  /// 退出登录
  void logout(BuildContext context) {
    UX.alert(context, content: "您确定退出登录吗？", onConfirm: () {
      Navigator.pushNamedAndRemoveUntil(context, "/login", ModalRoute.withName('/'), arguments: {"isAnimate": false});
      UX.showToast("已退出登录~");
      GlobalProvide.getInstance().applicationLogout();
    });
  }

  /// 获取聊天列表
  Future<void> getContacts({bool isFullLoading = false}) async{
    setFullLoading(isFullLoading);
    await GlobalProvide.getInstance().getContacts();
    setFullLoading(false);
  }

  @override
  void dispose() {
    instance = null;
    super.dispose();
  }

  
}
