# Le site Born To Kite, mode d'emploi

Ce document est écrit pour toi, pas pour un développeur. Aucune connaissance technique n'est nécessaire. Tout se fait depuis ton navigateur.

Si tu utilises Claude, tu peux lui donner ce fichier : il te dira quoi coller et où. Il trouvera les règles techniques dans `CLAUDE.md`, à côté de celui-ci. Voir la section 10.

---

## 1. Comment le site fonctionne, en trois phrases

Ton site n'est pas un site classique avec un panneau d'administration. C'est un site **statique** : des pages toutes prêtes, servies directement, ce qui le rend très rapide et **gratuit à héberger**.

Le contenu (tes textes, tes tarifs, tes photos) vit dans quelques fichiers sur **GitHub**. Quand tu modifies un de ces fichiers, **Cloudflare reconstruit le site tout seul** et la nouvelle version est en ligne en une minute environ.

Tu n'as jamais besoin d'installer quoi que ce soit sur ton ordinateur.

---

## 2. La chose la plus importante à savoir

**Tu ne peux pas casser le site.**

Si tu fais une erreur dans un fichier, la reconstruction échoue et **l'ancienne version reste en ligne**. Personne ne voit d'erreur, le site continue de tourner comme avant. Tu corriges, ça repart.

Alors n'aie pas peur de toucher aux fichiers. Le pire qui puisse arriver, c'est que ta modification ne s'applique pas.

---

## 3. Où est le contenu

Trois fichiers seulement, dans le dossier `src/data/` :

| Fichier | Ce qu'il contient |
|---|---|
| `pages.fr.json` | **Toutes les pages du site en français** : titres, textes, tarifs, photos, questions fréquentes |
| `pages.en.json` | Toutes les pages, entièrement traduites en anglais |
| `pages.de.json` | Toutes les pages, entièrement traduites en allemand |
| `site.json` | Tes coordonnées : téléphone, e-mail, adresse, Instagram |

Tout le reste du dépôt, c'est la mécanique. Tu n'y touches pas.

---

## 4. Changer un tarif

C'est la manipulation que tu feras le plus souvent. Cinq étapes.

1. Va sur ton dépôt GitHub, ouvre le dossier `src/data`, clique sur **`pages.fr.json`**.
2. Clique sur l'icône **crayon** en haut à droite du fichier.
3. Utilise **Ctrl+F** (ou Cmd+F sur Mac) pour chercher le tarif, par exemple `150`.
4. Change le chiffre. **Ne touche à rien d'autre** : ni aux guillemets, ni aux virgules, ni aux crochets.
5. Descends en bas de la page, écris une courte description du changement (« Nouveau tarif cours privé 2 h ») et clique sur **Commit changes**.

Une minute plus tard, le site est à jour.

**Attention :** les tarifs sont aussi écrits dans `public/llms.txt`, le fichier que lisent ChatGPT, Claude et les autres assistants. Pense à les changer là aussi, sinon ils continueront de donner l'ancien prix aux gens qui leur posent la question.

---

## 5. Ajouter une page

Dans `pages.fr.json`, tu verras une longue liste de pages. Chacune ressemble à ça :

```
{
  "slug": "carte-cadeau",
  "title": "Carte cadeau kitesurf au Morne, île Maurice",
  "description": "Une phrase de 140 à 160 caractères qui donne envie de cliquer dans Google.",
  "blocks": [ ... ]
}
```

- **`slug`** : l'adresse de la page. `carte-cadeau` donnera `borntokitemauritius.com/carte-cadeau/`. En minuscules, sans accent, avec des tirets à la place des espaces.
- **`title`** : ce qui s'affiche dans l'onglet du navigateur et dans les résultats Google. Sous 60 caractères.
- **`description`** : le petit texte gris sous le titre dans Google. Entre 140 et 160 caractères.
- **`blocks`** : le contenu de la page, morceau par morceau.

Copie une page existante, change le `slug`, le `title`, la `description` et les
textes dans les trois fichiers de langue. Demande ensuite à Claude de créer les
trois petits fichiers de route correspondants dans `src/pages/`,
`src/pages/en/` et `src/pages/de/`. Le plan du site et les liens entre les
langues se mettent alors à jour tout seuls.

---

## 6. Les types de blocs disponibles

Une page est une suite de blocs. Il en existe treize, pas un de plus. C'est volontaire : un site avec quinze mises en page différentes devient impossible à tenir.

| Bloc | À quoi il sert |
|---|---|
| `hero` | La grande image d'en-tête avec le titre par-dessus |
| `prose` | Un titre et des paragraphes |
| `image` | Une photo en pleine largeur, ou dans la colonne de texte |
| `cards` | Trois choix côte à côte avec photo, comme « Trois façons de glisser sur le lagon » |
| `stats` | Les trois chiffres clés |
| `prices` | Une grille de tarifs |
| `gallery` | Une grille de photos |
| `reviews` | Les avis clients |
| `weather` | Le module Windguru |
| `faq` | Les questions fréquentes en accordéon |
| `cta` | Le bloc qui invite à écrire sur WhatsApp |
| `windmonths` | Le tableau du vent mois par mois |
| `sectionnav` | Le petit menu collant qui suit quand on descend dans une page longue |

