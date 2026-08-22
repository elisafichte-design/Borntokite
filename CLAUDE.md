# Born To Kite — règles du projet

École de kitesurf, wingfoil et surf au Morne, île Maurice. Site statique Astro, hébergé sur Cloudflare Pages.

## Règles non négociables

1. **La rédaction appartient à la cliente.** Les titres et les textes du site actuel ont été écrits par elle. Ne jamais les réécrire, les raccourcir ou les « améliorer » sans validation explicite. Si un texte pose un problème de référencement, le régler par le `title`, la `description` ou un `h2`, pas en modifiant sa phrase.
2. **Sept couleurs, pas une de plus.** Le site suit la piste A « Éditorial photo » de la maquette `pistes-charte-graphique.html` : fond crème `#faf8f4`, encre bleu-nuit `#14202b`, un seul accent terracotta `#b4532a`. Les jetons de `src/styles/tokens.css` font foi. Aucune couleur en dur dans un composant. Aucun dégradé de couleur à couleur, le seul dégradé autorisé est `--overlay-image` (le voile du hero, quatre arrêts). L'accent ne doit jamais dépasser trois éléments par écran.

   *L'ancienne piste sombre (`#0D0F10`, vert acide `#D8FF3E`) reste récupérable dans l'historique git.*
3. **Un seul arrondi : 2 px, et aucune carte.** Pas de conteneur à fond, pas d'ombre portée : la hiérarchie repose sur le contraste serif/sans, l'échelle typographique et les filets 1 px. Les états d'interaction se jouent en opacité et en bordure, jamais en agrandissement ou en déplacement.
4. **Aucun cookie tiers.** Pas de widget d'avis embarqué, pas de vidéo intégrée directement, pas d'analytics à cookie. Mesure d'audience via Cloudflare Web Analytics. Cette contrainte est ce qui permet de ne pas avoir de bandeau cookies, ne pas la casser sans en mesurer le coût.
5. **Mobile d'abord.** Le trafic est majoritairement mobile et souvent en itinérance. Objectif : moins de 1,5 Mo par page, LCP sous 2,5 s en 4G.

## Architecture

Le contenu est en JSON, le rendu est mutualisé, mais chaque URL possède un
fichier de route explicite. Cette structure permet aux outils branchés sur
GitHub, notamment Claude Design, de reconnaître et modifier un vrai site
multipage.

- `src/data/site.json` — coordonnées, langues, informations d'entreprise.
- `src/data/pages.<lang>.json` — toutes les pages d'une langue, sous forme de blocs.
- `src/pages/` — une route explicite par page française, anglaise et allemande.
- `src/layouts/ContentPage.astro` — rendu commun des blocs, SEO et JSON-LD.
- `src/components/blocks/` — un composant par type de bloc.

**Ajouter une page** : ajouter une entrée avec le même `slug` dans les trois
fichiers `pages.<lang>.json`, puis créer les trois petits fichiers de route dans
`src/pages/`, `src/pages/en/` et `src/pages/de/`. Le sitemap et les `hreflang`
suivent ensuite automatiquement.

**Ajouter une langue** : dupliquer `pages.fr.json`, traduire, ajouter le code dans `site.json`. Les slugs restent identiques d'une langue à l'autre, c'est ce qui permet aux `hreflang` de se répondre correctement.

**Modifier un tarif** : un seul endroit par langue, le bloc `prices` de la page `tarifs`. Penser à reporter dans `public/llms.txt`, qui est ce que lisent les assistants IA.

## Types de blocs disponibles

`hero`, `prose`, `stats`, `prices`, `faq`, `cta`, `image`, `cards`, `gallery`, `weather`, `reviews`. Avant d'en créer un nouveau, vérifier qu'aucun existant ne convient. Un système à onze blocs reste maintenable, un système à trente ne l'est plus.

- `image` — `full: true` (défaut) pour un bandeau pleine largeur recadré en 3/2, réservé aux photos paysage ; `full: false` pour une image dans la colonne de texte, ratio conservé, pour les portraits. `caption` optionnel.
- `cards` — orientation vers les pages disciplines. Photo, titre, phrase, lien. Aucun conteneur.
- `gallery` — grille carrée, 2 colonnes en mobile, 4 en bureau.
- `weather` — Windguru, spot 118, **en chargement au clic**. L'iframe n'est injectée qu'après action du visiteur : c'est ce qui permet de tenir la règle 4 et de ne pas afficher de bandeau cookies. Ne pas la remplacer par une iframe posée directement.
- `reviews` — avis clients en texte, reproduits mot pour mot.
- `cta` — deux rendus. Par défaut, un bouton WhatsApp. Avec `"form": true`, le micro-formulaire de réservation : prénom, activité, jour, matin ou après-midi, puis bascule vers WhatsApp avec le message déjà écrit. Aucun envoi vers un serveur, aucun script tiers, environ 700 octets de JavaScript inclus dans le HTML. Les libellés et le modèle de message sont dans `ui.booking` de chaque `pages.<lang>.json`, jamais dans le composant.

