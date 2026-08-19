# borntokite

Site de l'école Born To Kite, Le Morne, île Maurice.

Astro en site statique, sans base de données, sans serveur, sans abonnement. Le contenu vit dans des fichiers JSON, le build produit du HTML pur.

## Démarrer

Il faut Node.js 20 ou plus.

```bash
npm install     # une seule fois
npm run dev     # http://localhost:4321
npm run build   # génère le site dans dist/
```

## Structure

```
src/
  data/          contenu du site (JSON), une entrée par page et par langue
  styles/        jetons du design system, copie conforme du Drive
  layouts/       rendu commun, head, SEO, hreflang, JSON-LD
  components/    en-tête, pied de page
    blocks/      un composant par type de bloc de contenu
  pages/         une route Astro explicite par page et par langue
public/          images, logo, robots.txt, llms.txt, favicon
```

Les 42 routes sont volontairement visibles dans `src/pages/` (`fr`, `en` et
`de`). GitHub, Claude Design et les autres outils reconnaissent ainsi le projet
comme un site multipage. Le rendu reste mutualisé dans
`src/layouts/ContentPage.astro` et les textes restent dans les trois fichiers
JSON de `src/data/`.

## Mettre en ligne sur Cloudflare Pages

1. Pousser le dépôt sur GitHub.
2. Dans Cloudflare, Workers & Pages, créer une application Pages et connecter le dépôt.
3. Commande de build : `npm run build`. Dossier de sortie : `dist`.
4. Ajouter le domaine `borntokitemauritius.com` dans l'onglet Custom domains. Cloudflare gère le certificat HTTPS, ce qui règle au passage l'erreur TLS actuelle.
5. Activer Cloudflare Web Analytics, gratuit et sans cookie.

Chaque `git push` redéploie automatiquement.

## Où modifier quoi

| Ce que vous voulez changer | Fichier |
| --- | --- |
| Un tarif | `src/data/pages.fr.json`, bloc `prices` de la page `tarifs`, puis `public/llms.txt` |
| Le téléphone, l'adresse, l'e-mail | `src/data/site.json` |
| Le texte d'une page | `src/data/pages.<langue>.json` |
| Une couleur, une taille de texte | `src/styles/tokens.css` |
| Ajouter une photo | la déposer dans `public/photos/`, la référencer dans le JSON |

Lorsqu'une nouvelle page est créée, ajouter son entrée dans les trois JSON puis
un petit fichier de route dans `src/pages/`, `src/pages/en/` et `src/pages/de/`.

Les règles de travail sur ce projet sont dans `CLAUDE.md`.
