"""Firebase Cloud Functions entry point."""

import os
import sys

from firebase_functions import https_fn

# Add the src directory to the Python path
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "src"))

from app.main import create_app

# Create the Flask app
flask_app = create_app()


@https_fn.on_request()
def api(req: https_fn.Request) -> https_fn.Response:
    """Cloud Function that serves the Flask app."""
    with flask_app.request_context(req.environ):
        return flask_app.full_dispatch_request()
