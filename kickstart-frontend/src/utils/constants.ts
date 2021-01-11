import { UrlConfigs } from "types/api";
import * as yup from "yup";

export const SEC_15 = 15000;
const emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i;
const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
const ipRegex = /([1-9]|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])(\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])){3}\/\d+/;
const ipInvalidMessage = "Need with IP with subnet mask";

export const ROUTES = {
  configuration: "/configuration",
  credentials: "/configuration/1",
  launch_controller: "/configuration/2",
  launch_transit_aws: "/configuration/3",
  launch_ec2: "/configuration/4",
  import_key_pair: "/configuration/5",
  launch_transit_azure: "/configuration/6",
  built_transit: "/configuration/7",
};

export const FORM_CONFIGS = {
  credentials_form: {
    initialValues: {
      access_key_id: "",
      secret_access_key: "",
    },
    validations: yup.object({
      access_key_id: yup.string().required("Required"),
      secret_access_key: yup.string().required("Required"),
    }),
  },
  launch_controller: {
    initialValues: {
      email: "",
      password: "",
      confirm_password: "",
    },
    initialValuesAdvance: {
      email: "",
      password: "",
      confirm_password: "",
      region: "",
      az: "",
      vpc_cidr: "",
      vpc_subnet: "",
    },
    validations: yup.object({
      email: yup
        .string()
        .required("Required")
        .matches(emailRegex, "Must be a valid email"),
      password: yup
        .string()
        .required("Required")
        .matches(
          passwordRegex,
          "Must Contain 8 Characters, One Uppercase, One Lowercase, One Number and one special case Character"
        ),
      confirm_password: yup.string().required("Required"),
    }),
    validationsAdvance: yup.object({
      email: yup
        .string()
        .required("Required")
        .matches(emailRegex, "Must be a valid email"),
      password: yup
        .string()
        .required("Required")
        .matches(
          passwordRegex,
          "Must Contain 8 Characters, One Uppercase, One Lowercase, One Number and one special case Character"
        ),
      confirm_password: yup.string().required("Required"),
      region: yup.string().required("Required"),
      az: yup.string().required("Required"),
      vpc_cidr: yup
        .string()
        .required("Required")
        .matches(ipRegex, ipInvalidMessage),
      vpc_subnet: yup
        .string()
        .required("Required")
        .matches(ipRegex, ipInvalidMessage),
    }),
  },
  launch_transit_aws: {
    initialValues: {
      aws_region: "",
      aws_transit_vpc_name: "",
      aws_transit_vpc_cidr: "",
      aws_spoke1_vpc_name: "",
      aws_spoke1_vpc_cidr: "",
      aws_spoke2_vpc_name: "",
      aws_spoke2_vpc_cidr: "",
      aws_transit_gateway_name: "",
      aws_spoke1_gateways_name: "",
      aws_spoke2_gateways_name: "",
    },
    validations: yup.object({
      aws_region: yup.string().required("Required"),
      aws_transit_vpc_name: yup.string().required("Required"),
      aws_transit_vpc_cidr: yup
        .string()
        .required("Required")
        .matches(ipRegex, ipInvalidMessage),
      aws_spoke1_vpc_name: yup.string().required("Required"),
      aws_spoke1_vpc_cidr: yup
        .string()
        .required("Required")
        .matches(ipRegex, ipInvalidMessage),
      aws_spoke2_vpc_name: yup.string().required("Required"),
      aws_spoke2_vpc_cidr: yup
        .string()
        .required("Required")
        .matches(ipRegex, ipInvalidMessage),
      aws_transit_gateway_name: yup.string().required("Required"),
      aws_spoke1_gateways_name: yup.string().required("Required"),
      aws_spoke2_gateways_name: yup.string().required("Required"),
    }),
  },
  import_key_pair: {
    initialValues: {
      key_pair_name: "",
    },
    validations: yup.object({
      key_pair_name: yup.string().required("Required"),
    }),
  },
  launch_transit_azure: {
    initialValues: {
      azure_subscription_id: "",
      azure_directory_id: "",
      azure_application_id: "",
      azure_application_key: "",
    },
    initialValuesAdvance: {
      azure_subscription_id: "",
      azure_directory_id: "",
      azure_application_id: "",
      azure_application_key: "",
      azure_region: "",
      azure_vnets_name: "",
      azure_vnets_name_cidr: "",
      azure_spoke1_vnet_name: "",
      azure_spoke1_vnet_cidr: "",
      azure_spoke2_vnet_name: "",
      azure_spoke2_vnet_cidr: "",
      azure_transit_gateway: "",
      azure_spoke1_gateways_name: "",
      azure_spoke2_gateways_name: "",
    },
    validations: yup.object({
      azure_subscription_id: yup.string().required("Required"),
      azure_directory_id: yup.string().required("Required"),
      azure_application_id: yup.string().required("Required"),
      azure_application_key: yup.string().required("Required"),
    }),
    validationsAdvance: yup.object({
      azure_subscription_id: yup.string().required("Required"),
      azure_directory_id: yup.string().required("Required"),
      azure_application_id: yup.string().required("Required"),
      azure_application_key: yup.string().required("Required"),
      azure_region: yup.string().required("Required"),
      azure_vnets_name: yup.string().required("Required"),
      azure_vnets_name_cidr: yup
        .string()
        .required("Required")
        .matches(ipRegex, ipInvalidMessage),
      azure_spoke1_vnet_name: yup.string().required("Required"),
      azure_spoke1_vnet_cidr: yup
        .string()
        .required("Required")
        .matches(ipRegex, ipInvalidMessage),
      azure_spoke2_vnet_name: yup.string().required("Required"),
      azure_spoke2_vnet_cidr: yup
        .string()
        .required("Required")
        .matches(ipRegex, ipInvalidMessage),
      azure_transit_gateway: yup.string().required("Required"),
      azure_spoke1_gateways_name: yup.string().required("Required"),
      azure_spoke2_gateways_name: yup.string().required("Required"),
    }),
  },
};

export const URL_CONFIGS: UrlConfigs = {
  get_status: {
    method: "GET",
    url: "/get-statestatus",
  },
  delete_config: {
    method: "DELETE",
    url: "/delete-resources",
  },
  add_credentials: {
    method: "POST",
    url: "/aws-config",
  },
  launch_controller: {
    method: "POST",
    url: "/launch-controller",
  },
  launch_transit_aws: {
    method: "POST",
    url: "/launch-transit-aws",
  },
  launch_ec2: {
    method: "POST",
    url: "/launch-ec2-spokevpc",
  },
  launch_spokevpc: {
    method: "POST",
    url: "/set-key-spokevpc",
  },
  launch_transit_azure: {
    method: "POST",
    url: "/launch-transit-azure",
  },
  skip_transit_azure: {
    method: "POST",
    url: "/skip-transit-azure",
  },
  built_transit: {
    method: "POST",
    url: "/peering",
  },
  set_is_advance: {
    method: "POST",
    url: "/mode-selection",
  },
  step2_variables: {
    method: "GET",
    url: "/step2-variables",
  },
  step3_variables: {
    method: "GET",
    url: "/step3-variables",
  },
  step6_variables: {
    method: "GET",
    url: "/step6-variables",
  },
};
