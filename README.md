# site-principal

Hub principal pour centraliser 3 projets GitHub Pages:

- Quizz IA
- IA: Notre Nouvelle Autoroute
- Laboratoire Google Dorking

## Structure

- `index.html`: page d'accueil du hub
- `data/apps.json`: catalogue des projets affiches dans les cartes
- `menu/menu.json`: source unique du menu de navigation partage
- `menu/menu.js`: script charge par tous les sites pour afficher le menu

## Modifier les liens projets

Editez `data/apps.json` et mettez a jour:

- `title`
- `description`
- `url` (GitHub Pages)
- `repo` (GitHub repository)

## Menu global synchronise

Le menu est injecte dynamiquement dans chaque site via:

`<script src="https://chab974.github.io/site-principal/menu/menu.js" defer></script>`

Pour ajouter/modifier un element de navigation, modifiez uniquement:

- `menu/menu.json`

Une fois pousse sur `site-principal`, la modification est visible partout ou le script est present.

## Publication

Le hub est publie via GitHub Pages depuis:

- branche: `main`
- dossier: `/` (racine du repo)
