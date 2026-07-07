# Architecture GeoTime Enterprise HR Suite

## Application Flutter

L'application est decoupee par domaine :

- `dashboard` : KPI temps reel, alertes RH, presence, absences, retards et paie.
- `employees` : dossiers employes, matricules, contacts, contrat, documents et carriere.
- `attendance` : pointage GPS, QR dynamique, NFC/RFID, selfie, liveness et anti-fraude.
- `sites` : sites, geofencing, carte temps reel, rayon et capacite.
- `payroll` : paie, avances, primes, deductions, overtime et validation finance.
- `missions` : missions, frais, indemnites, depart, arrivee et workflow manager.
- `performance` : performance, KPI, competences, formations et recrutement ATS.
- `ai` : prediction absenteisme, fraude, liveness, risque de depart et recommandations.
- `settings` : multi-tenant, langues, theme, securite, offline et integrations.

## Backend NestJS cible

Modules recommandes :

- `auth` : MFA, RBAC, SSO, OAuth2, OpenID Connect, biometrie mobile.
- `tenancy` : isolation entreprises, ministeres, ONG, universites, banques et hopitaux.
- `employees` : dossier RH, documents, contrats, signatures, historique carriere.
- `organization` : directions, departements, services, unites et organigramme.
- `attendance` : pointage, geofencing, shifts, retards, absences et overtime.
- `anti_fraud` : fake GPS, VPN, mock location, root, jailbreak, IP et appareil.
- `payroll` : salaire, primes, indemnites, retenues, avances, net et exports.
- `missions` : ordre de mission, GPS, frais, indemnites et validation.
- `access_control` : tourniquets, portes, badges RFID, biometrie et audit.
- `performance` : objectifs, KPI, evaluations, competences, formations et ATS.
- `ai` : predictions RH, scoring, recommandations et explications auditables.
- `sync` : offline mobile, SMS fallback, USSD fallback et resolution de conflits.

## Donnees et infrastructure

- PostgreSQL : source de verite transactionnelle multi-tenant.
- SQLite : cache local mobile et pointage hors ligne.
- Redis : cache KPI, sessions, files courtes et verrous.
- MinIO : documents RH, photos selfie, contrats, justificatifs et exports.
- Firebase ou service equivalent : notifications push.
- REST : mobile, integrations simples et API publique.
- GraphQL : tableaux de bord, rapports composites et portail direction.
- Kubernetes, Docker, NGINX : deploiement cloud native.
- Prometheus, Grafana, Zabbix : monitoring et alerting.

## Synchronisation offline

Chaque action mobile produit un evenement local horodate :

1. Ecriture immediate dans SQLite.
2. Ajout dans une file locale `sync_queue`.
3. Signature locale de l evenement avec appareil, position et contexte reseau.
4. Synchronisation automatique quand Internet revient.
5. Fallback SMS ou USSD pour pointage minimal si le reseau data est indisponible.
6. Resolution de conflit par version, priorite manager et journal d audit.

## IA RH

Les fonctions IA doivent rester explicables et auditables :

- Absenteisme : prediction par site, equipe, shift et historique.
- Fraude : detection de patterns GPS, appareil, IP, liveness et comportement.
- Performance : recommandations d objectifs, formation et coaching manager.
- Paie : detection d anomalies sur overtime, primes et deductions.
- Retention : risque de depart base sur signaux RH autorises et controles.
