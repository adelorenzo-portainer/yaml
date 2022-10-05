curl --request POST \
--insecure \
--write-out "%{http_code}" \
--header 'Content-Type: application/json' \
--header 'x-api-key: ptr_8ksmAh5X6WUfBcTb41NM++1XvwZu+aZlEakVDVmjAFo=' \
--url 'https://PORTAINER SERVER:PORT/api/tags' --data '{"name": "TAG NAME"}'
