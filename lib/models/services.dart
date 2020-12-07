enum ServiceType {
  lubrication,
  engineOil,
  brakePad,
  brakeOil,
  clutchPlate,
  tireChange
}

class Service {
  final ServiceType type;
  final String name, imageURL;
  final int kms;
  Service({this.type, this.kms, this.name, this.imageURL});
  static List<Service> get serviceList => [
        Service(
            kms: 400,
            type: ServiceType.lubrication,
            name: 'Lubrication',
            imageURL:
                'https://media.noria.com/sites/Uploads/2019/10/23/f0806cf6-f7e0-46e1-ac1b-5c66a6c0afec_lubrication-of-gears-image_extra_large.jpeg'),
        Service(
            kms: 3000,
            type: ServiceType.engineOil,
            name: 'Engine Oil',
            imageURL:
                'https://media.noria.com/sites/Uploads/2018/12/22/b29358d0-060a-4433-84c6-7cfc9afc0694_engine-oils-filters-1200_extra_large.jpeg'),
        Service(
            kms: 5000,
            type: ServiceType.brakePad,
            name: 'Brake Pad',
            imageURL:
                'https://previews.123rf.com/images/marekusz/marekusz1108/marekusz110800009/10225185-brake-disk-and-one-brake-pad.jpg'),
        Service(
            kms: 6000,
            type: ServiceType.brakeOil,
            name: 'Brake Oil',
            imageURL:
                'https://www.liveabout.com/thmb/Fr51PMh8EoMMnuQVR4liYBZ8HGQ=/768x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-654925470-5aa0688e642dca0036dcd3f4.jpg'),
        Service(
            kms: 10000,
            type: ServiceType.clutchPlate,
            name: 'Clutch Plate',
            imageURL:
                'https://5.imimg.com/data5/TT/YR/MY-52758351/car-clutch-plate-500x500.jpg'),
        Service(
            kms: 40000,
            type: ServiceType.tireChange,
            name: 'Tire Change',
            imageURL:
                'https://di-uploads-pod3.dealerinspire.com/saffordcjdrofwinchester/uploads/2018/08/Tire-Change-e1535639046872.jpg')
      ];
  static Map<ServiceType, Service> serviceMap = Map.fromIterable(serviceList,
      key: (service) => service.type, value: (service) => service);
}
