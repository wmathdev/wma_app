class Status {
  static List<dynamic> status = [
    {'status': 'WAIT', 'label': 'รอเจ้าหน้าที่ดำเนินการ'},
    {'status': 'NEW', 'label': 'เจ้าหน้าที่ส่งรายงาน'},
    {'status': 'PENDING', 'label': 'ตรวจสอบรายงาน'},
    {'status': 'COMPLETED', 'label': 'รายงานเสร็จสิ้น'},
  ];

  static List<String> statusLabel = [
    'รอเจ้าหน้าที่ดำเนินการ',
    'เจ้าหน้าที่ส่งรายงาน',
    'ตรวจสอบรายงาน',
    'รายงานเสร็จสิ้น',
  ];
}
