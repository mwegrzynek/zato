# -*- coding: utf-8 -*-

"""
Copyright (C) 2010 Dariusz Suchojad <dsuch at zato.io>

Licensed under LGPLv3, see LICENSE.txt for terms and conditions.
"""

from __future__ import absolute_import, division, print_function, unicode_literals

# Zato
from zato.cli import CACreateCommand, common_ca_create_opts

class Create(CACreateCommand):
    """ Creates crypto material for a Zato load-balancer agent
    """
    opts = [
        {'name':'organizational-unit', 'help':'Organizational unit name'},
    ]
    opts += common_ca_create_opts

    def get_file_prefix(self, file_args):
        return 'lb-agent'

    def get_organizational_unit(self, args):
        return 'zato-lb-agent'

    def execute(self, args, show_output=True):
        return self._execute(args, 'v3_server', show_output)
