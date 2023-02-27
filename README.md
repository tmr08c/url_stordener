# URL Stord-ener

A URL Shortener created as a part of the Stord interview process.

The approach taken was to build via Phoenix and LiveView.

- The shortened URL creation workflow and stats pages are LiveViews.
- The redirection and stats CSV downloading are handled via traditional controllers.

## Demo

https://user-images.githubusercontent.com/691365/221703346-d8ea57dc-bc5d-4630-8a1c-3194799be65b.mp4

## Development

### Set up
To set up your local environment run

``` shell
bin/setup
```

### Running a server
To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Testing
Tests can be run via `mix` with:

``` shell
mix test
```

## Additional thoughts
When appropriate, I have tried to put assumptions or decisions in code comments or commits. I also put together [some benchmarks and thoughts on scaling](./scaling.md).
