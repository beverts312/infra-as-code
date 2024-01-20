from flask import jsonify

import functions_framework


@functions_framework.http
def do_it(request):
    return jsonify({"dayOfTheWeek": "your mom"}), 200