# README
[![forthebadge](https://forthebadge.com/images/badges/made-with-ruby.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/open-source.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)

![ScreenMagic](https://user-images.githubusercontent.com/85675011/198518511-894576e4-4b1e-43e4-938c-3099b2c7507c.png)

## Table des matières

- [Aperçu du projet](#aperçu-du-projet)
- [Prérequis](#prérequis)
- [Installation](#installation)
  - [Utilisation](#utilisation)
  - [Licence](#licence)
- [Tests](#tests)
- [Faits](#faits)

## Aperçu du projet

La problématique est la suivante : "Comment estimer la valeur de ma collection de cartes Magic The Gathering ?".  
Ayant trouvé aucune solution à mon gout, j'ai décidé de me lancer dans ce projet.  
Le but était ici de développer un système tout entier, qui permette de gérer sa propre collection de cartes Magic The Gathering, et de pouvoir voir l'estimation de celle-ci.

Ce projet est développé en Ruby on Rails pour le back-end, et utilise l'API REST de [Scryfall](https://scryfall.com/).  
J'utilise Bootstrap pour le front-end, et la gem Devise pour la gestion des utilisateurs.  
Pour la base de données, j'utilise PostgreSQL.

![ScreenMagic2](https://user-images.githubusercontent.com/85675011/198518404-3ec8a18e-a9c3-4805-8c62-c987d0e0cfa9.png)

### Prérequis
Vérifier que vous avez la bonne version de Ruby et de Rails installé sur votre machine.

```bash
ruby -v
rails -v
```
Ici, il nous faudra ruby '3.1.2' et rails '7.0.4'.

## Installation
Il faut cloner le projet sur votre machine,
et installer les gems nécessaires au projet.

```bash
git clone git@github.com:sandri31/Repaire-Magic-V1.git
bundle install
```

Il faut créer la base de données, et lancer les migrations.

```bash
rails db:create
rails db:migrate
```

Et enfin, lancer le serveur.

```bash
rails server
```

## Utilisation

Vous avez la possibilité de créer un compte utilisateur, de vous connecter et d'ajouter des cartes à votre collection de cartes Magic The Gathering (en cours de développement).
Et ainsi avoir une estimation en détail de votre propre collection de cartes.

Ou bien, faire une simple recherche de cartes et/ou voir une des plus de 70 000 cartes Magic The Gathering au hasard. Juste pour le fun.

![ScreenMagic4](https://user-images.githubusercontent.com/85675011/198519157-d78cfd39-bd73-4d9f-b45c-4b1c5a988d86.png)

Le site est actualisé régulièrement, et les cartes sont ajoutées au fur et à mesure.
Vous pouvez voir le site en production :
  - Rendez-vous sur ce lien : [www.repairemagic.fr](https://www.repairemagic.fr/)
  - Enjoy !

## Licence

Ce projet est sous licence [MIT](https://opensource.org/licenses/MIT). Vous êtes libre de l'utiliser, de le modifier et de le redistribuer selon les termes de la licence.

## Tests

Les tests sont en cours de développement.

## Faits

🃏 Le projet permet de gérer une collection de cartes Magic The Gathering et de voir son estimation  
💻 Il est développé en Ruby on Rails avec l'API REST de Scryfall  
🎨 Le front-end utilise Bootstrap et la gestion des utilisateurs est assurée par Devise  
🛠️ Les prérequis sont Ruby '3.1.2' et Rails '7.0.4'  
🚀 Le site est actualisé régulièrement avec l'ajout de nouvelles cartes  
📝 Le projet est sous licence libre et les contributions sont les bienvenues  
🙏 Remerciements à [Coding Accelerator](https://joincodingnow.com/) pour son aide  
