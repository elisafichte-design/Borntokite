# Ce que tu peux demander à Claude

Catalogue de ce qui se fait sur ce site sans écrire une ligne de code. Copie la phrase, adapte ce qui est entre crochets, envoie.

---

## Comment brancher Claude sur ton site

Claude peut lire ton dépôt GitHub. Une fois branché, il connaît tes textes, tes tarifs, tes règles de design, sans que tu aies à les lui réexpliquer à chaque fois.

**Dans une conversation :** clique sur le **+** en bas à gauche, choisis **Add from GitHub**, puis sélectionne le dépôt `borntokite`.

**Dans un Projet** (recommandé, parce que le branchement est permanent) : clique sur le **+** en haut à droite de la zone de connaissances, choisis **GitHub**, colle l'adresse du dépôt, et sélectionne les dossiers.

Le dépôt étant privé, GitHub te demandera d'autoriser Claude. C'est une case à cocher, une seule fois.

Le bouton **Sync now** remet le contenu à jour. Pense à cliquer dessus après avoir modifié un fichier, sinon Claude travaille sur la version d'avant.

### Qui écrit, au juste

**Claude lit ton dépôt, il n'y écrit pas.** Le circuit est celui-ci :

1. Tu lui demandes une modification.
2. Il te répond avec le texte exact à coller, et te dit dans quel fichier.
3. Tu ouvres le fichier sur GitHub, tu colles, tu valides.
4. Cloudflare reconstruit le site tout seul.

Ça prend cinq secondes de plus que si Claude écrivait directement, et ça te laisse le dernier mot sur chaque modification. Sur un site où la rédaction t'appartient, c'est plutôt une bonne chose.

Quand tu lui demandes quelque chose, précise-le :

> Donne-moi le bloc complet à coller, avec assez de lignes autour pour que je retrouve où le mettre.

---

## Avant tout : les deux phrases à ne jamais oublier

Commence chaque nouvelle conversation par :

> Lis d'abord `CLAUDE.md` et `PASSATION.md` dans le dépôt `borntokite`, puis dis-moi en trois lignes ce que tu as compris des règles du projet. Ne modifie rien pour l'instant.

Et si tu lui demandes de toucher à un texte :

> Ne réécris aucun de mes textes sans me demander. Si un texte pose un problème, propose-moi une correction, ne l'applique pas.

Un assistant a naturellement tendance à « améliorer » les phrases. C'est exactement ce qu'il ne faut pas : la rédaction du site est la tienne, elle a été choisie.

---

## Contenu

**Changer un tarif**

> Dans `pages.fr.json`, passe le cours privé 2 h de 150 € à [nouveau prix]. Donne-moi le bloc à coller. Dis-moi aussi quelle ligne changer dans `public/llms.txt`.

**Ajouter une section à une page existante**

> Écris-moi une section [sujet] à ajouter sur la page [nom]. Utilise un bloc existant, ne crée pas de nouveau type. Voici mon texte, reprends-le tel quel : [ton texte]. Donne-moi le JSON complet à coller et dis-moi où l'insérer.

**Créer une page**

> Crée la page [nom] avec le slug [adresse]. Écris-moi trois propositions de `title` sous 60 caractères et de `description` entre 140 et 160, je choisirai. Pour le corps, utilise ce texte : [ton texte]

Ajoute à la demande :

> Duplique ensuite la page dans `pages.en.json` et `pages.de.json`, traduis-la, puis crée ses trois routes explicites dans `src/pages/`, `src/pages/en/` et `src/pages/de/`. Garde le même slug dans les trois langues.

**Remplir une page vide**

> La page [nom] est marquée `"stub": true`. Remplis-la en reprenant exclusivement les textes de l'ancien site, dans `index_3.html`. N'invente aucune phrase. Là où il manque du contenu, laisse un bloc « À compléter » et liste-moi les manques à la fin.

**Écrire un article**

> Écris l'article [sujet] en suivant `STRATEGIE-CONTENU.md`. Réponse factuelle en une phrase tout en haut, un fait par phrase, des chiffres en texte. Pose-moi d'abord les questions dont tu as besoin, je suis la seule à connaître les réponses.

**Traduire une page**

> Traduis la page [nom] de `pages.fr.json` vers `pages.en.json`. Ce n'est pas du mot à mot : réécris le `title` et la `description` avec les termes réellement cherchés en anglais. Garde le slug identique au français. Signale-moi toute phrase dont la traduction change le sens.

---

## Photos

**Préparer une photo pour le site**

> Voici une photo. Convertis-la en WebP, 1600 px de large maximum, renomme-la avec un nom parlant en minuscules avec des tirets, et écris-moi un texte alternatif descriptif. Renvoie-moi le fichier : je le déposerai moi-même dans `public/photos/` via **Add file** sur GitHub. Donne-moi ensuite le JSON à coller pour la brancher sur la page [nom].

**Remplacer une photo**

> Remplace la photo [nom actuel] sur la page [page] par celle-ci. Garde la même règle : l'argentique porte l'identité, le turquoise porte l'information. Vérifie que la page reste sous 1,5 Mo.

**Recadrer ou éclaircir**

