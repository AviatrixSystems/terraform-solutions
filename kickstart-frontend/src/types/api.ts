export type UrlNames =
  | "delete_config"
  | "get_status"
  | "add_credentials"
  | "launch_controller"
  | "launch_transit_aws"
  | "launch_spokevpc"
  | "launch_ec2"
  | "launch_transit_azure"
  | "skip_transit_azure"
  | "built_transit"
  | "set_is_advance"
  | "step2_variables"
  | "step3_variables"
  | "step6_variables";
export type UrlConfigs = {
  [key in UrlNames]: {
    url: string;
    method: "POST" | "GET" | "PUT" | "DELETE" | "PATCH";
    headers?: { [key: string]: string };
    data?: { [key: string]: string };
  };
};

export type SimpleMessageResponse = {
  message: string;
};

export type DeleteConfigResponse = SimpleMessageResponse;

export type AddAWSCredentialsResponse = SimpleMessageResponse;

export type GetStepResponse = {
  data: {
    status: "success" | "in-progress" | "failed";
    state: number;
    stateName: string;
    error: string[] | null;
    progress: string | null;
    processedData: {
      awsConfigurations?: {
        key_id: string;
        secret_key: string;
      };
      controller?: {
        confirm_password: string;
        email: string;
        password: string;
        recovery_email: string;
      };
      launchAviatrixTransit?: {
        state: "yes" | "no";
      };
      ec2SpokeVpc?: {
        state: "yes" | "no";
      };
      avaitrixTransitAzure?: {
        state: "yes" | "no";
      };
      peering?: {
        state: "yes" | "no";
      };
    };
    controllerIP?: string;
    ips?: {
      privateSpokeVm1: string;
      privateSpokeVm2: string;
      publicSpokeVm1: string;
      publicSpokeVm2: string;
    };
    is_advance?: boolean;
  };
  message: string;
};

export type Step2Variables = {
  data: {
    region: string;
    az: string;
    vpc_cidr: string;
    vpc_subnet: string;
  };
  message: string;
};

export type Step3Variables = {
  data: {
    aws_region: string;
    aws_transit_vpc_name: string;
    aws_transit_vpc_cidr: string;
    aws_spoke1_vpc_name: string;
    aws_spoke1_vpc_cidr: string;
    aws_spoke2_vpc_name: string;
    aws_spoke2_vpc_cidr: string;
    aws_transit_gateway_name: string;
    aws_spoke1_gateways_name: string;
    aws_spoke2_gateways_name: string;
  };
  message: string;
};

export type Step6Variables = {
  data: {
    azure_region: string;
    azure_vnets_name: string;
    azure_vnets_name_cidr: string;
    azure_spoke1_vnet_name: string;
    azure_spoke1_vnet_cidr: string;
    azure_spoke2_vnet_name: string;
    azure_spoke2_vnet_cidr: string;
    azure_transit_gateway: string;
    azure_spoke1_gateways_name: string;
    azure_spoke2_gateways_name: string;
  };
  message: string;
};

export type ControllerPayload = {
  email: string;
  recovery_email: string;
  password: string;
  confirm_password: string;
};
