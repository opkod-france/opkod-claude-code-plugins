# Site vitrine — Numérisation de broderie

Site one-page statique (HTML + Tailwind via CDN). Aucun build nécessaire.

## Placeholders à remplacer

Cherchez et remplacez ces marqueurs dans `index.html` :

- `[NOM DE LA MARQUE]` — votre nom commercial
- `[VOTRE-EMAIL]` — email de contact
- `[VOTRE-NUMERO]` — numéro WhatsApp (format international sans `+`, ex : `33612345678`)
- `[VOTRE-COMPTE]` — pseudo Instagram
- `[VOTRE-PAGE]` — slug de votre page Facebook
- `[XX]` — nombre de fichiers dans votre collection (2 occurrences)
- `[ Photo hero — votre meilleure broderie ]` — remplacez le bloc par une vraie `<img>` ; image carrée recommandée
- `[ Image manga / anime ]` et `[ Image calligraphie ]` — idem, format 4/5
- `[ Aperçu 1 ]` à `[ Aperçu 8 ]` — vignettes carrées de la collection
- `[ Témoignage client … ]` et `[ Nom du client, type de projet ]` — un avis client
- `[à compléter]` dans la liste des formats — ajoutez/retirez selon vos compétences

Pour ajouter une image, remplacez par exemple :

```html
<div class="aspect-square bg-ink/5 rounded-xl flex items-center justify-center border border-ink/10">
    <p class="font-serif italic text-ink/40 text-sm">[ Aperçu 1 ]</p>
</div>
```

par :

```html
<img src="assets/apercu-1.jpg" alt="..." class="aspect-square w-full object-cover rounded-xl border border-ink/10">
```

Placez vos images dans `broderie/assets/`.

## Tester en local

Ouvrez simplement `index.html` dans votre navigateur, ou lancez un mini-serveur :

```bash
cd broderie
python3 -m http.server 8000
# puis http://localhost:8000
```

## Déployer sur Netlify

Deux options.

### Option 1 — Drag & drop (le plus simple)

1. Allez sur https://app.netlify.com/drop
2. Glissez-déposez le dossier `broderie/` entier
3. Netlify vous donne une URL en `.netlify.app` immédiatement
4. Dans les réglages du site, vous pouvez :
   - Renommer le sous-domaine (ex : `votre-marque.netlify.app`)
   - Brancher un nom de domaine personnalisé

### Option 2 — Connexion Git (auto-déploiement à chaque push)

1. Sur https://app.netlify.com → **Add new site** → **Import from Git**
2. Choisissez ce repo
3. Réglages de build :
   - **Branch to deploy** : `claude/embroidery-service-announcement-BNRsV` (ou la branche que vous souhaitez)
   - **Base directory** : `broderie`
   - **Build command** : *(laisser vide)*
   - **Publish directory** : `broderie`
4. **Deploy site**

À chaque `git push`, le site se met à jour automatiquement.

## Formulaire de contact

Le formulaire utilise **Netlify Forms** (gratuit jusqu'à 100 soumissions/mois). Aucune config nécessaire — les attributs `data-netlify="true"` et le champ caché `form-name` sont déjà en place. Les messages reçus apparaissent dans l'onglet **Forms** de votre site Netlify.
