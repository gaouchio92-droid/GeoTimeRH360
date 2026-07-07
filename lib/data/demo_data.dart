import 'package:flutter/material.dart';

enum HrAlertType { fraud, late, absence, payroll, compliance }

class Employee {
  const Employee({
    required this.name,
    required this.employeeId,
    required this.role,
    required this.department,
    required this.site,
    required this.phone,
    required this.email,
    required this.status,
    required this.lateMinutes,
    required this.overtimeHours,
    required this.baseSalary,
  });

  final String name;
  final String employeeId;
  final String role;
  final String department;
  final String site;
  final String phone;
  final String email;
  final String status;
  final int lateMinutes;
  final double overtimeHours;
  final double baseSalary;
}

class WorkSite {
  const WorkSite({
    required this.name,
    required this.type,
    required this.city,
    required this.radius,
    required this.location,
    required this.present,
    required this.capacity,
  });

  final String name;
  final String type;
  final String city;
  final int radius;
  final String location;
  final int present;
  final int capacity;
}

class Mission {
  const Mission({
    required this.title,
    required this.employee,
    required this.destination,
    required this.status,
    required this.allowance,
  });

  final String title;
  final String employee;
  final String destination;
  final String status;
  final double allowance;
}

class PayrollLine {
  const PayrollLine({
    required this.employee,
    required this.base,
    required this.overtime,
    required this.allowances,
    required this.deductions,
  });

  final String employee;
  final double base;
  final double overtime;
  final double allowances;
  final double deductions;

  double get net => base + overtime + allowances - deductions;
}

class HrAlert {
  const HrAlert({
    required this.title,
    required this.message,
    required this.type,
  });

  final String title;
  final String message;
  final HrAlertType type;

  IconData get icon {
    return switch (type) {
      HrAlertType.fraud => Icons.security_rounded,
      HrAlertType.late => Icons.schedule_rounded,
      HrAlertType.absence => Icons.person_off_rounded,
      HrAlertType.payroll => Icons.payments_rounded,
      HrAlertType.compliance => Icons.verified_user_rounded,
    };
  }
}

class DemoData {
  static const employees = [
    Employee(
      name: 'Aminata Diallo',
      employeeId: 'GT-EMP-0001',
      role: 'Responsable paie',
      department: 'Ressources humaines',
      site: 'Siege Kaloum',
      phone: '+224 620 11 22 33',
      email: 'aminata.diallo@demo.gn',
      status: 'Presente',
      lateMinutes: 0,
      overtimeHours: 4.5,
      baseSalary: 9200000,
    ),
    Employee(
      name: 'Mamadou Bah',
      employeeId: 'GT-EMP-0002',
      role: 'Technicien datacenter',
      department: 'IT & securite',
      site: 'Datacenter Kipe',
      phone: '+224 624 55 44 22',
      email: 'mamadou.bah@demo.gn',
      status: 'Retard',
      lateMinutes: 28,
      overtimeHours: 9,
      baseSalary: 7800000,
    ),
    Employee(
      name: 'Fatou Camara',
      employeeId: 'GT-EMP-0003',
      role: 'Chargee commerciale',
      department: 'Ventes entreprises',
      site: 'Agence Ratoma',
      phone: '+224 622 77 88 99',
      email: 'fatou.camara@demo.gn',
      status: 'Mission',
      lateMinutes: 0,
      overtimeHours: 2,
      baseSalary: 6500000,
    ),
    Employee(
      name: 'Ibrahima Conte',
      employeeId: 'GT-EMP-0004',
      role: 'Agent controle acces',
      department: 'Surete',
      site: 'Hopital Donka',
      phone: '+224 628 70 70 10',
      email: 'ibrahima.conte@demo.gn',
      status: 'Absent',
      lateMinutes: 0,
      overtimeHours: 0,
      baseSalary: 5100000,
    ),
  ];

  static const sites = [
    WorkSite(
      name: 'Siege Kaloum',
      type: 'Administration centrale',
      city: 'Conakry',
      radius: 100,
      location: '9.5092, -13.7122',
      present: 184,
      capacity: 230,
    ),
    WorkSite(
      name: 'Agence Ratoma',
      type: 'Point de service',
      city: 'Ratoma',
      radius: 50,
      location: '9.6868, -13.6202',
      present: 42,
      capacity: 55,
    ),
    WorkSite(
      name: 'Datacenter Kipe',
      type: 'Site sensible',
      city: 'Conakry',
      radius: 30,
      location: '9.6111, -13.6415',
      present: 18,
      capacity: 24,
    ),
  ];

  static const missions = [
    Mission(
      title: 'Audit presence antennes regionales',
      employee: 'Fatou Camara',
      destination: 'Kindia',
      status: 'Validation manager',
      allowance: 950000,
    ),
    Mission(
      title: 'Maintenance controle acces',
      employee: 'Mamadou Bah',
      destination: 'Datacenter Kipe',
      status: 'En cours',
      allowance: 350000,
    ),
    Mission(
      title: 'Formation paie multi-sites',
      employee: 'Aminata Diallo',
      destination: 'Boke',
      status: 'RH approuve',
      allowance: 1250000,
    ),
  ];

  static const payroll = [
    PayrollLine(employee: 'Aminata Diallo', base: 9200000, overtime: 680000, allowances: 1200000, deductions: 180000),
    PayrollLine(employee: 'Mamadou Bah', base: 7800000, overtime: 1120000, allowances: 750000, deductions: 240000),
    PayrollLine(employee: 'Fatou Camara', base: 6500000, overtime: 240000, allowances: 1450000, deductions: 90000),
  ];

  static const alerts = [
    HrAlert(
      title: 'Fake GPS bloque',
      message: 'Pointage refuse pour GT-EMP-0002: mock location detectee.',
      type: HrAlertType.fraud,
    ),
    HrAlert(
      title: 'Retard recurrent',
      message: '5 retards sur 10 jours pour le service IT & securite.',
      type: HrAlertType.late,
    ),
    HrAlert(
      title: 'Paie a valider',
      message: '3 lignes avec overtime nuit attendent Finance.',
      type: HrAlertType.payroll,
    ),
  ];

  static const attendanceTrend = [82.0, 88.0, 91.0, 86.0, 94.0, 89.0, 96.0];
}
