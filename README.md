Acronis Cyber agent - docker image
For registering:
docker exec -it acronis_tenant1 /usr/lib/Acronis/RegisterAgentTool/RegisterAgent -a https://eu-cloud.acronis.com --token XXXX-XXXX-XXXX -o register -t cloud
docker exec -it acronis_tenant2 /usr/lib/Acronis/RegisterAgentTool/RegisterAgent -a https://eu-cloud.acronis.com --token YYYY-YYYY-YYYY -o register -t cloud
