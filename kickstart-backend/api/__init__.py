"""Url Files included"""
from app import app
from flask_restful import Api

from .task import (AwsConfiguration,
                   LaunchController,
                   SkipLaunchController,
                   SubscribeService,
                   LaunchTransitAWS,
                   LaunchAwsSpoke,
                   SpokeVPCInstanceKeyName,
                   LaunchTransitAzure,
                   AzureAwsPeering,
                   TransitAzureSkip,
                   GetStateStatus,
                   DeleteResource)

rest_server = Api(app)

rest_server.add_resource(AwsConfiguration, "/api/v1.0/aws-config")
rest_server.add_resource(SubscribeService, "/api/v1.0/subscribe-service")
rest_server.add_resource(LaunchController, "/api/v1.0/launch-controller")
rest_server.add_resource(SkipLaunchController, "/api/v1.0/skip-launch-controller")
rest_server.add_resource(LaunchTransitAWS, "/api/v1.0/launch-transit-aws")
rest_server.add_resource(LaunchAwsSpoke, "/api/v1.0/launch-ec2-spokevpc")
rest_server.add_resource(SpokeVPCInstanceKeyName, "/api/v1.0/set-key-spokevpc")
rest_server.add_resource(LaunchTransitAzure, "/api/v1.0/launch-transit-azure")
rest_server.add_resource(AzureAwsPeering, "/api/v1.0/peering")
rest_server.add_resource(TransitAzureSkip, "/api/v1.0/skip-transit-azure")
rest_server.add_resource(DeleteResource, "/api/v1.0/delete-resources")
rest_server.add_resource(GetStateStatus, "/api/v1.0/get-statestatus")
