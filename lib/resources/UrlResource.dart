class UrlResourece{
  static String BASE_URL = "http://192.168.1.6/imaginationevents/api/";
  static String BASE_IMG_URL = "http://192.168.1.6/imaginationevents/admin/uploads/";

  //for home
  // static String BASE_URL = "http://192.168.205.245/imaginationevents/api/";
  // static String BASE_IMG_URL = "http://192.168.205.245/imaginationevents/admin/uploads/";

  //for image get
  static String EVENTS = BASE_IMG_URL + "addevents/";
  static String LASTEVENTS = BASE_IMG_URL + "addevents/";
  static String ORG = BASE_IMG_URL + "evetorganizer/";
  static String CATIMG = BASE_IMG_URL + "eventcatagory/";
  static String STATEIMG = BASE_IMG_URL + "state/";
  static String ADSIMG = BASE_IMG_URL + "adsimg/";
  static String USERIMG = BASE_IMG_URL + "user/";

  //for all data
  static String LOGIN = BASE_URL + "login.php";
  static String ORGANIZERLOGIN = BASE_URL + "organizerlogin.php";
  static String REGISTER = BASE_URL + "register.php";
  static String HOME = BASE_URL + "register.php";
  static String ALLEVENTS = BASE_URL + "events.php";
  static String USEREVENTS = BASE_URL + "userallevents.php";
  static String LAST_EVENTS = BASE_URL + "lastevents.php";
  static String BOOKINGS = BASE_URL + "bookings.php";
  static String ADDTICKETS = BASE_URL + "addtickets.php";
  static String ADDEVENTS = BASE_URL + "addevents.php";
  static String EVENTSCAT = BASE_URL + "eventsbycatagories.php";
  static String EVENTS_STATE = BASE_URL + "eventsbystate.php";
  static String TICKETS = BASE_URL + "teckets.php";
  static String ALLADS = BASE_URL + "allads.php";
  static String ALLFAQ = BASE_URL + "allfaq.php";
  static String ALLBOOKING = BASE_URL + "userbookinglist.php";
  static String ADDIQUIRY = BASE_URL + "addinquiry.php";
  static String ALLREVIEWS = BASE_URL + "allreviews.php";
  static String ADDREVIEWS = BASE_URL + "addreviews.php";
  static String ADDBOOKING = BASE_URL + "addbooktickets.php";
  static String ENTERY_TICKETS = BASE_URL + "tickets_entry.php";
  static String ORGEVENTSDETAILS = BASE_URL + "org_events_details.php";
  static String GETTICKETS = BASE_URL + "alltickets.php";
  static String GETPAYMENTS = BASE_URL + "allpayments.php";
  static String ALLORGEVENTS = BASE_URL + "orgevents.php";
  static String ALLSTATE = BASE_URL + "allstate.php";
  static String STATEVISEEVENTS = BASE_URL + "state_events.php";
  static String ALLCITY = BASE_URL + "allcity.php";


  //forenge key api
  static String ALLCITYDATA = BASE_URL + "allcitydata.php";
  static String ALLSTATEDATA = BASE_URL + "allstatedata.php";
  static String ALLEVENTSDATA = BASE_URL + "alleventsdata.php";
  static String ALLORGDATA = BASE_URL + "allorgdata.php";
  static String ALLEVENTSNAME = BASE_URL + "alleventsnamedata.php";

  //user profile
  static String USER = BASE_URL + "userprofile.php";
  static String ORGPROFILE = BASE_URL + "orgprofile.php";

  //sub catagory for events
  static String SUBCATAGORYEVENTS = BASE_URL + "subcatagory.php";

  //change password
  static String CHANGEUSERPASS = BASE_URL + "user_changepassword.php";
  static String CHANGEORGPASS = BASE_URL + "org_changepassword.php";

  //forgot password
  static String FORGOTUSERPASS = BASE_URL + "user_forgotpassword.php";
  static String FORGOTORGPASS = BASE_URL + "org_forgotpassword.php";

  //for Update Events and Tickets
  static String UPDATEEVENTS = BASE_URL + "update_events.php";
  static String UPADTETICKETS = BASE_URL + "update_tickets.php";

  //for Delete Events and Tickets
  static String DELETETICKETS = BASE_URL + "delete_ticket.php";
  static String DELETEEVENTS = BASE_URL + "delete_events.php";
  static String ORGDELETETICKETS = BASE_URL + "org_delete_ticket.php";

}