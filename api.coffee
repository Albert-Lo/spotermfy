request = require 'request'

BASE = 'https://api.spotify.com/v1'

module.exports.search = (keyword, cb) ->
  request.get "#{BASE}/search?q=#{encodeURIComponent keyword}&type=album,track,artist&limit=20", {json: true}, (err, res, body) ->
    return cb(err || body) if err || res.statusCode != 200
    return cb(null, body.artists.items.concat(body.albums.items).concat(body.tracks.items))

