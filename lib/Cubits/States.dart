// ignore_for_file: file_names

abstract class AppStates {}


class AppInitialState extends AppStates{}
class AppChangeBotNavBar extends AppStates{}
class AppCreateDataBaseState extends AppStates{}
class AppGetDataBaseState extends AppStates{}
class AppUpdateDataBaseState extends AppStates{}
class AppDeleteDataBaseState extends AppStates{}
class AppGetDataBaseLoadingState extends AppStates{}
class AppInsertDataBaseState extends AppStates{}
class AppChangeBottomSheet extends AppStates{}