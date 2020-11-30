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
  | "built_transit";
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
    controllerIP?: string;
  };
  message: string;
};

export type ControllerPayload = {
  email: string;
  recovery_email: string;
  password: string;
  confirm_password: string;
};
