"""Url Files included"""
from app import app
from flask_restful import Api

from .task import (ModeSelection,
                   AwsConfiguration,
                   LaunchController,
                   SubscribeService,
                   LaunchTransitAWS,
                   LaunchAwsSpoke,
                   SetSpokeVPCKey,
                   LaunchTransitAzure,
                   AzureAwsPeering,
                   AzureTransitSkip,
                   GetStateStatus,
                   DeleteResource,
                   GetStep2Variables,
                   GetStep3Variables,
                   GetStep6Variables,)

rest_server = Api(app)

rest_server.add_resource(ModeSelection, "/api/v1.0/mode-selection")
rest_server.add_resource(AwsConfiguration, "/api/v1.0/aws-config")
rest_server.add_resource(SubscribeService, "/api/v1.0/subscribe-service")
rest_server.add_resource(LaunchController, "/api/v1.0/launch-controller")
rest_server.add_resource(LaunchTransitAWS, "/api/v1.0/launch-transit-aws")
rest_server.add_resource(LaunchAwsSpoke, "/api/v1.0/launch-ec2-spokevpc")
rest_server.add_resource(SetSpokeVPCKey, "/api/v1.0/set-key-spokevpc")
rest_server.add_resource(LaunchTransitAzure, "/api/v1.0/launch-transit-azure")
rest_server.add_resource(AzureAwsPeering, "/api/v1.0/peering")
rest_server.add_resource(AzureTransitSkip, "/api/v1.0/skip-transit-azure")
rest_server.add_resource(DeleteResource, "/api/v1.0/delete-resources")
rest_server.add_resource(GetStateStatus, "/api/v1.0/get-statestatus")
rest_server.add_resource(GetStep2Variables, "/api/v1.0/step2-variables")
rest_server.add_resource(GetStep3Variables, "/api/v1.0/step3-variables")
rest_server.add_resource(GetStep6Variables, "/api/v1.0/step6-variables")
