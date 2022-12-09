Good-Night

### REQUIREMENT ###
```text
 We want to know how do you structure the code and design the API

==========================================

We would like you to implement a “good night” application to let users track when do they go to bed and when do they wake up.

We require some restful APIS to achieve the following:

1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records over the past week for their friends, ordered by the length of their sleep.

Please implement the model, db migrations, and JSON API.
You can assume that there are only two fields on the users “id” and “name”.

You do not need to implement any user registration API.

You can use any gems you like.
============================

After you finish the project, please send me your GitHub project link.

We want to see all of your development commits
```


### USAGE ###
1. Build Docker
```ruby
docker-compose build
docker-compose run web rake db:create db:migrate
docker-compose up -d
```
2. Api Doc
```ruby
http://localhost:3000/api-docs/index.html
```
