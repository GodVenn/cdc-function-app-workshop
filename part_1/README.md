# Going from Flask App to Function App

- Pip install azure-functions​

- Add to requirements.txt

- Rename app.py -> function_app.py​

- Install [azure functions tools](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-python?pivots=python-mode-decorators&tabs=linux%2Cbash%2Cazure-cli%2Cbrowser#install-the-azure-functions-core-tools​):

- Run `func init --python`

- Delete generated `.gitignore` file

- Modify `function_app.py`
	- app = func.FunctionApp()​
	- Change @app.route format​
	- Change function signature to "req: func.HttpRequest" and get stuff id from route params​
	- Return func.HttpResponse​
	- Remove "if __main__..."​

- Add contents of .env file to local.settings.json in `values` section

- Remove flask and dotenv from requirements.txt​

- Remember /api/ appended to endpoint​ when testing
