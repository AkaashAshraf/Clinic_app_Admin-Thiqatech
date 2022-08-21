import 'package:demoadmin/screens/appointmentScreen/appConfimationPage.dart';
import 'package:demoadmin/screens/appointmentScreen/appointmentListPage.dart';
import 'package:demoadmin/screens/appointmentScreen/editAppointmetDetailsPage.dart';
import 'package:demoadmin/screens/appointmentTypeScreen/addAppointmentTypes.dart';
import 'package:demoadmin/screens/appointmentTypeScreen/appointmentTypesPage.dart';
import 'package:demoadmin/screens/blockTime/blockTimePage.dart';
import 'package:demoadmin/screens/blogScreen/addBlogPage.dart';
import 'package:demoadmin/screens/blogScreen/blogPostPage.dart';
import 'package:demoadmin/screens/categoryScreen/categoryScreen.dart';
import 'package:demoadmin/screens/cityScreen/addCityPage.dart';
import 'package:demoadmin/screens/cityScreen/cityList.dart';
import 'package:demoadmin/screens/clinic/chooseClincCityPage.dart';
import 'package:demoadmin/screens/departmentScreen/dart/addDepartment.dart';
import 'package:demoadmin/screens/departmentScreen/dart/chooseDeptCityPage.dart';
import 'package:demoadmin/screens/departmentScreen/dart/departmentList.dart';
import 'package:demoadmin/screens/doctors/addDoctorsPage.dart';
import 'package:demoadmin/screens/doctors/chooseDoctCityPage.dart';
import 'package:demoadmin/screens/doctors/doctorsList.dart';
import 'package:demoadmin/screens/editAvailabilityPage.dart';
import 'package:demoadmin/screens/feedbackList.dart';
import 'package:demoadmin/screens/galleryScreen/ShowImagesPage.dart';
import 'package:demoadmin/screens/galleryScreen/addGalleryImages.dart';
import 'package:demoadmin/screens/galleryScreen/editgallerypage.dart';
import 'package:demoadmin/screens/itemsScreen/addItemScreen.dart';
import 'package:demoadmin/screens/itemsScreen/itemScreen.dart';
import 'package:demoadmin/screens/loginPage.dart';
import 'package:demoadmin/screens/order/orderListScreen.dart';
import 'package:demoadmin/screens/order/orderViewModel.dart';
import 'package:demoadmin/screens/prescription/prescriptionListPage.dart';
import 'package:demoadmin/screens/settingScreen/editSettingPage.dart';
import 'package:demoadmin/screens/testimonialsScreen/addTestimonials.dart';
import 'package:demoadmin/screens/testimonialsScreen/editTestimonialsPage.dart';
import 'package:demoadmin/screens/testimonialsScreen/testimonials.dart';
import 'package:demoadmin/screens/userScreen/registerPatientPage.dart';
import 'package:demoadmin/screens/userScreen/userLsitPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:demoadmin/notificationScreen/notificationDetailsPage.dart';
import 'package:demoadmin/notificationScreen/notificationListPage.dart';
import 'package:demoadmin/notificationScreen/sendNotificationPage.dart';
import 'package:demoadmin/notificationScreen/sendNotificationToAllUserPage.dart';
import 'package:demoadmin/notificationScreen/usersListForNotificationPage.dart';
import 'package:demoadmin/screens/editBannerImagesPage.dart';
import 'package:demoadmin/screens/editOpeningClosingTimePage.dart';
import 'package:demoadmin/screens/editProfilePage.dart';
import 'package:demoadmin/screens/homePage.dart';
import 'package:demoadmin/screens/searchScreen/searchAppointmentByIDPage.dart';
import 'package:demoadmin/screens/searchScreen/searchAppointmentByNamePage.dart';
import 'package:demoadmin/screens/searchScreen/searchUserByIdPage.dart';
import 'package:demoadmin/screens/searchScreen/searchUserByNamePage.dart';
import 'package:demoadmin/screens/serviceScreen/addServicePage.dart';
import 'package:demoadmin/screens/serviceScreen/servicePage.dart';
import 'package:demoadmin/screens/settingScreen/addDateToCloseBookingPage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // if (USE_FIRESTORE_EMULATOR) {
  //   FirebaseFirestore.instance.settings = Settings(
  //       host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  // }
  runApp(MyApp());
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
  //   statusBarColor: Colors.transparent,
  // ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => OrderViewModel(),
        ),
      ],
      child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              // primaryColor: primaryColor,
              // Define the default font family.
              // fontFamily: 'Georgia',
              ),
          // home: _defaultHome,
          // initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/LoginPage': (context) => LoginPage(), //EditAvailabilityPage(),
            //  AuthService().handleAuth(),
            '/AddGalleryImagesPage': (context) => AddGalleryImagesPage(),
            '/AddServicePage': (context) => AddServicePage(),
            '/EditAppointmentDetailsPage': (context) =>
                EditAppointmentDetailsPage(),
            '/AppointmentListPage': (context) => AppointmentListPage(),
            '/TestimonialsPage': (context) => TestimonialsPage(),
            '/EditGalleryPage': (context) => EditGalleryPage(),
            '/ServicesPage': (context) => ServicesPage(),
            '/EditProfilePage': (context) => EditProfilePage(),
            '/ShowImagesPage': (context) => ShowImagesPage(),
            '/EditOpeningClosingTime': (context) => EditOpeningClosingTime(),
            '/EditAvailabilityPage': (context) => EditAvailabilityPage(),
            '/AppointmentTypesPage': (context) => AppointmentTypesPage(),
            '/AddAppointmentTypesPage': (context) => AddAppointmentTypesPage(),
            '/EditBookingTiming': (context) => EditSettingPage(),
            '/UsersListPage': (context) => UsersListPage(),
            '/AddTestimonialPage': (context) => AddTestimonialPage(),
            '/EditTestimonialPage': (context) => EditTestimonialPage(),
            '/EditBannerImagesPage': (context) => EditBannerImagesPage(),
            '/HomePage': (context) => HomePage(),
            '/UsersListForNotificationPage': (context) =>
                UsersListForNotificationPage(),
            '/SendNotificationPage': (context) => SendNotificationPage(),
            '/SendNotificationToAllUserPage': (context) =>
                SendNotificationToAllUserPage(),
            '/NotificationListPage': (context) => NotificationListPage(),
            '/NotificationDetailsPage': (context) => NotificationDetailsPage(),
            '/SearchAppointmentByIdPage': (context) =>
                SearchAppointmentByIdPage(),
            '/SearchAppointmentByNamePage': (context) =>
                SearchAppointmentByNamePage(),
            '/AddDateToCloseBookingPage': (context) =>
                AddDateToCloseBookingPage(),
            '/SearchUserByNamePage': (context) => SearchUserByNamePage(),
            '/SearchUserByIdPage': (context) => SearchUserByIdPage(),
            '/NewBlogPostPage': (context) => NewBlogPostPage(),
            '/BlogPostPage': (context) => BlogPostPage(),
            '/ItemPage': (context) => ItemScreen(),
            '/categoryPage': (context) => CategoryScreen(),
            '/RegisterPatientPage': (context) => RegisterPatient(),
            '/PrescriptionListByIDPage': (context) => PrescriptionListByIDPage(),
            '/DoctorsList': (context) => DoctorsList(),
            '/DepartmentListPage': (context) => DepartmentListPage(),
            '/AddDepartmentPage': (context) => AddDepartmentPage(),
            '/AddDoctorsPage': (context) => AddDoctorsPage(),
            '/FeedbackListPage': (context) => FeedbackListPage(),
            '/CityListPage': (context) => CityListPage(),
            '/AddCityPage': (context) => AddCityPage(),
            '/ChooseClinicCityListPage': (context) => ChooseClinicCityListPage(),
            '/ChooseDeptCityListPage': (context) => ChooseDeptCityListPage(),
            '/ChooseDoctCityListPage': (context) => ChooseDoctCityListPage(),
            '/ConfirmationPage': (context) => ConfirmationPage(),
            '/BlockTimePage': (context) => BlockTimePage(),
            '/OrderListPage': (context) => OrderListScreen(),
          }),
    );
  }
}
