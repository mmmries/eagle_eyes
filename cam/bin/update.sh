set -x

sudo apt-get install git python3-picamera ffmpeg elixir erlang-src erlang-dev
git pull
mix deps.get
mix deps.compile
sudo systemctl stop watchr.service
sudo cp watchr.service /etc/systemd/system/watchr.service
sudo systemctl daemon-reload
sudo systemctl start watchr.service
