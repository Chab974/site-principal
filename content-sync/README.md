# content-sync

Source de verite SQLite pour le contenu partage du portail:

- `menu/menu.json`
- `data/apps.json`

Ce dossier contient le schema SQL, le seed initial et les scripts d'export.

## Arborescence

- `migrations/001_init.sql`: schema SQLite
- `seeds/001_seed_from_current.sql`: seed base sur les JSON actuels
- `scripts/export_content.sh`: export manuel + snapshots
- `scripts/export_content.py`: generation JSON depuis SQLite
- `.local/content.db`: base locale (non versionnee)
- `snapshots/`: copies horodatees des JSON avant export

## Initialisation

```bash
cd /Users/chab/Documents/AI-SANDBOX/GITHUB/IA-PPT/site-principal
sqlite3 content-sync/.local/content.db < content-sync/migrations/001_init.sql
sqlite3 content-sync/.local/content.db < content-sync/seeds/001_seed_from_current.sql
```

## Export (manuel)

```bash
cd /Users/chab/Documents/AI-SANDBOX/GITHUB/IA-PPT/site-principal
./content-sync/scripts/export_content.sh
```

Mode snapshot seulement:

```bash
./content-sync/scripts/export_content.sh --snapshot-only
```

## Regle de travail

1. Modifier le contenu dans SQLite.
2. Lancer `export_content.sh`.
3. Committer les JSON exportes (`menu/menu.json`, `data/apps.json`).

## Recuperation en cas de probleme

Chaque export cree un snapshot:

`content-sync/snapshots/<timestamp>/menu.json`
`content-sync/snapshots/<timestamp>/apps.json`

Pour rollback, recopier ces fichiers vers:

- `menu/menu.json`
- `data/apps.json`

