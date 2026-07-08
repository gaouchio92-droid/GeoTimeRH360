import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  late final List<Employee> _employees = List<Employee>.from(DemoData.employees);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: 'Dossiers employes',
          action: FilledButton.icon(
            onPressed: () => _openEmployeeForm(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Ajouter'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.storage_rounded),
            title: Text('${_employees.length} employes de simulation'),
            subtitle: const Text('Base generee avec noms guineens, matricules, sites, statuts et salaires.'),
            trailing: const StatusChip(label: 'Seed RH', color: Colors.teal),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ActionChip(
              avatar: const Icon(Icons.badge_rounded),
              label: const Text('Matricules'),
              onPressed: () => _showMessage('Generation matricule prete'),
            ),
            ActionChip(
              avatar: const Icon(Icons.description_rounded),
              label: const Text('Documents RH'),
              onPressed: () => _showMessage('Coffre documents RH pret'),
            ),
            ActionChip(
              avatar: const Icon(Icons.draw_rounded),
              label: const Text('Signature'),
              onPressed: () => _showMessage('Signature electronique prete'),
            ),
            ActionChip(
              avatar: const Icon(Icons.history_rounded),
              label: const Text('Carriere'),
              onPressed: () => _showMessage('Historique carriere ouvert'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._employees.map((employee) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(employee.name.substring(0, 1))),
                title: Text(employee.name),
                subtitle: Text(
                  '${employee.employeeId} - ${employee.role} - ${employee.department}',
                ),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(employee.status),
                        Text(employee.site),
                      ],
                    ),
                    IconButton(
                      tooltip: 'Modifier',
                      onPressed: () => _openEmployeeForm(employee: employee),
                      icon: const Icon(Icons.edit_rounded),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _openEmployeeForm({Employee? employee}) async {
    final savedEmployee = await showModalBottomSheet<Employee>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _EmployeeForm(employee: employee),
    );

    if (savedEmployee == null) return;

    setState(() {
      if (employee == null) {
        _employees.insert(0, savedEmployee);
      } else {
        final index = _employees.indexOf(employee);
        if (index != -1) _employees[index] = savedEmployee;
      }
    });

    _showMessage(employee == null ? 'Employe ajoute' : 'Employe modifie');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _EmployeeForm extends StatefulWidget {
  const _EmployeeForm({this.employee});

  final Employee? employee;

  @override
  State<_EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<_EmployeeForm> {
  late final TextEditingController _name;
  late final TextEditingController _employeeId;
  late final TextEditingController _role;
  late final TextEditingController _department;
  late final TextEditingController _site;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _salary;

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    _name = TextEditingController(text: employee?.name ?? '');
    _employeeId = TextEditingController(text: employee?.employeeId ?? '');
    _role = TextEditingController(text: employee?.role ?? '');
    _department = TextEditingController(text: employee?.department ?? '');
    _site = TextEditingController(text: employee?.site ?? '');
    _phone = TextEditingController(text: employee?.phone ?? '');
    _email = TextEditingController(text: employee?.email ?? '');
    _salary = TextEditingController(text: employee?.baseSalary.toStringAsFixed(0) ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _employeeId.dispose();
    _role.dispose();
    _department.dispose();
    _site.dispose();
    _phone.dispose();
    _email.dispose();
    _salary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.employee != null;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              editing ? 'Modifier employe' : 'Ajouter employe',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            _field(_name, 'Nom complet', Icons.person_rounded),
            _field(_employeeId, 'Matricule', Icons.badge_rounded),
            _field(_role, 'Poste', Icons.work_rounded),
            _field(_department, 'Departement', Icons.account_tree_rounded),
            _field(_site, 'Site', Icons.business_rounded),
            _field(_phone, 'Telephone', Icons.phone_rounded),
            _field(_email, 'Email', Icons.email_rounded),
            _field(_salary, 'Salaire de base', Icons.payments_rounded, number: true),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_rounded),
              label: Text(editing ? 'Enregistrer' : 'Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _save() {
    if (_name.text.trim().isEmpty || _employeeId.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nom et matricule obligatoires')),
      );
      return;
    }

    final original = widget.employee;
    Navigator.of(context).pop(
      Employee(
        name: _name.text.trim(),
        employeeId: _employeeId.text.trim(),
        role: _role.text.trim().isEmpty ? 'Non defini' : _role.text.trim(),
        department: _department.text.trim().isEmpty ? 'General' : _department.text.trim(),
        site: _site.text.trim().isEmpty ? 'Siege' : _site.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        status: original?.status ?? 'Presente',
        lateMinutes: original?.lateMinutes ?? 0,
        overtimeHours: original?.overtimeHours ?? 0,
        baseSalary: _number(_salary.text),
      ),
    );
  }

  double _number(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0;
  }
}
