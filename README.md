# GeoTime Enterprise HR Suite

[![Flutter CI](https://github.com/gaouchio92-droid/GeoTimeRH360/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/gaouchio92-droid/GeoTimeRH360/actions/workflows/flutter-ci.yml)

Prototype Flutter multiplateforme pour une plateforme SaaS RH cloud native: gestion des employes, pointage intelligent, geofencing, paie, missions, performance et IA RH.

## Modules inclus

- Dashboard temps reel: presents, retards, absences, paie nette et alertes.
- Dossiers employes: matricule, poste, departement, site, telephone, email et salaire.
- Pointage intelligent: GPS, QR dynamique, NFC/RFID, selfie/liveness et controles anti-fraude.
- Sites et geofencing: latitude, longitude, rayon, presence et capacite.
- Paie integree: salaire de base, heures supplementaires, indemnites, retenues et net a payer.
- Missions: destination, indemnites, statut et validation hierarchique.
- Performance: KPI, overtime, competences, formations et ATS.
- IA RH: prediction d absenteisme, fraude pointage, liveness facial et risque de depart.
- Reglages SaaS: multi-tenant, securite entreprise, langues, theme et mode offline Afrique.

## Architecture cible

- Frontend: Flutter mobile/web.
- Backend: NestJS avec REST/GraphQL.
- Base: PostgreSQL multi-tenant, SQLite offline, Redis cache.
- Stockage: MinIO pour documents RH, selfies et pieces jointes.
- Securite: MFA, RBAC, SSO, OAuth2/OIDC, audit logs, TLS 1.3.
- Integrations: ERP, comptabilite, biometrie, Active Directory, Entra ID, Teams, Slack.
- IA: OpenAI, Llama ou DeepSeek selon contraintes cloud/local.

## Lancement

```powershell
flutter pub get
flutter run
```

## Verification

```powershell
flutter analyze
flutter test
```
