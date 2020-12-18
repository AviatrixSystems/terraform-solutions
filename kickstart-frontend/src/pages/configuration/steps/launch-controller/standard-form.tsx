import React, { Dispatch, useCallback } from "react";
import { Formik } from "formik";

import { Input, Button, Heading, Paragraph } from "components/base";
import { FORM_CONFIGS } from "utils/constants";
import { launchController } from "store/actions/configuration";
import { ConfigurationState } from "types/store";

interface ComponentProps {
  processedData: ConfigurationState["processedData"];
  pageDisabled: boolean;
  history: any;
  dispatch: Dispatch<any>;
}

const {
  launch_controller: { initialValues, validations },
} = FORM_CONFIGS;

export default function StandardForm(props: ComponentProps) {
  const { processedData = {}, pageDisabled, dispatch, history } = props;

  const onSubmit = useCallback(
    (values) => {
      dispatch(
        launchController(
          {
            email: values.email,
            recovery_email: values.email,
            password: values.password,
            confirm_password: values.confirm_password,
          },
          history
        )
      );
    },
    [dispatch, history]
  );
  const { controller } = processedData;
  const inputValues: typeof initialValues = controller
    ? {
        email: controller.email,
        password: controller.password,
        confirm_password: controller.confirm_password,
      }
    : initialValues;

  return (
    <Formik
      initialValues={inputValues}
      onSubmit={onSubmit}
      validationSchema={validations}
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
                    href="https://aws.amazon.com/marketplace/pp?sku=b03hn7ck7yp392plmk8bet56k"
                  >
                    https://aws.amazon.com/marketplace/pp?sku=b03hn7ck7yp392plmk8bet56k
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
            error={
              values.password !== values.confirm_password ||
              Boolean(errors.confirm_password)
            }
            helperText={
              values.password !== values.confirm_password
                ? "Password is not same"
                : errors.confirm_password
            }
            disabled={pageDisabled}
          />

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
  );
}
