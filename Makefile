.PHONY: preview

preview:
	cd docs && . .venv/bin/activate && mkdocs serve --dev-addr=0.0.0.0:8000