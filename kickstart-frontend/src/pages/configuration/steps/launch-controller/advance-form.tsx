import React, { Dispatch, useCallback, useEffect } from "react";
import { Formik } from "formik";

import { Input, Button, Heading, Paragraph, Separator } from "components/base";
import { FORM_CONFIGS } from "utils/constants";
import {
  launchController,
  sendVariableCall,
} from "store/actions/configuration";
import { ConfigurationState } from "types/store";

interface ComponentProps {
  processedData: ConfigurationState["processedData"];
  step2_variables: ConfigurationState["step2_variables"];
  pageDisabled: boolean;
  history: any;
  dispatch: Dispatch<any>;
}

export default function AdvanceForm(props: ComponentProps) {
  const {
    launch_controller: { initialValuesAdvance, validationsAdvance },
  } = FORM_CONFIGS;
  const {
    pageDisabled,
    processedData = {},
    dispatch,
    history,
    step2_variables,
  } = props;
  const onSubmit = useCallback(
    (values) => {
      dispatch(
        launchController(
          {
            ...values,
            recovery_email: values.email,
          },
          history
        )
      );
    },
    [dispatch, history]
  );
  const { controller } = processedData;
  const inputValues: typeof initialValuesAdvance = controller
    ? {
        email: controller.email,
        password: controller.password,
        confirm_password: controller.confirm_password,
        az: step2_variables?.az || "",
        region: step2_variables?.region || "",
        vpc_cidr: step2_variables?.vpc_cidr || "",
        vpc_subnet: step2_variables?.vpc_subnet || "",
      }
    : {
        ...initialValuesAdvance,
        az: step2_variables?.az || "",
        region: step2_variables?.region || "",
        vpc_cidr: step2_variables?.vpc_cidr || "",
        vpc_subnet: step2_variables?.vpc_subnet || "",
      };

  useEffect(() => {
    dispatch(sendVariableCall("step2_variables", history));
  }, [dispatch, history]);

  return step2_variables ? (
    <Formik
      initialValues={inputValues}
      onSubmit={onSubmit}
      validationSchema={validationsAdvance}
      validate={(values) => {
        const errors: { confirm_password?: string } = {};
        if (
          values.password &&
          values.confirm_password &&
          values.password !== values.confirm_password
        ) {
          errors.confirm_password = "Password is not same";
        }
        return errors;
      }}
    >
      {({ values, handleChange, handleSubmit, errors }) => (
        <form onSubmit={handleSubmit} className="launch-controller-grid">
          <div className="text-block">
            <Heading customClasses="--dark" text="Launch Controller"></Heading>
            <Paragraph
              customClasses="--light"
              text={
                <span>
                  Enter email for controller password recovery and for Aviatrix
                  support to reach out in case of issues (the email will be
                  shared with Aviatrix) <br /> Perform the pre-requisites at{" "}
                  <a
                    target="blank"
                    href="https://aws.amazon.com/marketplace/pp/B08NTSDHKG"
                  >
                    https://aws.amazon.com/marketplace/pp/B08NTSDHKG
                  </a>{" "}
                  and subscribe to the Aviatrix platform. Click on "Continue to
                  subscribe", and accept the terms. Do NOT click on "Continue to
                  Configuration".
                </span>
              }
            ></Paragraph>
          </div>
          <Input
            value={values.email}
            name="email"
            label="Email Address"
            variant="outlined"
            fullWidth={false}
            customClasses="--small --blue"
            onChange={handleChange}
            error={Boolean(errors.email)}
            helperText={errors.email}
            disabled={pageDisabled}
          />
          <Input
            type="password"
            value={values.password}
            name="password"
            label="Password"
            variant="outlined"
            fullWidth={false}
            customClasses="--small --blue"
            onChange={handleChange}
            error={Boolean(errors.password)}
            helperText={errors.password}
            disabled={pageDisabled}
          />
          <Input
            type="password"
            value={values.confirm_password}
            name="confirm_password"
            label="Re-enter Password"
            fullWidth={false}
            variant="outlined"
            customClasses="--small --blue"
            onChange={handleChange}
            error={Boolean(errors.confirm_password)}
            helperText={errors.confirm_password}
            disabled={pageDisabled}
          />

          <>
            <Separator />
            <Input
              value={values.region}
              name="region"
              label="Region"
              variant="outlined"
              fullWidth={false}
              customClasses="--small --blue"
              onChange={handleChange}
              error={Boolean(errors.region)}
              helperText={errors.region}
              disabled={pageDisabled}
            />
            <Input
              value={values.az}
              name="az"
              label="Availability Zone"
              fullWidth={false}
              variant="outlined"
              customClasses="--small --blue"
              onChange={handleChange}
              error={Boolean(errors.az)}
              helperText={errors.az}
              disabled={pageDisabled}
            />
            <Separator />
            <Heading
              customClasses="--dark --sub-heading"
              text="VPC CIDR & Subnet"
            ></Heading>
            <Input
              value={values.vpc_cidr}
              name="vpc_cidr"
              label="VPC CIDR"
              variant="outlined"
              fullWidth={false}
              customClasses="--small --blue"
              onChange={handleChange}
              error={Boolean(errors.vpc_cidr)}
              helperText={errors.vpc_cidr}
              disabled={pageDisabled}
            />
            <Input
              value={values.vpc_subnet}
              name="vpc_subnet"
              label="VPC Subnet"
              fullWidth={false}
              variant="outlined"
              customClasses="--small --blue"
              onChange={handleChange}
              error={Boolean(errors.vpc_subnet)}
              helperText={errors.vpc_subnet}
              disabled={pageDisabled}
            />{" "}
          </>
          <span>
            <Button
              disabled={pageDisabled}
              type="submit"
              variant="contained"
              customClasses=" --blue"
            >
              Continue
            </Button>
          </span>
        </form>
      )}
    </Formik>
  ) : (
    <div />
  );
}
