until $(curl --output /dev/null --silent --head --fail http://localhost:4000); do
  printf '.'
  sleep 5
done
