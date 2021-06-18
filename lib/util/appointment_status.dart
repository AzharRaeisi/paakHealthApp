class AppointmentStatus{
  static String status(int st){
    switch(st){
      case 1:
        return 'Pending';
        break;
      case 2:
        return 'Accept';
        break;
      case 3:
        return 'rejected';
        break;
      case 4:
        return 'completed';
        break;
      default:
        return '';
        break;
    }
  }
}