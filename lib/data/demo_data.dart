import 'package:flutter/material.dart';

enum HrAlertType { fraud, late, absence, payroll, compliance }

enum ApprovalPriority { normal, high, critical }

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

class PayrollSummary {
  const PayrollSummary({
    required this.period,
    required this.gross,
    required this.overtime,
    required this.allowances,
    required this.deductions,
    required this.net,
    required this.employeeCount,
    required this.pendingApprovals,
  });

  final String period;
  final double gross;
  final double overtime;
  final double allowances;
  final double deductions;
  final double net;
  final int employeeCount;
  final int pendingApprovals;
}

class PayrollAnomaly {
  const PayrollAnomaly({
    required this.title,
    required this.employee,
    required this.message,
    required this.severity,
    required this.color,
  });

  final String title;
  final String employee;
  final String message;
  final String severity;
  final Color color;
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

class OrgUnit {
  const OrgUnit({
    required this.name,
    required this.level,
    required this.manager,
    required this.headcount,
    required this.presentRate,
  });

  final String name;
  final String level;
  final String manager;
  final int headcount;
  final double presentRate;
}

class ApprovalTask {
  const ApprovalTask({
    required this.title,
    required this.owner,
    required this.step,
    required this.priority,
    required this.dueLabel,
  });

  final String title;
  final String owner;
  final String step;
  final ApprovalPriority priority;
  final String dueLabel;

  Color get color {
    return switch (priority) {
      ApprovalPriority.normal => Colors.blue,
      ApprovalPriority.high => Colors.orange,
      ApprovalPriority.critical => Colors.red,
    };
  }
}

class FraudSignal {
  const FraudSignal({
    required this.label,
    required this.value,
    required this.status,
    required this.color,
  });

  final String label;
  final String value;
  final String status;
  final Color color;
}

class AttendanceEvent {
  const AttendanceEvent({
    required this.employee,
    required this.method,
    required this.site,
    required this.time,
    required this.decision,
    required this.note,
    required this.color,
  });

  final String employee;
  final String method;
  final String site;
  final String time;
  final String decision;
  final String note;
  final Color color;
}

class WorkforcePlan {
  const WorkforcePlan({
    required this.site,
    required this.shift,
    required this.required,
    required this.scheduled,
    required this.costImpact,
    required this.risk,
    required this.color,
  });

  final String site;
  final String shift;
  final int required;
  final int scheduled;
  final double costImpact;
  final String risk;
  final Color color;

  int get gap => scheduled - required;
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

  static const payrollSummary = PayrollSummary(
    period: 'Juillet 2026',
    gross: 23500000,
    overtime: 2040000,
    allowances: 3400000,
    deductions: 510000,
    net: 28430000,
    employeeCount: 244,
    pendingApprovals: 3,
  );

  static const payrollAnomalies = [
    PayrollAnomaly(
      title: 'Overtime nuit eleve',
      employee: 'Mamadou Bah',
      message: '9 h supplementaires sur site sensible.',
      severity: 'A valider',
      color: Colors.orange,
    ),
    PayrollAnomaly(
      title: 'Retenue absence',
      employee: 'Ibrahima Conte',
      message: 'Absence injustifiee a confirmer par RH.',
      severity: 'Critique',
      color: Colors.red,
    ),
    PayrollAnomaly(
      title: 'Indemnite mission',
      employee: 'Fatou Camara',
      message: 'Mission Kindia liee a un ordre approuve.',
      severity: 'OK',
      color: Colors.green,
    ),
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

  static const organization = [
    OrgUnit(
      name: 'Direction Generale',
      level: 'Direction',
      manager: 'M. Camara',
      headcount: 24,
      presentRate: 96,
    ),
    OrgUnit(
      name: 'Ressources humaines',
      level: 'Departement',
      manager: 'Aminata Diallo',
      headcount: 18,
      presentRate: 94,
    ),
    OrgUnit(
      name: 'IT & securite',
      level: 'Service',
      manager: 'Mamadou Bah',
      headcount: 42,
      presentRate: 86,
    ),
    OrgUnit(
      name: 'Ventes entreprises',
      level: 'Unite',
      manager: 'Fatou Camara',
      headcount: 63,
      presentRate: 91,
    ),
  ];

  static const approvals = [
    ApprovalTask(
      title: 'Overtime nuit - Datacenter Kipe',
      owner: 'Finance',
      step: 'Validation finale',
      priority: ApprovalPriority.high,
      dueLabel: 'Aujourd hui',
    ),
    ApprovalTask(
      title: 'Mission Kindia - audit presence',
      owner: 'Manager commercial',
      step: 'Validation manager',
      priority: ApprovalPriority.normal,
      dueLabel: 'Demain',
    ),
    ApprovalTask(
      title: 'Absence injustifiee - Surete',
      owner: 'RH',
      step: 'Decision disciplinaire',
      priority: ApprovalPriority.critical,
      dueLabel: 'Urgent',
    ),
  ];

  static const fraudSignals = [
    FraudSignal(
      label: 'Fake GPS',
      value: '1',
      status: 'Bloque',
      color: Colors.red,
    ),
    FraudSignal(
      label: 'VPN',
      value: '0',
      status: 'OK',
      color: Colors.green,
    ),
    FraudSignal(
      label: 'Root/Jailbreak',
      value: '0',
      status: 'OK',
      color: Colors.green,
    ),
    FraudSignal(
      label: 'Liveness',
      value: '98%',
      status: 'Valide',
      color: Colors.blue,
    ),
  ];

  static const attendanceEvents = [
    AttendanceEvent(
      employee: 'Aminata Diallo',
      method: 'Face + GPS',
      site: 'Siege Kaloum',
      time: '08:24',
      decision: 'Valide',
      note: 'Liveness confirme, geofence 38 m.',
      color: Colors.green,
    ),
    AttendanceEvent(
      employee: 'Mamadou Bah',
      method: 'GPS',
      site: 'Datacenter Kipe',
      time: '08:58',
      decision: 'Bloque',
      note: 'Mock location detectee avant validation.',
      color: Colors.red,
    ),
    AttendanceEvent(
      employee: 'Fatou Camara',
      method: 'Offline QR',
      site: 'Mission Kindia',
      time: '09:12',
      decision: 'En file',
      note: 'Reseau 2G, synchronisation automatique en attente.',
      color: Colors.orange,
    ),
  ];

  static const workforcePlan = [
    WorkforcePlan(
      site: 'Siege Kaloum',
      shift: 'Jour 08:30-18:00',
      required: 210,
      scheduled: 218,
      costImpact: 1800000,
      risk: 'Couverture OK',
      color: Colors.green,
    ),
    WorkforcePlan(
      site: 'Datacenter Kipe',
      shift: 'Nuit 18:00-06:00',
      required: 24,
      scheduled: 19,
      costImpact: 3200000,
      risk: 'Sous-effectif',
      color: Colors.red,
    ),
    WorkforcePlan(
      site: 'Agence Ratoma',
      shift: 'Pic service 10:00-15:00',
      required: 58,
      scheduled: 51,
      costImpact: 950000,
      risk: 'Renfort requis',
      color: Colors.orange,
    ),
  ];

  static const attendanceTrend = [82.0, 88.0, 91.0, 86.0, 94.0, 89.0, 96.0];
}
