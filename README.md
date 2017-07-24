# FlickrWalk

Simple proof of concept app that tracks your walking and fetches Flickr photos every 100m.

Possible Improvements:

- ability to pause/resume the walk
- show the photos on the map itself
- have multiple walks support
- persist walks in coredata storage

Known issues:

- parsing of Flickr API response is a mess! Would be much simpler with Swift4 JSON parsing or using a 3rd party lib like Gloss
- we could be more smart about presenting and caching of Flickr images

![Example walk](https://www.dropbox.com/s/e8ebdklywegl2h7/Screenshot%202017-07-24%2010.20.29.png?dl=1)

![The Map view](https://www.dropbox.com/s/k0xi8gno1qvj1m3/Screenshot%202017-07-24%2010.20.36.png?dl=1)
