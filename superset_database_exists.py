#!/usr/bin/env python

"""
Exit 0 if the configured superset database exists, exit 1 otherwise.

Usage:

    export PYTHONPATH=/etc/superset
    python superset_database_exists.py

"""

import sys
import sqlalchemy, sqlalchemy.exc

from superset.config import SQLALCHEMY_DATABASE_URI

try:
    db = sqlalchemy.create_engine(SQLALCHEMY_DATABASE_URI)
    if not db.dialect.has_table(db.connect(), 'dashboards'):
        sys.exit(1)
except sqlalchemy.exc.OperationalError:
    sys.exit(1)

sys.exit(0)
