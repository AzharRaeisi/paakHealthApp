class OrderStatus{
  static String status(int st){
    switch(st){
      case 1:
        return 'Pending';
        break;
      case 2:
        return 'Accept';
        break;
      case 3:
        return 'Ongoing';
        break;
      case 4:
        return 'Delivered';
        break;
      case 5:
        return 'Reject';
        break;
      default:
        return '';
        break;
    }
  }
}