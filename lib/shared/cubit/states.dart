
abstract class AppStates{}

class AppInitialState extends AppStates{}

class AddPersonneState extends AppStates{}

class SubPersonneState extends AppStates{}

class IncrementSinf extends AppStates{}

class ClearDataState extends AppStates{}

class CreateDatabaseState extends AppStates{}

class GetDatabaseState extends AppStates{}

class InsertToDatabaseState extends AppStates{}

class UpdateDatabaseState extends AppStates{}

class DeleteDatabaseState extends AppStates{}

class GetDatabaseLoadingState extends AppStates{}


class AuthLoadingState extends AppStates{}

class AuthSuccessState extends AppStates{}

class AuthErrorState extends AppStates{}


class InsertNeedsLoadingState extends AppStates{}

class InsertNeedsSuccessState extends AppStates{}

class InsertNeedsErrorState extends AppStates{}


class GetNeedsState extends AppStates{}

class GetNeedsLoadingState extends AppStates{}

class GetNeedErrorState extends AppStates{}


class UpdateNeedLoadingState extends AppStates{}

class UpdateNeedSuccessState extends AppStates{}

class UpdateNeedErrorState extends AppStates{}


class DeleteNeedLoadingState extends AppStates{}

class DeleteNeedSuccessState extends AppStates{}

class DeleteNeedErrorState extends AppStates{}


class GetUsersState extends AppStates{}

class GetUsersLoadingState extends AppStates{}

class GetUsersErrorState extends AppStates{}


class GetMessageSuccessState extends AppStates{}

class SendMessageSuccessState extends AppStates{}

class SendMessageErrorState extends AppStates{}


class AddFriendSuccessState extends AppStates{}

class AddFriendErrorState extends AppStates{}


class GetFriendsSuccessState extends AppStates{}

class GetFriendsErrorState extends AppStates{}