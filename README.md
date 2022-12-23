Good-Night

### REQUIREMENT ###
```
1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records over the past week for their friends, ordered by the length of their sleep.

```


### USAGE ###
1. Build Docker
```ruby
docker-compose build
docker-compose run web -d rake db:setup db:create db:migrate
docker-compose up -d
```
2. Api Doc
```ruby
http://localhost:3000/api-docs/index.html
```
3. Basic DB Schema

![DbSchema GUI](/public/1670579125759@2x.jpg "DbSchema")
