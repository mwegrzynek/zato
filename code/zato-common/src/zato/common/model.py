# -*- coding: utf-8 -*-

"""
Copyright (C) 2019, Zato Source s.r.o. https://zato.io

Licensed under LGPLv3, see LICENSE.txt for terms and conditions.
"""

from __future__ import absolute_import, division, print_function, unicode_literals

# Unlike zato.common.odb.model - this place is where DB-independent models are kept,
# regardless if they're backed by an SQL database or not.

class FTPChannel(object):
    def __init__(self):
        self.id   = None            # type: int
        self.name = None            # type: str
        self.is_active = None       # type: bool
        self.max_connections = None # type: int
        self.max_conn_per_ip = None # type: int
        self.command_timeout = None # type: int
        self.banner = None          # type: str
        self.log_prefix = None      # type: str
        self.base_directory = None  # type: str
        self.read_throttle = None   # type: int
        self.write_throttle = None  # type: int
        self.log_level = None       # type: str
        self.service_name = None    # type: str
