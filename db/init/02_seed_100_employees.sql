DO $$
DECLARE
  tenant_uuid UUID;
BEGIN
  INSERT INTO tenants (name, slug, sector, plan, status, country, currency, data_region, employee_limit, sso_enabled)
  VALUES ('GeoTime Demo Guinee', 'geotime-demo-gn', 'Entreprise privee', 'Enterprise', 'Actif', 'Guinee', 'GNF', 'Afrique Ouest', 1000, true)
  RETURNING id INTO tenant_uuid;

  INSERT INTO tenants (name, slug, sector, plan, status, country, currency, data_region, employee_limit, sso_enabled)
  VALUES
    ('Ministere Sante GN', 'ministere-sante-gn', 'Administration publique', 'Government', 'Onboarding', 'Guinee', 'GNF', 'Afrique Ouest', 5000, true),
    ('Banque Atlantique Conakry', 'banque-atlantique-ckry', 'Banque', 'Enterprise Plus', 'Actif', 'Guinee', 'GNF', 'Afrique Ouest', 1500, true),
    ('Industries Boke Services', 'industries-boke-services', 'Industrie', 'Business', 'Essai', 'Guinee', 'GNF', 'Afrique Ouest', 500, false);

  INSERT INTO departments (tenant_id, name, parent_name, manager_name)
  VALUES
    (tenant_uuid, 'Direction Generale', NULL, 'Mory Camara'),
    (tenant_uuid, 'Ressources humaines', 'Direction Generale', 'Aminata Diallo'),
    (tenant_uuid, 'IT & securite', 'Direction Generale', 'Mamadou Bah'),
    (tenant_uuid, 'Ventes entreprises', 'Direction Generale', 'Fatou Camara'),
    (tenant_uuid, 'Surete', 'Direction Generale', 'Ibrahima Conte'),
    (tenant_uuid, 'Finance', 'Direction Generale', 'Hadja Barry'),
    (tenant_uuid, 'Operations', 'Direction Generale', 'Ousmane Keita'),
    (tenant_uuid, 'Formation', 'Ressources humaines', 'Kadiatou Sow');

  INSERT INTO sites (tenant_id, name, city, latitude, longitude, radius_m)
  VALUES
    (tenant_uuid, 'Siege Kaloum', 'Conakry', 9.509200, -13.712200, 100),
    (tenant_uuid, 'Datacenter Kipe', 'Conakry', 9.611100, -13.641500, 30),
    (tenant_uuid, 'Agence Ratoma', 'Ratoma', 9.686800, -13.620200, 50),
    (tenant_uuid, 'Hopital Donka', 'Dixinn', 9.558800, -13.673100, 80),
    (tenant_uuid, 'Antenne Kindia', 'Kindia', 10.056900, -12.865800, 70),
    (tenant_uuid, 'Bureau Boke', 'Boke', 10.940900, -14.300300, 60);

  INSERT INTO employees (
    tenant_id,
    matricule,
    first_name,
    last_name,
    gender,
    role,
    department_id,
    site_id,
    phone,
    email,
    status,
    base_salary_gnf,
    hired_at,
    emergency_contact
  )
  SELECT
    tenant_uuid,
    'GT-EMP-' || lpad(source.n::text, 4, '0'),
    source.first_name,
    source.last_name,
    CASE WHEN source.first_name IN ('Aminata','Fatou','Mariama','Aissatou','Nene','Hadja','Kadiatou','Maimouna','Ramatoulaye','Fanta') THEN 'F' ELSE 'M' END,
    source.role,
    departments.id,
    sites.id,
    '+224 ' || (620000000 + source.n * 13791)::text,
    lower(source.first_name) || '.' || lower(source.last_name) || lpad(source.n::text, 4, '0') || '@geotime.gn',
    source.status,
    4500000 + ((source.n - 1) % 12) * 450000,
    (DATE '2021-01-01' + ((source.n - 1) * INTERVAL '17 days'))::date,
    '+224 ' || (660000000 + source.n * 9973)::text
  FROM (
    SELECT
      gs AS n,
      (ARRAY['Aminata','Mamadou','Fatou','Ibrahima','Mariama','Alpha','Ousmane','Aissatou','Abdoulaye','Nene','Moussa','Hadja','Sekou','Kadiatou','Boubacar','Maimouna','Thierno','Ramatoulaye','Amadou','Fanta'])[1 + ((gs - 1) % 20)] AS first_name,
      (ARRAY['Diallo','Bah','Camara','Conte','Barry','Sow','Toure','Keita','Cisse','Kourouma','Sylla','Fofana','Kaba','Bangoura','Traore','Doumbouya','Cherif','Soumah','Camara','Diallo'])[1 + (((gs - 1) * 7) % 20)] AS last_name,
      (ARRAY['Responsable paie','Technicien datacenter','Charge commercial','Agent controle acces','Assistant RH','Manager agence','Comptable paie','Analyste performance','Agent terrain','Superviseur shift'])[1 + (((gs - 1) * 3) % 10)] AS role,
      (ARRAY['Ressources humaines','IT & securite','Ventes entreprises','Surete','Finance','Operations','Formation','Direction Generale'])[1 + (((gs - 1) * 5) % 8)] AS department_name,
      (ARRAY['Siege Kaloum','Datacenter Kipe','Agence Ratoma','Hopital Donka','Antenne Kindia','Bureau Boke'])[1 + (((gs - 1) * 2) % 6)] AS site_name,
      (ARRAY['Presente','Presente','Presente','Retard','Mission','Absent'])[1 + (((gs - 1) * 5) % 6)] AS status
    FROM generate_series(1, 100) AS gs
  ) AS source
  JOIN departments ON departments.tenant_id = tenant_uuid AND departments.name = source.department_name
  JOIN sites ON sites.tenant_id = tenant_uuid AND sites.name = source.site_name;

  INSERT INTO payroll_lines (tenant_id, employee_id, period, base_gnf, overtime_gnf, allowances_gnf, deductions_gnf, validation_step)
  SELECT
    employees.tenant_id,
    employees.id,
    '2026-07',
    employees.base_salary_gnf,
    CASE WHEN employees.status IN ('Retard', 'Mission') THEN 350000 ELSE 120000 END,
    CASE WHEN employees.status = 'Mission' THEN 950000 ELSE 250000 END,
    CASE WHEN employees.status = 'Absent' THEN 180000 ELSE 40000 END,
    CASE WHEN employees.status = 'Absent' THEN 'RH' ELSE 'Finance' END
  FROM employees
  WHERE employees.tenant_id = tenant_uuid;

  INSERT INTO attendance_events (
    tenant_id,
    employee_id,
    site_id,
    event_time,
    method,
    decision,
    fake_gps_detected,
    vpn_detected,
    liveness_score,
    offline_synced,
    note
  )
  SELECT
    employees.tenant_id,
    employees.id,
    employees.site_id,
    now() - ((row_number() OVER (ORDER BY employees.matricule)) * INTERVAL '9 minutes'),
    CASE WHEN employees.status = 'Mission' THEN 'Offline QR' WHEN employees.status = 'Retard' THEN 'GPS' ELSE 'Face + GPS' END,
    CASE WHEN employees.status = 'Retard' THEN 'A verifier' WHEN employees.status = 'Absent' THEN 'Absent' ELSE 'Valide' END,
    employees.status = 'Retard',
    false,
    CASE WHEN employees.status = 'Absent' THEN NULL ELSE 92 + ((row_number() OVER (ORDER BY employees.matricule)) % 8) END,
    employees.status <> 'Mission',
    CASE
      WHEN employees.status = 'Mission' THEN 'Pointage offline synchronisable via SMS/USSD.'
      WHEN employees.status = 'Retard' THEN 'Controle fake GPS requis avant validation RH.'
      WHEN employees.status = 'Absent' THEN 'Aucun pointage recu pour le shift courant.'
      ELSE 'Pointage conforme au geofence.'
    END
  FROM employees
  WHERE employees.tenant_id = tenant_uuid;
END $$;
