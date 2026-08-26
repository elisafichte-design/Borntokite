#!/bin/bash
#
# Born To Kite — voir le site en local dans Chrome.
#
# Double-clic depuis le Finder, ou bien : ./voir-le-site.command
# Le site se met à jour tout seul à chaque fois que tu enregistres un fichier.
#
# Pour arrêter : Ctrl + C dans cette fenêtre, ou ferme-la.
#
# Deux pièges que ce script gère :
#  - un double-clic n'ouvre pas le même environnement que ton Terminal, donc
#    Node installé via nvm ou Homebrew peut être introuvable. On recharge donc
#    les profils du shell et on ajoute les emplacements habituels au PATH.
#  - Astro utilise le port 4321 par défaut, donc deux projets Astro ouverts en
#    même temps se marchent dessus. Born To Kite prend la plage 4331 et suivants,
#    et on vérifie toujours que la page qui répond est bien la bonne.

cd "$(dirname "$0")" || exit 1

NOM="Born To Kite"
PORT_DEPART=4331
PORT_FIN=4340

# La fenêtre reste ouverte sur une erreur, sinon le message est illisible.
mourir() {
  echo ""
  echo "  $1"
  echo ""
  read -r -p "Appuie sur Entrée pour fermer cette fenêtre."
  exit 1
}

# --- Retrouver Node, quel que soit le mode d'installation ---
for profil in "$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.profile"; do
  [ -r "$profil" ] && . "$profil" >/dev/null 2>&1
done
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" >/dev/null 2>&1

if ! command -v npm >/dev/null 2>&1; then
  echo ""
  echo "  Node.js est introuvable."
  echo ""
  echo "  Vérifie dans ton Terminal habituel : node --version"
  echo "  Si ça ne répond rien, installe la version LTS sur https://nodejs.org"
  mourir "Sans Node.js, le site ne peut pas démarrer."
fi

echo "  Node $(node --version 2>/dev/null), npm $(npm --version 2>/dev/null)"

ouvrir_navigateur() {
  local url="http://localhost:$1"
  open -a "Google Chrome" "$url" 2>/dev/null || open "$url"
}

port_libre() {
  ! lsof -nP -iTCP:"$1" -sTCP:LISTEN >/dev/null 2>&1
}

est_born_to_kite() {
  curl -s --max-time 2 "http://localhost:$1/" 2>/dev/null | grep -qi "$NOM"
}

# --- Choisir un port ---
PORT=""
for p in $(seq "$PORT_DEPART" "$PORT_FIN"); do
  if port_libre "$p"; then
    PORT="$p"
    break
  fi
  if est_born_to_kite "$p"; then
    echo ""
    echo "  $NOM tourne déjà sur http://localhost:$p"
    echo ""
    ouvrir_navigateur "$p"
    exit 0
  fi
  echo "  Port $p occupé par autre chose, j'essaie le suivant."
done

[ -z "$PORT" ] && mourir "Aucun port libre entre $PORT_DEPART et $PORT_FIN. Ferme les autres serveurs, puis relance."

# --- Première utilisation ---
if [ ! -d node_modules ]; then
  echo ""
  echo "  Première utilisation : installation des dépendances."
  echo "  Compte environ une minute, c'est la seule fois."
  echo ""
  npm install || mourir "L'installation des dépendances a échoué. Le message ci-dessus dit pourquoi."
fi

# --- Ouvrir Chrome dès que le bon site répond ---
(
  for _ in $(seq 1 90); do
    if est_born_to_kite "$PORT"; then
      ouvrir_navigateur "$PORT"
      exit 0
    fi
    sleep 1
  done
  echo ""
  echo "  Le serveur met un temps inhabituel à démarrer."
  echo "  Ouvre http://localhost:$PORT à la main."
) &

echo ""
echo "  $NOM — site local"
echo "  http://localhost:$PORT"
echo ""
echo "  Chrome va s'ouvrir tout seul."
echo "  Laisse cette fenêtre ouverte pendant que tu travailles."
echo "  Pour arrêter : Ctrl + C."
echo ""

npm run dev -- --port "$PORT"
CODE=$?

if [ "$CODE" -ne 0 ] && [ "$CODE" -ne 130 ]; then
  mourir "Le serveur s'est arrêté sur une erreur (code $CODE). Le message ci-dessus dit pourquoi."
fi

echo ""
echo "  Serveur arrêté."
