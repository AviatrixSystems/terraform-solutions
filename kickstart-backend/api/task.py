"""API views"""
import json
from multiprocessing import Process

from flask import request
from flask_restful import Resource
from utils.processes import (aws_configuration_process,
                             aws_aviatrax_subscription,
                             launch_controller,
                             launch_controller_skip,
                             launch_transit,
                             launch_aws_vpc,
                             aws_spoke_vpc,
                             delete_resources,
                             launch_transit_azure,
                             aws_azure_peering,
                             get_controller_ip)


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
            process = Process(target=aws_aviatrax_subscription, args=(command,))
            process.start()
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
        error = []

        email = self.data.get("email", None)
        if not email:
            error.append('Email Field Required')

        recovery_email = self.data.get("recovery_email", None)
        if not recovery_email:
            error.append('Recovery Email Field Required')

        password = self.data.get("password", None)
        if not password:
            error.append('Password Field Required')

        confirm_password = self.data.get("confirm_password", None)
        if not confirm_password:
            error.append('Confirm Password Field Required')

        if len(error) > 0:
            return {"error": error}, 400

        if confirm_password != password:
            return {"message": 'Password and Confirm Password are not same'}, 400

        process = Process(target=launch_controller,
                          args=(email, recovery_email, password, confirm_password))
        process.start()

        return {"message": "Controller Launched Successfully"}, 200


class SkipLaunchController(Resource):  # pylint: disable=too-few-public-methods
    """skipping Launch controller step"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """skipping Launch controller step"""
        error = []
        email = self.data.get("email", None)
        if not email:
            error.append('Email Field Required')

        password = self.data.get("password", None)
        if not password:
            error.append('Password Field Required')

        confirm_password = self.data.get("confirm_password", None)
        if not confirm_password:
            error.append('Confirm Password Field Required')

        if len(error) > 0:
            return {"error": error}, 400

        if confirm_password != password:
            return {"message": 'Password and Confirm Password are not same'}, 400

        process = Process(target=launch_controller_skip,
                          args=(email, password, confirm_password))
        process.start()

        return {"message": "Controller In progress"}, 200


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
            process = Process(target=launch_transit, args=(command,))
            process.start()
            return {"message": "Aviatrix Transit Launched Successfully"}, 200
        elif command is False:
            command = 'no'
            process = Process(target=launch_transit, args=(command,))
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


class SpokeVPCInstanceKeyName(Resource):  # pylint: disable=too-few-public-methods
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


class TransitAzureSkip(Resource):  # pylint: disable=too-few-public-methods
    """Skipping Azure transit"""

    def __init__(self):
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """Skipping Azure transit"""
        command = self.data.get("command", None)

        if command is True:
            process = Process(target=get_controller_ip, args=())
            process.start()

            return {"message": "Aviatrix Transit Skipped, Getting IP .."}, 200
        else:
            return {"message": "Unknown argument for this command"}, 200


class LaunchTransitAzure(Resource):  # pylint: disable=too-few-public-methods
    """Launching Aviatrix Transit in Azure"""

    def __init__(self):
        """getting and assigning data from api"""
        self.data = json.loads(request.data.decode('utf-8'))

    def post(self):
        """launch Aviatrix transit in azure """
        azure_subscription_id = self.data.get("azure_subscription_id", None)
        azure_directory_id = self.data.get("azure_directory_id", None)
        azure_application_id = self.data.get("azure_application_id", None)
        azure_application_key = self.data.get("azure_application_key", None)

        process = Process(target=launch_transit_azure, args=(
            azure_subscription_id, azure_directory_id,
            azure_application_id, azure_application_key))
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

        except FileNotFoundError:    # pylint:disable=undefined-variable
            msg = "No record found"
            return {"message": msg, "data": self.data}, 404

        return {"message": "Resource Data", "data": self.data}, 200
