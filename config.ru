#rackup -E production -D -s thin

$LOAD_PATH.unshift 'lib'
require 'app'
run App
