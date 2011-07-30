# Conway's Game of Life 
*John Conway's Game of Life simulation in Processing.js and Sinatra.*

### Installation
1. Download and unzip or clone this repository.
2. Run `$ bundle install without --production` for a development installation with sqlite3.
3. Change the path to the `.db` in `models.rb` to reflect the path where you've downloaded ConwaysGameOfLife.
4. Set up the database by the following:

        $ bundle exec irb
        irb> DataMapper.auto_migrate!

5. Now launch the app with `$ bundle exec ruby index.rb`.
6. Tell me if this readme doesn't make sense.

### Thanks
Thanks to [Dan Shiffman](https://github.com/shiffman) and his class _Nature of Code_ and [Greg Borenstein](https://github.com/atduskgreg)
for his help with Sinatra.

#### TODO
- Seed file for database.
- Previews of patterns in javascript
- Set up Warden for authentication
- Improve edge behavior
- Infinite canvas?