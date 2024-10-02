# Deploying app content to Azure

1. Zip the necessary files (Or use the pre-zipped one)
	- `zip -r app.zip src function_app.py host.json requirements.txt`
2. Deploy the zipped folder
	- `az functionapp deployment source config-zip --subscription Development -g cdc-function-app-workshop -n <shortname>-workshop-function-app --src app.zip`
3. Test function app
	- `curl -iL https://<shortname>-workshop-function-app.azurewebsites.net/api/get_stuff/123`