> Recadre cette photo en 3/2 pour un bandeau pleine largeur, en gardant [ce qui doit rester visible]. Elle est un peu sombre, éclaircis-la légèrement sans toucher aux couleurs.

**Vérifier le poids d'une page**

> Fais la somme du poids de la page [nom] avec toutes ses images et dis-moi si elle dépasse 1,5 Mo. Si oui, dis-moi quelle image compresser.

---

## Ce qui reste à finir sur le site

### La réservation en ligne, Calendly et WhatsApp

**État réel :** le travail a été commencé puis interrompu. Ce qui existe aujourd'hui :

- les libellés du formulaire sont en place dans `pages.en.json` et `pages.de.json`, sous `ui.booking`, y compris le modèle de message WhatsApp ;
- le champ `calendlyUrl` existe dans `site.json`, **il est vide** ;
- **il manque** : les libellés en français, le composant lui-même, et son branchement dans le gabarit.

**Le principe retenu :** un micro-formulaire de quatre champs (prénom, activité, jour souhaité, matin ou après-midi) qui n'envoie rien tout seul. Il ouvre WhatsApp avec un message déjà écrit, que le visiteur envoie s'il le veut. L'horaire exact est confirmé ensuite selon le vent. Calendly est branché en lien sortant, **jamais en iframe**, pour ne pas déposer de cookie tiers et garder le site sans bandeau de consentement.

La phrase à envoyer :

> Termine l'intégration de la réservation. Crée le composant `Booking.astro` en respectant les jetons de `tokens.css`, puis branche-le dans `src/layouts/ContentPage.astro`. Quatre champs maximum. Le formulaire n'envoie rien : il ouvre WhatsApp avec le message pré-rempli. Le lien Calendly est un lien sortant, jamais une iframe, et il ne s'affiche que si `calendlyUrl` est renseigné dans `site.json`.

**Ce que tu dois faire toi, avant :** créer le compte Calendly, régler le fuseau sur `Indian/Mauritius`, et coller son adresse dans `calendlyUrl`. Tant que le champ est vide, le bouton ne s'affiche pas, c'est voulu.

### Le tableau du vent

Le composant est codé et attend ses données. Le questionnaire est prêt, douze lignes à remplir avec Ritik.

> Voici les réponses de Ritik pour le vent mois par mois : [colle le tableau]. Remplis le bloc `windmonths` et place-le sur la page du spot.

### Les autres manques

> Liste-moi tout ce qui reste marqué `"aValider": true` ou `"stub": true` dans `pages.fr.json`, ainsi que le `_todo` de `site.json`. Classe-les par impact.

---

## Vérifier avant de publier

**Contrôle complet**

> Vérifie le site avant publication : longueur des `title` et des `description`, doublons entre les langues, un seul `h1` par page, textes alternatifs sur toutes les images, données structurées valides, poids de chaque page. Fais-moi la liste des problèmes classés par impact, ne corrige rien encore.

**Contrôle d'une page**

> Fais un contrôle de référencement sur la page [nom] et dis-moi ce qui cloche.

**Vérifier les données structurées**

> Extrais le JSON-LD de la page [nom] et vérifie qu'il est valide. Rappel : pas d'`AggregateRating` ni de `Review`, c'est délibéré, ne les ajoute pas.

---

## Quand quelque chose casse

**Un déploiement a échoué**

> Le déploiement Cloudflare a échoué. Voici le message : [colle le journal]. Dis-moi quel fichier corriger et comment.

Neuf fois sur dix, c'est une virgule en trop ou manquante dans un fichier JSON. Et le site reste en ligne dans sa version précédente, tu as le temps.

**Le site local ne démarre pas**

> Voici ce qu'affiche le Terminal quand je lance `voir-le-site.command` : [colle le message].

**Une page ne s'affiche pas comme prévu**

> Sur la page [nom], [ce que tu vois] au lieu de [ce que tu attends]. Regarde le composant concerné dans `src/components/blocks/`.

---

## Ce qu'il ne faut pas lui laisser faire

Dis-le-lui explicitement s'il s'en approche :

- **Réécrire tes textes** sans te demander.
- **Ajouter une couleur, une police ou un arrondi** qui ne sont pas dans `tokens.css`.
- **Ajouter une dépendance npm.** Le projet en a deux, c'est un choix.
- **Ajouter un script tiers ou un cookie.** C'est ce qui permet de ne pas avoir de bandeau cookies.
- **Ajouter un balisage `AggregateRating` ou `Review`.** L'absence est volontaire, la raison est écrite dans `CLAUDE.md`.
- **Mettre un prix dans une image.** Jamais.
- **Retoucher un avis client.** Ils sont reproduits mot pour mot, fautes comprises.

---

## Le circuit, pour comprendre ce qui se passe

Tu modifies un fichier sur **GitHub** → **Cloudflare Pages** le voit, reconstruit le site → la nouvelle version est en ligne en une minute environ.

Le nom de domaine est branché sur **Cloudflare**, pas sur GitHub. GitHub ne sert pas le site, il ne fait que stocker le code.

Si la reconstruction échoue, **l'ancienne version reste en ligne**. Tu ne peux pas casser le site.
