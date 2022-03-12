h=`hostname`
node_name="cam@${h}.riesd.com"
echo "Launching ${node_name}"

elixir --name $node_name --cookie MONSTER -S mix run --no-halt
