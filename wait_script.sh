echo "Starting phoenix test server"
until $(curl --output /dev/null --silent --head --fail http://localhost:4001); do
  printf '.'
  sleep 5
done