Si tu ne sais pas lequel utiliser, demande à Claude en lui montrant ce tableau.

---

## 7. Ajouter ou remplacer une photo

1. Prépare ton image en **WebP**, largeur 1600 pixels maximum. Claude ou n'importe quel convertisseur en ligne peut le faire.
2. Nomme-la avec de vrais mots, en minuscules avec des tirets : `cours-de-kitesurf-debutant-le-morne.webp`. **Jamais** `IMG_4523.webp`. Google lit le nom du fichier.
3. Sur GitHub, va dans `public/photos/`, clique sur **Add file** puis **Upload files**, dépose ton image, et valide.
4. Dans `pages.fr.json`, référence-la : `"image": "/photos/ton-nom-de-fichier.webp"`.
5. **Écris toujours un `alt`**, une phrase qui décrit ce qu'on voit. C'est obligatoire : pour les personnes malvoyantes, et parce que Google ne voit pas les images, il lit cette phrase.

**La règle photo du site**, celle que tu as demandée au départ : l'argentique porte l'identité, en grand, en en-tête et entre deux sections. Les photos nettes du lagon portent l'information, dans les pages cours, tarifs et spot. On ne mélange jamais les deux traitements dans un même bloc, et une seule photo dorée par page.

---

## 8. Ce qu'il ne faut jamais toucher

- **Les couleurs, les polices, les arrondis.** Ils sont dans `src/styles/tokens.css`. Sept couleurs, deux polices, un seul arrondi. Le jour où on ajoute une huitième couleur, le site commence à ressembler à tous les autres.
- **Les fichiers dans `src/components/` et `src/pages/`.** C'est la mécanique.
- **Le fichier `astro.config.mjs`.**
- **Les prix dans une image.** Jamais. Les chiffres doivent toujours être en texte, sinon ni Google ni les assistants IA ne peuvent les lire. C'est un des trois avantages qu'on a sur les autres écoles du Morne.

---

## 9. Quand un déploiement échoue

Tu recevras un e-mail de Cloudflare. Pas de panique : ton site est toujours en ligne dans sa version précédente.

1. Connecte-toi sur **dash.cloudflare.com**, ouvre ton projet Pages, onglet **Deployments**.
2. Clique sur le déploiement en rouge, puis sur le journal de construction.
3. Dans 9 cas sur 10, c'est une **virgule en trop ou manquante** dans un fichier JSON. Le message indique le fichier et la ligne.
4. Retourne sur GitHub, corrige, valide. C'est reparti.

Si tu utilises Claude : copie-lui le message d'erreur, il te dira exactement quoi corriger.

---

## 10. Travailler avec ton Claude

C'est la façon la plus simple d'animer le site.

**Brancher Claude sur le dépôt :** dans une conversation, le bouton **+** en bas à gauche puis **Add from GitHub**. Dans un Projet, le **+** en haut à droite de la zone de connaissances puis **GitHub**, et tu colles l'adresse du dépôt. Comme il est privé, GitHub te demandera d'autoriser Claude une fois. Le bouton **Sync now** remet le contenu à jour après chaque modification.

**Attention à un point :** Claude **lit** le dépôt, il n'y écrit pas. Il te donne le texte exact à coller, et c'est toi qui colles sur GitHub et qui valides. Cinq secondes de plus, et tu gardes le dernier mot sur chaque modification.

Ensuite, demande-lui en langage normal :

> « Dans mon dépôt borntokite, ajoute une page sur les stages multi-jours. Lis d'abord CLAUDE.md et PASSATION.md pour respecter les règles du projet. »

Deux consignes à lui répéter, parce qu'elles comptent :

1. **Lire `CLAUDE.md` avant de modifier quoi que ce soit.** Ce fichier contient les règles non négociables du projet, écrites pour être lues par un assistant.
2. **Ne jamais réécrire tes textes sans te demander.** La rédaction du site est la tienne. Un assistant a naturellement tendance à « améliorer » les phrases ; c'est exactement ce qu'il ne faut pas.

---

## 11. Les trois choses qui font marcher ce site

Elles ne sont pas évidentes, et aucune des dix-huit écoles du Morne ne les réunit. Si tu ne dois retenir que ça :

1. **Tes tarifs sont affichés, en texte, sur une page qui se référence.** Tes concurrents cachent les leurs derrière un formulaire ou un moteur de réservation. La personne qui cherche « prix cours kitesurf Maurice » te trouve toi.
2. **Le site se charge en moins de deux secondes sur un téléphone en itinérance.** Tes clients cherchent depuis leur hôtel, avec une connexion moyenne. Chaque seconde de chargement en fait partir.
3. **Les données structurées.** Un code invisible qui explique à Google et aux assistants IA que tu es une école de sport nautique au Morne, avec telles activités, tel téléphone. C'est ce qui te fait citer quand quelqu'un demande à ChatGPT où apprendre le kite à Maurice.

Tout le reste est secondaire. Si une modification met un de ces trois points en danger, ne la fais pas.
