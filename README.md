# README

# Authentification avec Ruby on Rails 7 et Devise

[Ce projet](https://authentification-with-devise-production.up.railway.app/) est une implémentation de l'authentification dans une application Ruby on Rails 7 en utilisant la gem Devise.

![Authentification_Capture](https://user-images.githubusercontent.com/85675011/233649523-2d30faac-3f3a-4780-84ba-b395c9433995.png)

## Prérequis

- Ruby on Rails 7
- Ruby 3.1.2
- Une base de données compatible avec Rails (par exemple, PostgreSQL, MySQL ou SQLite)

## Installation

1. Cloner le projet en utilisant une URL HTTPS ou SSH
```bash
git clone https://github.com/sandri31/Authentification-with-Devise.git
```
```bash
git clone git@github.com:sandri31/Authentification-with-Devise.git
```
2. Ouvrir le projet et installer les dépendances avec
```bash
cd Authentification-with-Devise
bundle install
```
3. Créer la base de données et lancer les migrations avec
```bash
rails db:create
rails db:migrate
```
4. Lancer le serveur
```bash
rails server
```
5. Ouvrir le navigateur à l'adresse http://localhost:3000

## Fonctionnalités

- Inscription des utilisateurs (pseudo, e-mail, mot de passe, confirmation du mot de passe)
- Connexion et déconnexion des utilisateurs
- Confirmation du compte par e-mail
- Réinitialisation du token d'authentification par e-mail
- Réinitialisation du mot de passe avec envoi d'e-mail
- OAuth avec Google / GitHub
- Messages d'erreur personnalisés
- Limitation du nombre de tentatives de connexion

## Licence

Ce projet est sous licence [MIT](https://opensource.org/licenses/MIT). Vous êtes libre de l'utiliser, de le modifier et de le redistribuer selon les termes de la licence.
