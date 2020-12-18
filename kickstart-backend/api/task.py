"""API views"""
import json
from multiprocessing import Process

import hcl
from flask import request
from flask_restful import Resource
from utils.processes import (mode_selection,
                             aws_configuration_process,
                             launch_controller,
                             launch_transit,
                             launch_aws_vpc,
                             aws_spoke_vpc,
                             delete_resources,
                             launch_transit_azure,
                             skip_azure_transit,
                             aws_azure_peering)


class ModeSelection(Resource):  # pylint: disable=too-few-public-methods
    """Setting AWS key id and secret key"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """post call data  set in .aws file"""
        key = self.data.get("is_advance", None)
        if type(key) == bool:
            process = Process(target=mode_selection,
                              args=(key,))
            process.start()
            return {"message": 'Mode Selected Successfully'}, 200
        else:
            return {"message": 'Invalid key'}, 200


class AwsConfiguration(Resource):  # pylint: disable=too-few-public-methods
    """Setting AWS key id and secret key"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """post call data  set in .aws file"""
        key_id = self.data.get("key_id", None)
        secret_key = self.data.get("secret_key", None)

        process = Process(target=aws_configuration_process,
                          args=(key_id, secret_key))
        process.start()
        return {"message": 'AWS Configuration Updated Successfully'}, 200


class SubscribeService(Resource):  # pylint: disable=too-few-public-methods
    """Subscribe Service"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """Return a subscribe link"""
        command = self.data.get("command", None)

        if command is True:
            command = 'yes'
            subscription_link = 'https://aws.amazon.com/marketplace/' \
                                'fulfillment?productId=' \
                                'b9d94495-81b3-4cd6-acf5-10bd5010197c&ref_=dtl_psb_continue'

            return {"message": subscription_link}, 200
        else:
            return {"message": 'Subscription Skipped'}, 200


class LaunchController(Resource):  # pylint: disable=too-few-public-methods
    """Launching controller"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """Launch controller take get email , username and recovery email"""
        process = Process(target=launch_controller,
                          args=(self.data,))
        process.start()

        return {"message": "Controller Launched Successfully"}, 200


class LaunchTransitAWS(Resource):  # pylint: disable=too-few-public-methods
    """Launching Aviatrix Transit"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """launch Aviatrix transit by command"""
        command = self.data.get("command", None)

        if command is True:
            command = 'yes'
            process = Process(target=launch_transit, args=(self.data, command))
            process.start()
            return {"message": "Aviatrix Transit Launched Successfully"}, 200
        elif command is False:
            command = 'no'
            process = Process(target=launch_transit, args=(self.data, command))
            process.start()
            return {"message": "Skipped Aviatrix Transit"}, 200


class LaunchAwsSpoke(Resource):  # pylint: disable=too-few-public-methods
    """Launching Aviatrix Transit"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """launch Aviatrix transit by command"""
        command = self.data.get("command", None)
        if command is True:
            process = Process(target=launch_aws_vpc, args=(command,))
            process.start()
            return {"message": "EC2 instances in AWS Spoke VPCs Initiated Successfully"}, 200
        elif command is False:
            process = Process(target=launch_aws_vpc, args=(command,))
            process.start()
            return {"message": "EC2 instances in AWS Spoke VPCs Skipped"}, 200


class SetSpokeVPCKey(Resource):  # pylint: disable=too-few-public-methods
    """Launching VPC instance"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """Launching VPC instance"""
        keyname = self.data.get("keyname", None)
        process = Process(target=aws_spoke_vpc, args=(keyname,))
        process.start()

        return {"message": "EC2 instances in AWS Spoke VPCs Launched Successfully"}, 200


class AzureTransitSkip(Resource):  # pylint: disable=too-few-public-methods
    """Skipping Azure transit"""

    def __init__(self):
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """Skipping Azure transit"""
        command = self.data.get("command", None)

        if command is True:
            process = Process(target=skip_azure_transit, args=(command,))
            process.start()
            return {"message": "Aviatrix Transit Skipped"}, 200
        else:
            return {"message": "Unknown argument for this command"}, 200


class LaunchTransitAzure(Resource):  # pylint: disable=too-few-public-methods
    """Launching Aviatrix Transit in Azure"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """launch Aviatrix transit in azure """
        process = Process(target=launch_transit_azure, args=(self.data,))
        process.start()
        return {"message": "Launched Aviatrix Transit in Azure Successfully"}, 200


class AzureAwsPeering(Resource):  # pylint: disable=too-few-public-methods
    """peering between azure and aws"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """launch avitric transit in azure """
        command = self.data.get("command", None)

        if command is True:
            command = 'yes'
            process = Process(target=aws_azure_peering, args=(
                command,))
            process.start()
            return {"message": "Transit Peering between AWS & Azure Built Successfully"}, 200
        elif command is False:
            command = 'no'
            process = Process(target=aws_azure_peering, args=(
                command,))
            process.start()
            return {"message": "Transit Peering between AWS & Azure Skipped"}, 200


class DeleteResource(Resource):  # pylint: disable=too-few-public-methods
    """Deletion of recourses"""

    def __init__(self):
        """getting and assigning data from api"""
        self.message = "Reset Successfully"

    def delete(self):
        """Deleting terraform resource"""
        process = Process(target=delete_resources, args=())
        process.start()
        return {"message": self.message}, 200


class GetStateStatus(Resource):  # pylint: disable=too-few-public-methods
    """get status of state and data"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = {}

    def get(self):
        """Get state of process """
        try:
            with open('state.txt') as json_file:
                self.data = json.load(json_file)

        except FileNotFoundError:  # pylint:disable=undefined-variable
            msg = "No record found"
            return {"message": msg}, 404
        except ValueError:
            return {"message": 'file is not ready'}, 206
        return {"message": "Resource Data", "data": self.data}, 200


