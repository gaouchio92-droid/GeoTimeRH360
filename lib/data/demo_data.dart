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

class TenantAccount {
  const TenantAccount({
    required this.name,
    required this.slug,
    required this.sector,
    required this.country,
    required this.currency,
    required this.plan,
    required this.status,
    required this.dataRegion,
    required this.employeeCount,
    required this.userCount,
    required this.siteCount,
    required this.monthlyRevenue,
    required this.storageGb,
    required this.modules,
    required this.ssoEnabled,
    required this.auditScore,
  });

  final String name;
  final String slug;
  final String sector;
  final String country;
  final String currency;
  final String plan;
  final String status;
  final String dataRegion;
  final int employeeCount;
  final int userCount;
  final int siteCount;
  final double monthlyRevenue;
  final double storageGb;
  final List<String> modules;
  final bool ssoEnabled;
  final int auditScore;
}

class SaaSControl {
  const SaaSControl({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String description;
  final IconData icon;
  final Color color;
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
  static final employees = _buildEmployees();

  static const tenantAccounts = [
    TenantAccount(
      name: 'GeoTime Demo Guinee',
      slug: 'geotime-demo-gn',
      sector: 'Entreprise privee',
      country: 'Guinee',
      currency: 'GNF',
      plan: 'Enterprise',
      status: 'Actif',
      dataRegion: 'Afrique Ouest',
      employeeCount: 100,
      userCount: 18,
      siteCount: 6,
      monthlyRevenue: 14500000,
      storageGb: 18.4,
      modules: ['RH Core', 'Pointage IA', 'Paie', 'Missions', 'Performance'],
      ssoEnabled: true,
      auditScore: 96,
    ),
    TenantAccount(
      name: 'Ministere Sante GN',
      slug: 'ministere-sante-gn',
      sector: 'Administration publique',
      country: 'Guinee',
      currency: 'GNF',
      plan: 'Government',
      status: 'Onboarding',
      dataRegion: 'Afrique Ouest',
      employeeCount: 1240,
      userCount: 64,
      siteCount: 38,
      monthlyRevenue: 42000000,
      storageGb: 82.7,
      modules: ['RH Core', 'Pointage IA', 'Controle acces', 'Formations'],
      ssoEnabled: true,
      auditScore: 89,
    ),
    TenantAccount(
      name: 'Banque Atlantique Conakry',
      slug: 'banque-atlantique-ckry',
      sector: 'Banque',
      country: 'Guinee',
      currency: 'GNF',
      plan: 'Enterprise Plus',
      status: 'Actif',
      dataRegion: 'Afrique Ouest',
      employeeCount: 620,
      userCount: 42,
      siteCount: 22,
      monthlyRevenue: 36500000,
      storageGb: 44.2,
      modules: ['RH Core', 'Pointage IA', 'Paie', 'SSO', 'SIEM'],
      ssoEnabled: true,
      auditScore: 98,
    ),
    TenantAccount(
      name: 'Industries Boke Services',
      slug: 'industries-boke-services',
      sector: 'Industrie',
      country: 'Guinee',
      currency: 'GNF',
      plan: 'Business',
      status: 'Essai',
      dataRegion: 'Afrique Ouest',
      employeeCount: 280,
      userCount: 12,
      siteCount: 9,
      monthlyRevenue: 9800000,
      storageGb: 12.1,
      modules: ['RH Core', 'Pointage GPS', 'Missions'],
      ssoEnabled: false,
      auditScore: 78,
    ),
  ];

  static const saasControls = [
    SaaSControl(
      title: 'Isolation donnees',
      value: 'RLS pret',
      description: 'Chaque requete est portee par tenant_id.',
      icon: Icons.dataset_linked_rounded,
      color: Colors.indigo,
    ),
    SaaSControl(
      title: 'Authentification',
      value: 'SSO/MFA',
      description: 'RBAC par tenant, roles RH, manager, finance.',
      icon: Icons.admin_panel_settings_rounded,
      color: Colors.green,
    ),
    SaaSControl(
      title: 'Observabilite',
      value: 'Audit logs',
      description: 'Traces paie, pointage, exports et acces sensibles.',
      icon: Icons.manage_search_rounded,
      color: Colors.orange,
    ),
    SaaSControl(
      title: 'Regions data',
      value: 'Multi-pays',
      description: 'GNF, XOF, USD, FR/EN/AR et reseaux faibles.',
      icon: Icons.public_rounded,
      color: Colors.teal,
    ),
  ];

  static int get activeTenantCount {
    return tenantAccounts.where((tenant) => tenant.status == 'Actif').length;
  }

  static int get totalTenantEmployees {
    return tenantAccounts.fold(
        0, (total, tenant) => total + tenant.employeeCount);
  }

  static double get monthlyRecurringRevenue {
    return tenantAccounts.fold(
        0, (total, tenant) => total + tenant.monthlyRevenue);
  }

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
    PayrollLine(
        employee: 'Aminata Diallo',
        base: 9200000,
        overtime: 680000,
        allowances: 1200000,
        deductions: 180000),
    PayrollLine(
        employee: 'Mamadou Bah',
        base: 7800000,
        overtime: 1120000,
        allowances: 750000,
        deductions: 240000),
    PayrollLine(
        employee: 'Fatou Camara',
        base: 6500000,
        overtime: 240000,
        allowances: 1450000,
        deductions: 90000),
  ];

  static const payrollSummary = PayrollSummary(
    period: 'Juillet 2026',
    gross: 23500000,
    overtime: 2040000,
    allowances: 3400000,
    deductions: 510000,
    net: 28430000,
    employeeCount: 100,
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

  static List<Employee> _buildEmployees() {
    const firstNames = [
      'Aminata',
      'Mamadou',
      'Fatou',
      'Ibrahima',
      'Mariama',
      'Alpha',
      'Ousmane',
      'Aissatou',
      'Abdoulaye',
      'Nene',
      'Moussa',
      'Hadja',
      'Sekou',
      'Kadiatou',
      'Boubacar',
      'Maimouna',
      'Thierno',
      'Ramatoulaye',
      'Amadou',
      'Fanta',
    ];
    const lastNames = [
      'Diallo',
      'Bah',
      'Camara',
      'Conte',
      'Barry',
      'Sow',
      'Toure',
      'Keita',
      'Cisse',
      'Kourouma',
      'Sylla',
      'Fofana',
      'Kaba',
      'Bangoura',
      'Traore',
      'Doumbouya',
      'Cherif',
      'Soumah',
      'Camara',
      'Diallo',
    ];
    const roles = [
      'Responsable paie',
      'Technicien datacenter',
      'Charge commercial',
      'Agent controle acces',
      'Assistant RH',
      'Manager agence',
      'Comptable paie',
      'Analyste performance',
      'Agent terrain',
      'Superviseur shift',
    ];
    const departments = [
      'Ressources humaines',
      'IT & securite',
      'Ventes entreprises',
      'Surete',
      'Finance',
      'Operations',
      'Formation',
      'Direction Generale',
    ];
    const sites = [
      'Siege Kaloum',
      'Datacenter Kipe',
      'Agence Ratoma',
      'Hopital Donka',
      'Antenne Kindia',
      'Bureau Boke',
    ];
    const statuses = [
      'Presente',
      'Presente',
      'Presente',
      'Retard',
      'Mission',
      'Absent'
    ];

    return List<Employee>.generate(100, (index) {
      final firstName = firstNames[index % firstNames.length];
      final lastName = lastNames[(index * 7) % lastNames.length];
      final role = roles[(index * 3) % roles.length];
      final department = departments[(index * 5) % departments.length];
      final site = sites[(index * 2) % sites.length];
      final status = statuses[(index * 5) % statuses.length];
      final lateMinutes = status == 'Retard' ? 5 + (index % 45) : 0;
      final overtimeHours = (index % 6) * 1.5;
      final salary = 4500000 + ((index % 12) * 450000);
      final matricule = (index + 1).toString().padLeft(4, '0');
      final phoneSuffix = (620000000 + (index * 13791)).toString();
      final emailFirst = firstName.toLowerCase();
      final emailLast = lastName.toLowerCase();

      return Employee(
        name: '$firstName $lastName',
        employeeId: 'GT-EMP-$matricule',
        role: role,
        department: department,
        site: site,
        phone: '+224 $phoneSuffix',
        email: '$emailFirst.$emailLast$matricule@geotime.gn',
        status: status,
        lateMinutes: lateMinutes,
        overtimeHours: overtimeHours,
        baseSalary: salary.toDouble(),
      );
    });
  }
}
