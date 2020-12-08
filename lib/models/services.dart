import 'package:bikerr/screens/documentation/documentation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ServiceType {
  lubrication,
  engineOil,
  brakePad,
  brakeOil,
  clutchPlate,
  tireChange,
  others
}

class Service {
  final ServiceType type;
  final String name, imageURL, msg;
  final int kms;
  static Map<ServiceType, int> serviceCount = {};
  Service({this.type, this.kms, this.name, this.imageURL, this.msg});
  static List<Service> serviceList = [
    Service(
        kms: 400,
        type: ServiceType.lubrication,
        name: 'Lubrication',
        msg: 'Lubricate your chain',
        imageURL:
            'https://media.noria.com/sites/Uploads/2019/10/23/f0806cf6-f7e0-46e1-ac1b-5c66a6c0afec_lubrication-of-gears-image_extra_large.jpeg'),
    Service(
        kms: 3000,
        type: ServiceType.engineOil,
        name: 'Engine Oil',
        msg: 'Change Engine Oil',
        imageURL:
            'https://media.noria.com/sites/Uploads/2018/12/22/b29358d0-060a-4433-84c6-7cfc9afc0694_engine-oils-filters-1200_extra_large.jpeg'),
    Service(
        kms: 5000,
        type: ServiceType.brakePad,
        msg: 'Change Brake-pad',
        name: 'Brake Pad',
        imageURL:
            'https://previews.123rf.com/images/marekusz/marekusz1108/marekusz110800009/10225185-brake-disk-and-one-brake-pad.jpg'),
    Service(
        kms: 6000,
        type: ServiceType.brakeOil,
        name: 'Brake Oil',
        msg: 'Change Brake-oil',
        imageURL:
            'https://www.liveabout.com/thmb/Fr51PMh8EoMMnuQVR4liYBZ8HGQ=/768x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-654925470-5aa0688e642dca0036dcd3f4.jpg'),
    Service(
        kms: 10000,
        type: ServiceType.clutchPlate,
        name: 'Clutch Plate',
        msg: 'Change Clutch-plate',
        imageURL:
            'https://5.imimg.com/data5/TT/YR/MY-52758351/car-clutch-plate-500x500.jpg'),
    Service(
        kms: 40000,
        type: ServiceType.tireChange,
        name: 'Tire Change',
        msg: 'Change Tire',
        imageURL:
            'https://di-uploads-pod3.dealerinspire.com/saffordcjdrofwinchester/uploads/2018/08/Tire-Change-e1535639046872.jpg')
  ];

  static Map<ServiceType, Service> serviceMap = Map.fromIterable(serviceList,
      key: (service) => service.type, value: (service) => service);

  static ServiceType getServiceType(int kms) {
    ServiceType service;
    switch (kms) {
      case 400:
        service = ServiceType.lubrication;
        break;
      case 3000:
        service = ServiceType.engineOil;
        break;
      case 5000:
        service = ServiceType.brakePad;
        break;
      case 6000:
        service = ServiceType.brakeOil;
        break;
      case 10000:
        service = ServiceType.clutchPlate;
        break;
      case 40000:
        service = ServiceType.tireChange;
        break;
      default:
        service = ServiceType.others;
        break;
    }
    return service;
  }

  static void initialze(SharedPreferences prefs) {
    List<int> kmSteps = [400, 3000, 5000, 6000, 10000, 40000];
    kmSteps.forEach((km) => serviceCount.update(
        getServiceType(km), (_) => prefs.getInt('$km') ?? 0,
        ifAbsent: () => prefs.getInt('$km') ?? 0));
  }

  static String getMsg(int kms) {
    List<String> msgs = [];
    int km400, km3000, km5000, km6000, km10000, km40000;
    km400 = kms ~/ 400;
    km3000 = kms ~/ 3000;
    km5000 = kms ~/ 5000;
    km6000 = kms ~/ 6000;
    km10000 = kms ~/ 10000;
    km40000 = kms ~/ 40000;
    if (km400 > serviceCount[ServiceType.lubrication])
      msgs.add(serviceMap[ServiceType.lubrication].msg);
    if (km3000 > serviceCount[ServiceType.engineOil])
      msgs.add(serviceMap[ServiceType.engineOil].msg);
    if (km5000 > serviceCount[ServiceType.brakePad])
      msgs.add(serviceMap[ServiceType.brakePad].msg);
    if (km6000 > serviceCount[ServiceType.brakeOil])
      msgs.add(serviceMap[ServiceType.brakeOil].msg);
    if (km10000 > serviceCount[ServiceType.clutchPlate])
      msgs.add(serviceMap[ServiceType.clutchPlate].msg);
    if (km40000 > serviceCount[ServiceType.tireChange])
      msgs.add(serviceMap[ServiceType.tireChange].msg);
    if (msgs.isEmpty) return null;
    String finalMsg = '';
    if (msgs.length == 1)
      finalMsg = msgs.first.toLowerCase();
    else
      msgs.forEach((msg) => finalMsg +=
          '\n ' + msg.substring(0, 1).toUpperCase() + msg.substring(1));
    return finalMsg;
  }
}
