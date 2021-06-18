class APIResponse {
  Map<String, dynamic> data;
  int favoriteStatus;
  String total_amount;
  List<dynamic> list;
  String status;
  String name;
  String url;
  String message;
  int wallet_amount;

  APIResponse(
      {this.data, this.favoriteStatus,this.total_amount, this.list, this.name, this.status, this.url, this.wallet_amount, this.message});
}
