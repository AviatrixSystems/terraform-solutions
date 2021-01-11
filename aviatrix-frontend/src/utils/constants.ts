import * as yup from "yup";

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
      email_address: "",
      recovery_email_address: "",
      password: "",
      re_enter_password: "",
    },
    validations: yup.object({
      email_address: yup.string().required("Required"),
      recovery_email_address: yup.string().required("Required"),
      password: yup.string().required("Required"),
      re_enter_password: yup.string().required("Required"),
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
      subscription_id: "",
      directory_id: "",
      application_id: "",
      application_key: "",
    },
    validations: yup.object({
      subscription_id: yup.string().required("Required"),
      directory_id: yup.string().required("Required"),
      application_id: yup.string().required("Required"),
      application_key: yup.string().required("Required"),
    }),
  },
};
