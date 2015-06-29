#!/bin/bash

#
# Generating visualization data.
#
python scripts/csv_to_json/transform.py data/processed_data.csv http/data/unosat_product_data.json

#
# Run server.
#
http-server
