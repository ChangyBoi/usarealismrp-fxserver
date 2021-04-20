# close FXServer
tmux kill-session -t fxserver

# run any setup needed before checking out this file
sh setup.sh

# pull from GH repo
git checkout . --recurse-submodules
git pull --recurse-submodules

# avoid scrambling node_modules within resources
cp -r resources/[system]/[builders] .
cp -r resources/ws_server/node_modules .
rm -f -r resources/[system]/[builders]
rm -f -r resources/ws_server/node_modules

# scramble resources
java -jar ResourceEventScrambler.jar

# move node_modules back into place
mv [builders] resources/[system]
mv node_modules resources/ws_server

# save last log file, create new one
mv CitizenFX.log CitizenFX.log.2

# clear chat log file
> /var/www/html/log.txt

# run server
tmux new -d -s fxserver "bash /home/ubuntu/FXServer/server/run.sh +exec server.cfg +set onesync on > CitizenFX.log"
