# site-principal

Hub principal pour centraliser les projets GitHub Pages:

- Quizz IA
- IA: Notre Nouvelle Autoroute
- Laboratoire Google Dorking
- Reseau de Neurones Spatial

## URLs des sites

- Hub principal: `https://chab974.github.io/site-principal/`
- Quizz IA: `https://chab974.github.io/quizz-IA/`
- Autoroute IA: `https://chab974.github.io/ia-notre-nouvelle-autoroute/`
- Dorking Lab: `https://chab974.github.io/laboratoire-google-dorking-osint/`
- Reseau de Neurones Spatial: `https://chab974.github.io/reseau-neurones-spatial-guide/`

## Structure

- `index.html`: page d'accueil du hub
- `data/apps.json`: catalogue des projets affiches dans les cartes
- `menu/menu.json`: source unique du menu de navigation partage
- `menu/menu.js`: script charge par tous les sites pour afficher le menu
- `content-sync/`: source de verite SQLite + export JSON

## Modifier les liens projets

Le mode recommande est:

1. Modifier la base SQLite locale (`content-sync/.local/content.db`)
2. Lancer `./content-sync/scripts/export_content.sh`
3. Committer les fichiers exportes:
   - `data/apps.json`
   - `menu/menu.json`

Modification directe des JSON possible en depannage, mais pas recommandee.

## Menu global synchronise

Le menu est injecte dynamiquement dans chaque site via:

`<script src="https://chab974.github.io/site-principal/menu/menu.js" defer></script>`

Pour ajouter/modifier un element de navigation, modifiez uniquement:

- la base SQLite (table `menu_items`)
- puis lancez l'export pour regenerer `menu/menu.json`

Une fois pousse sur `site-principal`, la modification est visible partout ou le script est present.

## Source de verite SQLite

Initialisation:

```bash
cd /Users/chab/Documents/AI-SANDBOX/GITHUB/IA-PPT/site-principal
sqlite3 content-sync/.local/content.db < content-sync/migrations/001_init.sql
sqlite3 content-sync/.local/content.db < content-sync/seeds/001_seed_from_current.sql
```

Export manuel:

```bash
./content-sync/scripts/export_content.sh
```

Snapshot seulement:

```bash
./content-sync/scripts/export_content.sh --snapshot-only
```

Chaque export cree un backup JSON dans `content-sync/snapshots/<timestamp>/`.

## Recettes rapides SQLite

Base:

```bash
cd /Users/chab/Documents/AI-SANDBOX/GITHUB/IA-PPT/site-principal
```

1) Renommer un item menu:

```bash
sqlite3 content-sync/.local/content.db "UPDATE menu_items SET label='Dorking OSINT' WHERE id='mi_dorking';"
./content-sync/scripts/export_content.sh
git add menu/menu.json data/apps.json
git commit -m "content: rename dorking menu label"
git push
```

2) Changer l'URL d'un site:

```bash
sqlite3 content-sync/.local/content.db "UPDATE sites SET url='https://chab974.github.io/ia-notre-nouvelle-autoroute/' WHERE id='autoroute';"
./content-sync/scripts/export_content.sh
git add menu/menu.json data/apps.json
git commit -m "content: update autoroute URL"
git push
```

3) Masquer ou afficher un item menu:

```bash
# Masquer
sqlite3 content-sync/.local/content.db "UPDATE menu_items SET visible=0 WHERE id='mi_neurones';"
# Afficher
# sqlite3 content-sync/.local/content.db "UPDATE menu_items SET visible=1 WHERE id='mi_neurones';"
./content-sync/scripts/export_content.sh
git add menu/menu.json data/apps.json
git commit -m "content: toggle neurones menu visibility"
git push
```

4) Reordonner le menu:

```bash
sqlite3 content-sync/.local/content.db "UPDATE menu_items SET sort_order=2 WHERE id='mi_quiz';"
sqlite3 content-sync/.local/content.db "UPDATE menu_items SET sort_order=3 WHERE id='mi_autoroute';"
./content-sync/scripts/export_content.sh
git add menu/menu.json data/apps.json
git commit -m "content: reorder menu items"
git push
```

5) Revenir aux valeurs seed:

```bash
sqlite3 content-sync/.local/content.db < content-sync/seeds/001_seed_from_current.sql
./content-sync/scripts/export_content.sh
git add menu/menu.json data/apps.json
git commit -m "content: restore seed defaults"
git push
```

## Publication

Le hub est publie via GitHub Pages depuis:

- branche: `main`
- dossier: `/` (racine du repo)
