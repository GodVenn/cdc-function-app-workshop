# Infrastructure deployment

Deploy function app with app service plan:

- `az deployment group create --subscription "Development" -g "cdc-function-app-workshop" --parameters function_app.bicepparam --parameters shortName="<your-shortname>" --name "Local-Deploy-Function-App-<your-shortname>"`
