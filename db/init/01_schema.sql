CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS tenants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  sector TEXT NOT NULL DEFAULT 'Entreprise',
  plan TEXT NOT NULL DEFAULT 'Business',
  status TEXT NOT NULL DEFAULT 'Actif',
  country TEXT NOT NULL DEFAULT 'Guinee',
  currency TEXT NOT NULL DEFAULT 'GNF',
  data_region TEXT NOT NULL DEFAULT 'Afrique Ouest',
  employee_limit INTEGER NOT NULL DEFAULT 500,
  sso_enabled BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS departments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  parent_name TEXT,
  manager_name TEXT,
  UNIQUE (tenant_id, name)
);

CREATE TABLE IF NOT EXISTS sites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  city TEXT NOT NULL,
  latitude NUMERIC(10, 6) NOT NULL,
  longitude NUMERIC(10, 6) NOT NULL,
  radius_m INTEGER NOT NULL,
  UNIQUE (tenant_id, name)
);

CREATE TABLE IF NOT EXISTS employees (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  matricule TEXT NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  full_name TEXT GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED,
  gender TEXT NOT NULL CHECK (gender IN ('F', 'M')),
  role TEXT NOT NULL,
  department_id UUID NOT NULL REFERENCES departments(id),
  site_id UUID NOT NULL REFERENCES sites(id),
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('Presente', 'Retard', 'Mission', 'Absent')),
  base_salary_gnf NUMERIC(14, 2) NOT NULL,
  hired_at DATE NOT NULL,
  emergency_contact TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (tenant_id, matricule),
  UNIQUE (tenant_id, email)
);

CREATE TABLE IF NOT EXISTS attendance_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  site_id UUID NOT NULL REFERENCES sites(id),
  event_time TIMESTAMPTZ NOT NULL,
  method TEXT NOT NULL,
  decision TEXT NOT NULL,
  fake_gps_detected BOOLEAN NOT NULL DEFAULT false,
  vpn_detected BOOLEAN NOT NULL DEFAULT false,
  liveness_score NUMERIC(5, 2),
  offline_synced BOOLEAN NOT NULL DEFAULT true,
  note TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS payroll_lines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  period TEXT NOT NULL,
  base_gnf NUMERIC(14, 2) NOT NULL,
  overtime_gnf NUMERIC(14, 2) NOT NULL DEFAULT 0,
  allowances_gnf NUMERIC(14, 2) NOT NULL DEFAULT 0,
  deductions_gnf NUMERIC(14, 2) NOT NULL DEFAULT 0,
  net_gnf NUMERIC(14, 2) GENERATED ALWAYS AS (base_gnf + overtime_gnf + allowances_gnf - deductions_gnf) STORED,
  validation_step TEXT NOT NULL DEFAULT 'RH'
);

CREATE INDEX IF NOT EXISTS idx_employees_tenant_department ON employees(tenant_id, department_id);
CREATE INDEX IF NOT EXISTS idx_employees_tenant_site ON employees(tenant_id, site_id);
CREATE INDEX IF NOT EXISTS idx_attendance_employee_time ON attendance_events(employee_id, event_time DESC);
CREATE INDEX IF NOT EXISTS idx_payroll_period ON payroll_lines(tenant_id, period);
