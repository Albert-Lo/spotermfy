async = require 'async'
request = require 'request'

BASE = 'https://api.spotify.com/v1'

module.exports.search = (keyword, cb) ->
  request.get "#{BASE}/search?q=#{encodeURIComponent keyword}&type=album,track,artist&limit=20", {json: true}, (err, res, body) ->
    return cb(err || body) if err || res.statusCode != 200
    return cb(null, body.artists.items.concat(body.albums.items).concat(body.tracks.items))

module.exports.album = (id, cb) ->
  request.get "#{BASE}/albums/#{id}", {json: true}, (err, res, body) ->
    return cb(err || body) if err || res.statusCode != 200
    playAll =
      name: 'Play all'
      uri: body.uri
      type: 'album'
    return cb(null, {album: body, items: [playAll].concat(body.tracks.items)})

module.exports.artist = (id, cb) ->
  async.parallel
    'artist': (pCb) ->
      request.get "#{BASE}/artists/#{id}", {json: true}, (err, res, body) ->
        return pCb(err || body) if err || res.statusCode != 200
        pCb(null, body)
    'top': (pCb) ->
      request.get "#{BASE}/artists/#{id}/top-tracks?country=US", {json: true}, (err, res, body) ->
        return pCb(err || body) if err || res.statusCode != 200
        pCb(null, body)
    'related': (pCb) ->
      request.get "#{BASE}/artists/#{id}/related-artists", {json: true}, (err, res, body) ->
        return pCb(err || body) if err || res.statusCode != 200
        pCb(null, body)
    'albums': (pCb) ->
      request.get "#{BASE}/artists/#{id}/albums", {json: true}, (err, res, body) ->
        return pCb(err || body) if err || res.statusCode != 200
        pCb(null, body)
  , (err, results) ->
    return cb(err) if err
    {artist, top, related, albums} = results
    return cb(null, {artist: artist, items: top.tracks.concat(related.artists).concat(albums.items)})