Réservation : le visiteur choisit un jour et une demi-journée, jamais une heure. L'horaire se confirme sur WhatsApp selon le vent. Le bouton Calendly n'apparaît que si `calendlyUrl` est rempli dans `site.json`, et **en lien sortant, jamais en iframe** : l'embed Calendly dépose ses propres cookies et casserait la règle 4. Détail dans le doc projet `btk-reservation-en-ligne.md`.

Règle de placement des photos, tirée du brief de la cliente : **l'argentique porte l'identité** (hero, respirations), **le turquoise porte l'information** (le lieu, le matériel, les cours). Jamais les deux traitements dans un même bloc, et une seule photo dorée par page, jamais en hero de l'accueil.

Un seul `h1` par page : le hero le porte, et sans hero le template promeut automatiquement le premier `prose` titré.

## Référencement

- `title` et `description` sont dans le JSON de chaque page, ils ne sont pas générés.
- Le JSON-LD `SportsActivityLocation` est posé sur toutes les pages, la `FAQPage` s'ajoute automatiquement dès qu'une page contient un bloc `faq`.
- `public/robots.txt` est volontairement ouvert aux robots des assistants IA. L'objectif du site est d'être cité comme source.
- `public/llms.txt` doit rester à jour, c'est le résumé que lisent les assistants.
- `sameAs` porte les trois profils officiels vérifiés : fiche Google (`maps.google.com/?cid=16583647237779172102`), Instagram, Threads. Ne jamais y ajouter une URL sans l'avoir ouverte.
- **Pas d'`AggregateRating` ni de `Review`, c'est délibéré.** Google interdit de baliser des notes récupérées sur un site tiers, sa propre fiche comprise, et ne montre de toute façon pas d'extrait d'avis pour un `LocalBusiness` qui se note lui-même. Les avis sont affichés en texte HTML : les assistants IA les lisent, et le site ne prend aucun risque. Ne pas « corriger » cette absence.
- Les avis sont reproduits mot pour mot, fautes de frappe comprises. Ne jamais retoucher un avis.
- À faire quand le contenu sera complet : `Course` et `Offer` sur les pages cours.

## État actuel

Fait : structure multipage explicite, design system (piste A), contenus complets
FR/EN/DE, SEO technique, photos, page d'accueil complète, tarifs, spot, météo,
kitesurf, wingfoil, surf, excursions, downwind, leçon VIP, carte cadeau, équipe,
contact et informations légales.

Logo : `public/logo-wordmark-encre.png` pour l'en-tête et le pied de page ; `public/logo-wordmark-blanc.png` pour un usage sur photo ou fond sombre. Les variantes principales et les symboles optimisés pour le web sont également rangés dans `public/` sous les noms `logo-principal-*` et `logo-symbole-*`.

À faire : versions courtes ES et RU, Cloudflare Web Analytics, URL Calendly à
coller dans `site.json`, et confirmation des tarifs de supervision, location et
stages multi-jours.

Quatre titres de pages qu'elle n'a jamais écrites sont marqués `"aValider": true` dans `pages.fr.json` : tarifs, kitesurf, wingfoil, surf. Des alternatives à lui soumettre sont dans le doc projet `btk-decisions-structure.md`.

Fiche Google Business Profile : elle **existe** (5,0 sur 31 avis). Deux trous à faire combler par la cliente, dans cet ordre : le champ site web est vide, et la catégorie est « Club de sport » au lieu d'« École de kitesurf ».

Bloqué côté cliente : confirmation du numéro WhatsApp, du contact public, des
horaires d'ouverture et des tarifs encore indiqués « sur demande ».

## Emplacement des fichiers

Le code vit sur le Bureau, dans `Site ecoles de kite Maurice/Born to kite/borntokite`, **hors de Google Drive**. C'est délibéré : un `npm install` pose environ 200 Mo et des dizaines de milliers de fichiers, que Drive tenterait de synchroniser, avec des conflits pendant les builds.

Le Drive garde ce qu'il fait bien et que la cliente doit voir : brief, audits, marque et design system, photos, vidéos, site actuel, livrables. Ne jamais y remettre le code.

Les 41 photos du site actuel, converties en WebP, sont dans `../photos-source/` à côté du projet. Elles ne sont pas versionnées telles quelles : y piocher, renommer avec des noms parlants, et déposer dans `public/photos/` uniquement ce qui est utilisé.

Un dossier nommé `_prive` ou `_a-supprimer`, où qu'il soit, ne doit jamais être lu ni modifié.
