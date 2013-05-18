# -*- coding: utf-8 -*-

"""
Copyright (C) 2011 Dariusz Suchojad <dsuch at zato.io>

Licensed under LGPLv3, see LICENSE.txt for terms and conditions.
"""

from __future__ import absolute_import, division, print_function, unicode_literals

# stdlib
from contextlib import closing
from traceback import format_exc

# Zato
from zato.common.broker_message import MESSAGE_TYPE, OUTGOING
from zato.common.odb.model import OutgoingZMQ
from zato.common.odb.query import out_zmq_list
from zato.server.connection.zmq_.outgoing import start_connector
from zato.server.service.internal import AdminService, AdminSIO

class GetList(AdminService):
    """ Returns a list of outgoing ZeroMQ connections.
    """
    class SimpleIO(AdminSIO):
        request_elem = 'zato_outgoing_zmq_get_list_request'
        response_elem = 'zato_outgoing_zmq_get_list_response'
        input_required = ('cluster_id',)
        output_required = ('id', 'name', 'is_active', 'address', 'socket_type')
        
    def get_data(self, session):
        return out_zmq_list(session, self.request.input.cluster_id, False)

    def handle(self):
        with closing(self.odb.session()) as session:
            self.response.payload[:] = self.get_data(session)
        
class Create(AdminService):
    """ Creates a new outgoing ZeroMQ connection.
    """
    class SimpleIO(AdminSIO):
        request_elem = 'zato_outgoing_zmq_create_request'
        response_elem = 'zato_outgoing_zmq_create_response'
        input_required = ('cluster_id', 'name', 'is_active', 'address', 'socket_type')
        output_required = ('id', 'name')

    def handle(self):
        input = self.request.input
        with closing(self.odb.session()) as session:
            existing_one = session.query(OutgoingZMQ.id).\
                filter(OutgoingZMQ.cluster_id==input.cluster_id).\
                filter(OutgoingZMQ.name==input.name).\
                first()
            
            if existing_one:
                raise Exception('An outgoing ZeroMQ connection [{0}] already exists on this cluster'.format(input.name))
            
            try:
                item = OutgoingZMQ()
                item.name = input.name
                item.is_active = input.is_active
                item.address = input.address
                item.socket_type = input.socket_type
                item.cluster_id = input.cluster_id
                
                session.add(item)
                session.commit()
                
                start_connector(self.server.repo_location, item.id)
                
                self.response.payload.id = item.id
                self.response.payload.name = item.name
                
            except Exception, e:
                msg = 'Could not create an outgoing ZeroMQ connection, e:[{e}]'.format(e=format_exc(e))
                self.logger.error(msg)
                session.rollback()
                
                raise 

class Edit(AdminService):
    """ Updates an outgoing ZeroMQ connection.
    """
    class SimpleIO(AdminSIO):
        request_elem = 'zato_outgoing_zmq_edit_request'
        response_elem = 'zato_outgoing_zmq_edit_response'
        input_required = ('id', 'cluster_id', 'name', 'is_active', 'address', 'socket_type')
        output_required = ('id', 'name')

    def handle(self):
        input = self.request.input
        with closing(self.odb.session()) as session:
            existing_one = session.query(OutgoingZMQ.id).\
                filter(OutgoingZMQ.cluster_id==input.cluster_id).\
                filter(OutgoingZMQ.name==input.name).\
                filter(OutgoingZMQ.id!=input.id).\
                first()
            
            if existing_one:
                raise Exception('An outgoing ZeroMQ connection [{0}] already exists on this cluster'.format(input.name))
            
            try:
                item = session.query(OutgoingZMQ).filter_by(id=input.id).one()
                old_name = item.name
                item.name = input.name
                item.is_active = input.is_active
                item.address = input.address
                item.socket_type = input.socket_type
                
                session.add(item)
                session.commit()
                
                input.action = OUTGOING.ZMQ_EDIT
                input.old_name = old_name
                self.broker_client.publish(input, msg_type=MESSAGE_TYPE.TO_ZMQ_PUBLISHING_CONNECTOR_ALL)
                
                self.response.payload.id = item.id
                self.response.payload.name = item.name
                
            except Exception, e:
                msg = 'Could not update the outgoing ZeroMQ connection, e:[{e}]'.format(e=format_exc(e))
                self.logger.error(msg)
                session.rollback()
                
                raise  
        
class Delete(AdminService):
    """ Deletes an outgoing ZeroMQ connection.
    """
    class SimpleIO(AdminSIO):
        request_elem = 'zato_outgoing_zmq_delete_request'
        response_elem = 'zato_outgoing_zmq_delete_response'
        input_required = ('id',)

    def handle(self):
        with closing(self.odb.session()) as session:
            try:
                item = session.query(OutgoingZMQ).\
                    filter(OutgoingZMQ.id==self.request.input.id).\
                    one()
                
                session.delete(item)
                session.commit()

                msg = {'action': OUTGOING.ZMQ_DELETE, 'name': item.name, 'id':item.id}
                self.broker_client.publish(msg, MESSAGE_TYPE.TO_ZMQ_PUBLISHING_CONNECTOR_ALL)
                
            except Exception, e:
                session.rollback()
                msg = 'Could not delete the outgoing ZeroMQ connection, e:[{e}]'.format(e=format_exc(e))
                self.logger.error(msg)
                
                raise
