# About

This is a sample app we made to allow technical exercises to happen the best way possible.

All the resources needed to run and test the app can be provided by GitHub Codespaces.

This means you don't need to run the project locally nor configure your dev environment for it.

You don't need more than your browser to accomplish this exercise, but we recommend you use VS Code integration.

VS Code will improve the experience while the app runs at GitHub Codespaces.

You can also run it locally if you prefer, the GitHub Codespaces is here to help in case you don't want to install and run the app locally.


## How to run the project on GitHub Codespaces
- Go to Code button > Codespaces > New codespace > Select machine type (2-core should be enough).
- Here's a quick recording on how that works...
![4PejIoe4p8](https://user-images.githubusercontent.com/6395112/157670995-0340ce21-2ec1-4796-9df3-601f073004a5.gif)
- Either on browser or VSCode, you will end up in a shell console, from there you can run all the Rails commands you may already be used to.
- When setting up a brand new Codespace ensure to create a `tmp` folder in the main directory. It's in the `.gitignore` and won't cause a change. 
- Probably because of the containers, you may need to run commands with `sudo`:
  - `sudo bundle install`
  - `sudo rails db:setup`
  - `sudo bin/dev` to run the server
  - `sudo bin/rspec` to run the test suite

## How to run the project locally
- You should be able to achieve that at this point 😄

## How to submit your test

- Do not push a branch to remote since other candidates can see your branch.
- Once you are finished:
  1. create a private repo and share access with the users: @renatonitta, @wilsondealmeida, and @dhawt
  2. send us a short update as mentioned in the "Engineering Take-Home (Step 4)" document