class GetStep2Variables(Resource):
    """get step2 variables data"""

    def get(self):
        """Get step2 var data from controller variable file"""
        with open('/root/controller/variables.tf', 'r') as fp:
            controler_vars = hcl.load(fp)

        data = {
            'region': controler_vars['variable']['region']['default'],
            'az': controler_vars['variable']['az']['default'],
            'vpc_cidr': controler_vars['variable']['vpc_cidr']['default'],
            'vpc_subnet': controler_vars['variable']['vpc_subnet']['default'],
        }
        return {"message": "State 2 data ", "data": data}, 200


class GetStep3Variables(Resource):
    """get step3 variables data"""

    def get(self):
        """Get step3 var data from mcna variable file"""
        with open('/root/mcna/variables.tf', 'r') as fp:
            mcna_vars = hcl.load(fp)

        data = {
            'aws_region': mcna_vars
            ['variable']['aws_region']['default'],
            'aws_transit_vpc_name':
                mcna_vars['variable']['aws_transit_vpcs']['default']['aws_transit_vpc']['name'],
            'aws_transit_vpc_cidr':
                mcna_vars['variable']['aws_transit_vpcs']['default']['aws_transit_vpc']['cidr'],
            'aws_spoke1_vpc_name':
                mcna_vars['variable']['aws_spoke_vpcs']['default']['aws_spoke1_vpc']['name'],
            'aws_spoke1_vpc_cidr':
                mcna_vars['variable']['aws_spoke_vpcs']['default']['aws_spoke1_vpc']['cidr'],
            'aws_spoke2_vpc_name':
                mcna_vars['variable']['aws_spoke_vpcs']['default']['aws_spoke2_vpc']['name'],
            'aws_spoke2_vpc_cidr':
                mcna_vars['variable']['aws_spoke_vpcs']['default']['aws_spoke2_vpc']['cidr'],
            'aws_transit_gateway_name':
                mcna_vars['variable']['aws_transit_gateway']['default']['name'],
            'aws_spoke1_gateways_name':
                mcna_vars['variable']['aws_spoke_gateways']['default']['spoke1']['name'],
            'aws_spoke2_gateways_name':
                mcna_vars['variable']['aws_spoke_gateways']['default']['spoke2']['name'],
        }
        return {"message": "State 3 data ", "data": data}, 200


class GetStep6Variables(Resource):
    """get step6 variables data"""

    def get(self):
        """Get step6 var data from mcna variables file"""
        with open('/root/mcna/variables.tf', 'r') as fp:
            mcna_azure = hcl.load(fp)

        data = {
            'azure_region':
                mcna_azure['variable']['azure_region']['default'],
            'azure_vnets_name':
                mcna_azure['variable']['azure_vnets']['default']['azure_transit_vnet']['name'],
            'azure_vnets_name_cidr':
                mcna_azure['variable']['azure_vnets']['default']['azure_transit_vnet']['cidr'],
            'azure_spoke1_vnet_name':
                mcna_azure['variable']['azure_vnets']['default']['azure_spoke1_vnet']['name'],
            'azure_spoke1_vnet_cidr':
                mcna_azure['variable']['azure_vnets']['default']['azure_spoke1_vnet']['cidr'],
            'azure_spoke2_vnet_name':
                mcna_azure['variable']['azure_vnets']['default']['azure_spoke2_vnet']['name'],
            'azure_spoke2_vnet_cidr':
                mcna_azure['variable']['azure_vnets']['default']['azure_spoke2_vnet']['cidr'],
            'azure_transit_gateway':
                mcna_azure['variable']['azure_transit_gateway']['default']['name'],
            'azure_spoke1_gateways_name':
                mcna_azure['variable']['azure_spoke_gateways']['default']['spoke1']['name'],
            'azure_spoke2_gateways_name':
                mcna_azure['variable']['azure_spoke_gateways']['default']['spoke2']['name'],
        }
        return {"message": "State 6 data updated", "data": data}, 200
