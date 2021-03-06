import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:weather/di/dependency_graph.dart';
import 'package:weather/model/meteo_in_city.dart';
import 'package:weather/services/api_weather_service.dart';
import 'package:weather/services/authentication_service.dart';
import 'package:weather/ui/map/map_viewmodel.dart';

@injectable
class WeatherForeastViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getCurrentUID() {
    String uid = '';
    if (_auth.currentUser != null) {
      uid = _auth.currentUser!.uid;
    }
    return uid;
  }

  final ApiWeather _meteo;
  List<MeteoInCity> _meteos = [];

  

  List<MeteoInCity> get meteos => _meteos;
  set meteosSet(List<MeteoInCity> listVilles){
    _meteos = listVilles;
  }
  

  WeatherForeastViewModel(this._meteo);

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final CarouselController _carouselController = CarouselController();
  CarouselController get carouselController => _carouselController;

  Future initialize() async {
    if (locator<AuthenticationService>().weatherUser != null) {
      for (var item in locator<AuthenticationService>().weatherUser!.villes!) {
        MeteoInCity? meteoDansLaVille =
            await _meteo.getMeteoInTime(item.toString());
        if (meteoDansLaVille != null) {
          _meteos.add(meteoDansLaVille);
        }
      }
      if (_meteos.isEmpty) {
        MapViewModel mapViewModel = MapViewModel();
        Position _position = await mapViewModel.determinePosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _position.latitude, _position.longitude);
        MeteoInCity? meteoUser =
            await _meteo.getMeteoInTime(placemarks.first.locality!);
        _meteos.add(meteoUser!);
      }
    }

    locator<WeatherForeastViewModel>()._meteos =  _meteos;

    notifyListeners();
  }

  deleteCityOfList(String villeDelete) {
    var villes = [];
    villes.add(villeDelete);
    //suppression en bdd
    var userInfo = _firestore.collection('users').doc(getCurrentUID());
    userInfo.update({
      'ville': FieldValue.arrayRemove(villes),
    });
    //suppression dans la vue
    MeteoInCity elementNeedDelete = _meteos.firstWhere(
      (element) => element.ville == villeDelete,
    );
    _meteos.remove(elementNeedDelete);

    //suppression sur la liste de l'user
    locator<AuthenticationService>().weatherUser!.villes!.remove(villeDelete);

    notifyListeners();
  }

  void carouselChangeCity(int index, CarouselPageChangedReason reason) {
    _currentIndex = index;
  }

  
  void addMeteoObj(String meteoset){
    locator<AuthenticationService>().weatherUser!.villes!.add(meteoset);
    notifyListeners();
  }
  
  
}
