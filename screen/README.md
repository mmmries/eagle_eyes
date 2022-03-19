# Screen

A phoenix app that collects video clips from the camera modules and provides a web UI
to review the footage on-demand.

This projet gets packaged up by the `vcr` app to be installed as firmware onto a raspberry
pi device.

## Local Development

This app requires no special setup. A simple `mix.deps.get` and `iex -S mix phx.server`
will get things started.
Normal commands like `mix test` to run the automated tests should work as expected.

If you have some sample mp4 files you can put them in `tmp/seeds` and give them names
of a unix timestamp and a `.mp4` suffix (ex `tmp/seeds/1647531822.mp4`) and then run
`mix ecto.setup` to provision a development database with a single camera and all of
the sample clips you put into the tmp directory.
